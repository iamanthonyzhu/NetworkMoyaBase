//
//  NZAlamoSmartResponseDeserializer.m
//  nfzm
//
//  Created by anthony zhu on 2023/5/4.
//

#import "NZAlamoSmartResponseDeserializer.h"
#import <YYModel/NSObject+YYModel.h>
#import "NZNetworkEnvelopProtocol.h"
/**
 判空并处理
 
 @param JSonObject 原始的请求响应数据
 @return 去null后的j响应数据
 */
static id NZAlamoSmartJSonObjectByRemovingKeysWithNullValue(id JSonObject) {
    if ([JSonObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        NSDictionary *dictJSon = (NSDictionary *)JSonObject;
        NSArray *allKeys = dictJSon.allKeys;
        for (id key in allKeys) {
            @autoreleasepool {
                id value = dictJSon[key];
                if (!value
                    || ([value isKindOfClass:[NSString class]] && [value isEqualToString:@"null"])
                    || [value isEqual:[NSNull null]]) {
                    continue;
                }
                [tempDict setObject:NZAlamoSmartJSonObjectByRemovingKeysWithNullValue(dictJSon[key]) forKey:key];
            }
        }
        return [tempDict copy];
    } else if ([JSonObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [NSMutableArray array];
        NSArray *arrayJSon = (NSArray *)JSonObject;
        for (id element in arrayJSon) {
            @autoreleasepool {
                [tempArray addObject:NZAlamoSmartJSonObjectByRemovingKeysWithNullValue(element)];
            }
        }
        return [tempArray copy];
    } else {
        return JSonObject;
    }
}

/**
 获取请求状态码
 
 @param response 请求响应
 @return 响应的状态码
 */
inline NSInteger NZAlamoSmartResponseStatusCode(NSURLResponse *response) {
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        return ((NSHTTPURLResponse *)response).statusCode;
    }
    return 0;
}

inline id NZAlamoSmartResponseJsonData(NSData *responseData) {
    id JSonObject;
    NSError *error;
    if (responseData.length > 0) {
        JSonObject = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    }
    // 过滤掉JSonObject中的nil null NULL
    if (JSonObject) {
        JSonObject = NZAlamoSmartJSonObjectByRemovingKeysWithNullValue(JSonObject);
    }
    return JSonObject;
}

/**
 获取响应model的类别
 *  优先读取缓存
 *  没有缓存，则按照优先级规则拼出来：
 *  1、EM【开头】+Method+APIName+Rsp【结尾】
 *  2、EM【开头】+APINameRsp【结尾】
 
 @param APIName 接口名称 不包含URL
 @param method 请求的方法：GET or POST
 @return response解析的model类别
 */
//inline Class NZAlamoSmartResponseModelClass(NSString *APIName, NSString *method) {
//    static CFMutableDictionaryRef cache;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        cache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
//    });
//
//    APIName = APIName.length ? APIName : @"";
//    // method第一个字母大写,后面字母全小写
//    method = method.length ? [[method substringToIndex:1].uppercaseString stringByAppendingString:[method substringFromIndex:1].lowercaseString] :@"";
//    // 优先取缓存。Method+APIName作为key存入字典
//    NSString *key = [method stringByAppendingString:APIName];
//    Class cls = CFDictionaryGetValue(cache, (__bridge const void *)(key));
//    if (cls) {
//        return cls;
//    }
//    // 没有缓存，则按规则拼接
//    NSMutableString *partialClsName = [NSMutableString stringWithCapacity:APIName.length];
//    NSArray *arrComponents = [APIName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/._"]];
//    for (NSString *compnent in arrComponents) {
//        if (compnent.length < 1) {
//            continue;
//        }
//        [partialClsName appendString:[compnent substringToIndex:1].uppercaseString];
//        [partialClsName appendString:[compnent substringFromIndex:1]];
//    }
//    cls = NSClassFromString([NSString stringWithFormat:@"EM%@%@Rsp", method, partialClsName]);
//    if (cls) {
//        CFDictionarySetValue(cache, (__bridge const void *)(key), (__bridge const void *)(cls));
//        return cls;
//    }
//    cls = NSClassFromString([NSString stringWithFormat:@"EM%@Rsp", partialClsName]);
//    if (cls) {
//        CFDictionarySetValue(cache, (__bridge const void *)(key), (__bridge const void *)(cls));
//        return cls;
//    }
//    return nil;
//}
//

@implementation NZAlamoSmartResponseDeserializer

+ (instancetype)serializer {
    NZAlamoSmartResponseDeserializer *serializer = [self new];
    return serializer;
}

+ (id<NZNetworkEnvelopProtocol>)deserializeDataByEnvelopClass:(Class)envCls modelClass:(Class _Nullable)modelCls dataClass:(Class _Nullable)dataCls data:(id)JSONObject {
    
    // 原始response为nil
//        if (*error && !JSONObject) {
//            JSONObject = [EMSmartNetworkingError errorResponseObjectWithError:*error];
//        }
    // NSData格式时
    if ([JSONObject isKindOfClass:[NSData class]]) {
        id JsonData = NZAlamoSmartResponseJsonData(JSONObject);
        if (JsonData) {
            JSONObject = JsonData;
        } else { // 不是json格式的，直接解析成字符串返回
            JSONObject = [[NSString alloc] initWithData:JSONObject encoding:NSUTF8StringEncoding];
            //*error = nil;
            if (![JSONObject hasPrefix:@"{"]) {
                return nil;
            }
        }
    }
    id<NZNetworkEnvelopProtocol> envObject = [[self class] deserializerResponse:JSONObject WithEnvelopeClass:envCls];
    if (envObject && [envObject respondsToSelector:@selector(getData)] && modelCls) {
        id deserializerModel = [[self class] deserializerResponse:[envObject getData] withModelClass:modelCls];
        if (deserializerModel && [envObject respondsToSelector:@selector(setBizData:)]) {
            [envObject setBizData:deserializerModel];
        }
    }
    return envObject;
}

+ (id<NZNetworkEnvelopProtocol>)deserializerResponse:(id)JSONObject WithEnvelopeClass:(Class)envelopeClass {
    id formatJSONObject = NZAlamoSmartJSonObjectByRemovingKeysWithNullValue(JSONObject);
    if ([envelopeClass respondsToSelector:@selector(netdataWithObject:)]) {
        return [envelopeClass performSelector:@selector(netdataWithObject:) withObject:JSONObject];
    }
    return formatJSONObject;
}

+ (id)deserializerResponse:(id<NZNetworkEnvelopProtocol>)bizData withModelClass:(Class)modelClass {
    id deserializerModel;
    if ([bizData isKindOfClass:[NSDictionary class]]) {
        if ([modelClass respondsToSelector:@selector(yy_modelWithJSON:)]) {
            deserializerModel = [modelClass yy_modelWithJSON:bizData];
        }
    } else if ([bizData isKindOfClass:[NSArray class]]) {
        deserializerModel = [NSArray yy_modelArrayWithClass:modelClass json:bizData];
    }
    return deserializerModel;
}

@end
