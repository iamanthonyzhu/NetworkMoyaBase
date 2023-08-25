//
//  NZAlamoSmartResponseDeserializer.h
//  nfzm
//
//  Created by anthony zhu on 2023/5/4.
//

#import <Foundation/Foundation.h>
#import "NZNetworkEnvelopProtocol.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundefined-inline"

extern inline NSInteger NZAlamoSmartResponseStatusCode(NSURLResponse *response);

extern inline id NZAlamoSmartResponseJsonData(NSData * responseData);

extern inline Class NZAlamoSmartResponseModelClass(NSString *APIName, NSString *method);
#pragma clang diagnostic pop

NS_ASSUME_NONNULL_BEGIN

@interface NZAlamoSmartResponseDeserializer : NSObject

+ (id<NZNetworkEnvelopProtocol>)deserializeDataByEnvelopClass:(Class)envCls modelClass:(Class _Nullable)modelCls dataClass:(Class _Nullable)dataCls data:(id)JSONObject;

@end

NS_ASSUME_NONNULL_END
