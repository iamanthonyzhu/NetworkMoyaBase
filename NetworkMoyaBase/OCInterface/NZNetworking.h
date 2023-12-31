//
//  NZNetWorking.h
//  BaseApp
//
//  Created by anthony zhu on 2021/12/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NZNetData.h"
#import "NZNetworkingMacros.h"

extern NSString *const kNZReachabilityChangedNotification;
    
typedef void (^NZNetWorkingBlock)(NZNetData *data);

typedef NSURL *(^NZNetworkingDestination)(NSURL *targetPath, NSURLResponse *response);

typedef BOOL (^NZErrorHandleBlock)(NZNetData *data);


@interface NZNetworking : NSObject

@property(nonatomic, assign) AlamoSmartNetStatus netStatus;

- (instancetype)initWithParams;

+ (NZNetworking *) shared;

/// 网络状态
@property (nonatomic, assign) AlamoSmartNetStatus networkStatus;


#pragma mark - 设置头部信息
/**
 *  设置头信息
 *
 *  @param value 值
 *  @param key   键
 */
- (void)setHeader:(NSString *)value forKey:(NSString *)key;

/**
 *  设置校验sign
 *
 *  @param sign 校验
 */
- (void)setSign:(NSString *)sign;

/**
 *  设置sessionToken
 *
 *  @param sessionToken token值
 */
- (void)setSessionToken:(NSString *)sessionToken;

/**
 *  网络是否连通
 *
 */
- (BOOL)networkReachable;

#pragma mark - block异步请求
- (MoyaNetStub *) get:(NSString *)url callback:(NZNetWorkingBlock)block;

- (MoyaNetStub *) get:(NSString *)url timeout:(CGFloat)interval callback:(NZNetWorkingBlock)block;

- (MoyaNetStub *) get:(NSString *)url parameters:(NSDictionary *)params callback:(NZNetWorkingBlock)block;
  
- (MoyaNetStub *) get:(NSString *)url parameters:(NSDictionary *)params timeout:(CGFloat)interval callback:(NZNetWorkingBlock)block;

- (MoyaNetStub *) get:(NSString *)url parameters:(NSDictionary *)params modelCls:(Class)modelCls timeout:(CGFloat)interval callback:(NZNetWorkingBlock)block;

- (MoyaNetStub *) put:(NSString *)url callback:(NZNetWorkingBlock)block;

- (MoyaNetStub *) put:(NSString *)url timeout:(CGFloat)interval callback:(NZNetWorkingBlock)block;

- (MoyaNetStub *) put:(NSString *)url parameters:(NSDictionary *)params callback:(NZNetWorkingBlock)block;

- (MoyaNetStub *) put:(NSString *)url parameters:(NSDictionary *)params timeout:(CGFloat)interval callback:(NZNetWorkingBlock)block;

- (MoyaNetStub *) put:(NSString *)url parameters:(NSDictionary *)params modelCls:(Class)modelCls timeout:(CGFloat)interval callback:(NZNetWorkingBlock)block;

- (MoyaNetStub *) post:(NSString *)url callback:(NZNetWorkingBlock)block;

- (MoyaNetStub *) post:(NSString *)url timeout:(CGFloat)interval callback:(NZNetWorkingBlock)block;

- (MoyaNetStub *) post:(NSString *)url parameters:(NSDictionary *)params callback:(NZNetWorkingBlock)block;

- (MoyaNetStub *) post:(NSString *)url parameters:(NSDictionary *)params timeout:(CGFloat)interval callback:(NZNetWorkingBlock)block;

- (MoyaNetStub *)post:(NSString *)url parameters:(NSDictionary *)params modelCls:(Class)modelCls timeout:(CGFloat)interval callback:(NZNetWorkingBlock)block;

- (MoyaNetStub *) postImage:(NSString *)url parameters:(NSDictionary *)params data:(NSData *)data dataKey:(NSString *)dataKey callback:(NZNetWorkingBlock)block;

- (MoyaNetStub *) delete:(NSString *)url callback:(NZNetWorkingBlock)block;

- (MoyaNetStub *) delete:(NSString *)url timeout:(CGFloat)interval callback:(NZNetWorkingBlock)block;

- (MoyaNetStub *) delete:(NSString *)url parameters:(NSDictionary *)params callback:(NZNetWorkingBlock)block;

- (MoyaNetStub *) delete:(NSString *)url parameters:(NSDictionary *)params timeout:(CGFloat)interval callback:(NZNetWorkingBlock)block;

- (MoyaNetStub *) head:(NSString *)url;

- (MoyaNetStub *) head:(NSString *)url parameters:(NSDictionary *)params;

#pragma mark - 错误码处理
- (void) setErrorHandleBlock:(NZErrorHandleBlock)errorHandleBlock forErrorCode:(NSString *)errorCode;
- (void) removeErrorHandlerBlockForErrorCode:(NSString *)errorCode;

#pragma mark - 下载文件
- (id) download:(NSString *)url downloading:(void(^)(CGFloat progress))downloadingBlock finishedBlock:(NZNetWorkingBlock)block;
- (id) download:(NSString *)url downloading:(void(^)(CGFloat progress))downloadingBlock destination:(NZNetworkingDestination)destBlock finishedBlock:(NZNetWorkingBlock)block;

- (id) upload:(NSString *)url withFilePath:(NSString *)filePath parameters:(NSDictionary *)parameters callback:(NZNetWorkingBlock)block;
- (id) upload:(NSString *)url filePath:(NSURL *)fileURL parameters:(NSDictionary *)parameters callback:(NZNetWorkingBlock)block;
- (id) upload:(NSString *)url withImage:(UIImage *)image parameters:(NSDictionary *)parameters callback:(NZNetWorkingBlock)block;

- (id)upload:(NSString *)url
      withImage:(UIImage *)image
      imageName:(NSString *)imageName
       mimeType:(NSString *)mimeType
     parameters:(NSDictionary *)parameters
      modelCls:(Class)modelCls
       callback:(NZNetWorkingBlock)block;

- (id)uploadVideoWithURL:(NSString *)url
                  videoURL:(NSURL *)videoURL
                 videoName:(NSString *)videoName
                  mimeType:(NSString *)mimeType
                parameters:(NSDictionary *)parameters
                  callback:(NZNetWorkingBlock)block;

- (id)uploadFileWithURL:(NSString *)url
                  fileURL:(NSURL *)fileURL
               parameters:(NSDictionary *)parameters
                 callback:(NZNetWorkingBlock)block;

/// 传入文件名（含后缀），返回mimeType；
- (NSString *)contentTypeForPathExtension:(NSString *)extension;

@end
