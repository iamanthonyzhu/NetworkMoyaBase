
//  EatNetWorking.m
//  BaseApp
//
//  Created by anthony zhu on 2021/12/24.
//

#import "NZNetworking.h"
#import "NZNetworkingConfiguration.h"
#import "NZAlamoSmartResponseDeserializer.h"

static CGFloat nzTime_out = 30.f;
static CGFloat nzUploadTime_out = 60.f;
static CGFloat nzDownloadTime_out = 60.f;

NSString * const kNZReachabilityChangedNotification = @"kNZReachabilityChangedNotification";

@interface NZNetworking ()

@property(nonatomic, strong) NSMutableDictionary *errorHandlerBlocks;
@property(nonatomic, strong) NSMutableDictionary *downloadProgressDic;
@property(nonatomic, strong) NSMutableDictionary *downloadingBlockDic;
@property(nonatomic, strong) NSMutableDictionary *downloadTimerDic;


@property(nonatomic, strong) NSLock *lock;

@end


@implementation NZNetworking
{
    NSString *_sessionToken;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithParams{
    self = [super init];
    if (self) {
        
        self.errorHandlerBlocks = [NSMutableDictionary dictionary];
        self.lock = [[NSLock alloc] init];
        self.lock.name = @"nzNetWorkingLock";
        
        [[NZNetworkingConfiguration sharedInstance] setPlatform:@"iOS"];
        
        _netStatus = AlamoSmartNetStatusUnknown;
        [[NZAlamoSmartNetAgent shared] startReachabilityMonitoringWithListener:^(enum AlamoSmartNetStatus netStatus) {
            self.netStatus = netStatus;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNZReachabilityChangedNotification object:@(netStatus)];
        }];
    
    }
    return self;
}

+ (NZNetworking *) shared
{
    static NZNetworking *client;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        client = [[NZNetworking alloc] initWithParams];
    });
    return client;
}

#pragma mark - 配置
- (void)setHeader:(NSString *)value forKey:(NSString *)key
{
    [[NZNetworkingConfiguration sharedInstance] setHeader:value forKey:key];
}

- (void)removeHeaderForKey:(NSString *)key
{
    [[NZNetworkingConfiguration sharedInstance] removeHeaderForKey:key];
}

- (void)setSign:(NSString *)sign
{
    [[NZNetworkingConfiguration sharedInstance] setSign:sign];
}

- (void)setSessionToken:(NSString *)sessionToken
{
    [[NZNetworkingConfiguration sharedInstance] setSessionToken:sessionToken];
}

#pragma mark - 网络监听

- (void)setNetStatus:(AlamoSmartNetStatus)netStatus
{
    _netStatus = netStatus;
    NSLog(@"network status set as %@",[[self class] netStatusDescription:netStatus]);
}

+ (NSString *)netStatusDescription:(AlamoSmartNetStatus)netStatus {
    NSString *str = @"Unknown";
    switch (netStatus) {
        case AlamoSmartNetStatusUnknown:
            str = @"Unknown";
            break;
        case AlamoSmartNetStatusNotReachable:
            str = @"Not Reachable";
            break;
        case AlamoSmartNetStatusConnectViaCellular:
            str = @"Cellular";
            break;
        case AlamoSmartNetStatusConnectViaEthOrWifi:
            str = @"EthOrWifi";
            break;
    }
    return str;
}


#pragma mark - 公共调用接口

- (BOOL)networkReachable {
    if (_netStatus == AlamoSmartNetStatusNotReachable || _netStatus == AlamoSmartNetStatusUnknown) {
        return NO;
    }
    return YES;
}

///get method
- (MoyaNetStub *)get:(NSString *)url callback:(NZNetWorkingBlock)block
{
    return [self get:url parameters:nil timeout:nzTime_out callback:block];
}

- (MoyaNetStub *)get:(NSString *)url timeout:(CGFloat)interval callback:(NZNetWorkingBlock)block
{
    return [self get:url parameters:nil timeout:interval callback:block];
}

- (MoyaNetStub *)get:(NSString *)url parameters:(NSDictionary *)params callback:(NZNetWorkingBlock)block {
    return [self get:url parameters:params timeout:nzTime_out callback:block];
}

- (MoyaNetStub *)get:(NSString *)url parameters:(NSDictionary *)params timeout:(CGFloat)interval callback:(NZNetWorkingBlock)block {
    return [self get:url parameters:params modelCls:nil timeout:interval callback:block];
}
- (MoyaNetStub *)get:(NSString *)url parameters:(NSDictionary *)params modelCls:(Class)modelCls timeout:(CGFloat)interval callback:(NZNetWorkingBlock)block
{
    if (self.netStatus == AlamoSmartNetStatusNotReachable) {
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block([NZNetData badNetData]);
            });
        }
    } else {
        return [[NZAlamoSmartNetAgent shared] get:url parameters:params.allKeys.count>0?params:nil success:^(NSURLSessionTask *task, id responseData) {
            id parsedObject = [NZAlamoSmartResponseDeserializer deserializeDataByEnvelopClass:[NZNetData class] modelClass:modelCls dataClass:nil data:responseData];
            if (block) {
                block(parsedObject);
            }
        } failure:^(NSURLSessionTask *task, NSError * error, id response) {
            NZNetData *netData = [NZNetData errorData:error];
            [self handlerErrorWithNetData:netData url:url parameters:params method:@"get" timeout:interval callback:block];
        } timeout:interval>0?@(interval):nil];
    }
    return nil;
}

- (MoyaNetStub *)put:(NSString *)url callback:(NZNetWorkingBlock)block
{
    return [self put:url parameters:nil timeout:nzTime_out callback:block];
}

- (MoyaNetStub *)put:(NSString *)url timeout:(CGFloat)interval callback:(NZNetWorkingBlock)block
{
    return [self put:url parameters:nil timeout:interval callback:block];
}

- (MoyaNetStub *)put:(NSString *)url parameters:(NSDictionary *)params callback:(NZNetWorkingBlock)block {
    return [self put:url parameters:params timeout:nzTime_out callback:block];
}

- (MoyaNetStub *)put:(NSString *)url parameters:(NSDictionary *)params timeout:(CGFloat)interval callback:(NZNetWorkingBlock)block {
    return [self put:url parameters:params modelCls:nil timeout:interval callback:block];
}


- (MoyaNetStub *)put:(NSString *)url parameters:(NSDictionary *)params modelCls:(Class)modelCls timeout:(CGFloat)interval callback:(NZNetWorkingBlock)block {
    if (self.netStatus == AlamoSmartNetStatusNotReachable) {
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block([NZNetData badNetData]);
            });
        }
    } else {
        return [[NZAlamoSmartNetAgent shared] put:url parameters:nil bodyData:params.allKeys.count>0?params:nil success:^(NSURLSessionTask *task, id responseData) {
            id parsedObject = [NZAlamoSmartResponseDeserializer deserializeDataByEnvelopClass:[NZNetData class] modelClass:modelCls dataClass:nil data:responseData];
            if (block) {
                block(parsedObject);
            }
        } failure:^(NSURLSessionTask *task, NSError * error, id response) {
            NZNetData *netData = [NZNetData errorData:error];
            [self handlerErrorWithNetData:netData url:url parameters:params method:@"put" timeout:interval callback:block];
        } timeout:interval>0?@(interval):nil];

    }
    return nil;
}


- (MoyaNetStub *)post:(NSString *)url callback:(NZNetWorkingBlock)block
{
    return [self post:url parameters:nil timeout:nzTime_out callback:block];
}

- (MoyaNetStub *)post:(NSString *)url timeout:(CGFloat)interval callback:(NZNetWorkingBlock)block
{
    return [self post:url parameters:nil timeout:interval callback:block];
}

- (MoyaNetStub *)post:(NSString *)url parameters:(NSDictionary *)params callback:(NZNetWorkingBlock)block {
    return [self post:url parameters:params timeout:nzTime_out callback:block];
}

- (MoyaNetStub *)post:(NSString *)url parameters:(NSDictionary *)params timeout:(CGFloat)interval callback:(NZNetWorkingBlock)block {
    return [self post:url parameters:params modelCls:nil timeout:interval callback:block];
}

- (MoyaNetStub *)post:(NSString *)url parameters:(NSDictionary *)params modelCls:(Class)modelCls timeout:(CGFloat)interval callback:(NZNetWorkingBlock)block {
    if (self.netStatus == AlamoSmartNetStatusNotReachable) {
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block([NZNetData badNetData]);
            });
        }
    } else {
        return [[NZAlamoSmartNetAgent shared] post:url parameters:nil bodyData:params.allKeys.count>0?params:nil success:^(NSURLSessionTask *task, id responseData) {
            id parsedObject = [NZAlamoSmartResponseDeserializer deserializeDataByEnvelopClass:[NZNetData class] modelClass:modelCls dataClass:nil data:responseData];
            if (block) {
                block(parsedObject);
            }
        } failure:^(NSURLSessionTask *task, NSError * error, id response) {
            NZNetData *netData = [NZNetData errorData:error];
            [self handlerErrorWithNetData:netData url:url parameters:params method:@"post" timeout:interval callback:block];
        } timeout:interval>0?@(interval):nil];

    }
    return nil;
}

- (MoyaNetStub *)postImage:(NSString *)url parameters:(NSDictionary *)params data:(NSData *)data dataKey:(NSString *)dataKey callback:(NZNetWorkingBlock)block;
{
    //NSInputStream *input = [[NSInputStream alloc] initWithData:data];
    return [[NZAlamoSmartNetAgent shared] postInputStreamData:url parameters:params.allKeys.count>0?params:nil data:data length:data.length name:dataKey fileName:[NSString stringWithFormat:@"%@.jpg", dataKey]  mimeType:@"image/jpeg" progress:^(NSProgress * progress) {
        //do nothing
    } success:^(NSURLSessionTask * task, id responseData) {
        if (block) {
            block(responseData);
        }
    } failure:^(NSURLSessionTask * task, NSError * error, id response) {
        NZNetData *netData = [NZNetData errorData:error];
        [self handlerErrorWithNetData:netData url:url parameters:params method:@"post" timeout:nzTime_out callback:block];
    } timeout:@(nzUploadTime_out)];
}

- (MoyaNetStub *)delete:(NSString *)url callback:(NZNetWorkingBlock)block
{
    return [self delete:url parameters:nil timeout:nzTime_out callback:block];
}

- (MoyaNetStub *)delete:(NSString *)url timeout:(CGFloat)interval callback:(NZNetWorkingBlock)block
{
    return [self delete:url parameters:nil timeout:interval callback:block];
}

- (MoyaNetStub *)delete:(NSString *)url parameters:(NSDictionary *)params callback:(NZNetWorkingBlock)block {
    return [self delete:url parameters:params timeout:nzTime_out callback:block];
}

- (MoyaNetStub *)delete:(NSString *)url parameters:(NSDictionary *)params timeout:(CGFloat)interval callback:(NZNetWorkingBlock)block
{
    if (self.netStatus == AlamoSmartNetStatusNotReachable) {
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block([NZNetData badNetData]);
            });
        }
    } else {
        return [[NZAlamoSmartNetAgent shared] delete:url parameters:params.allKeys.count>0?params:nil bodyData:nil success:^(NSURLSessionTask *task, id responseData) {
            id parsedObject = [NZAlamoSmartResponseDeserializer deserializeDataByEnvelopClass:[NZNetData class] modelClass:nil dataClass:nil data:responseData];
            if (block) {
                block(parsedObject);
            }
        } failure:^(NSURLSessionTask *task, NSError * error, id response) {
            NZNetData *netData = [NZNetData errorData:error];
            [self handlerErrorWithNetData:netData url:url parameters:params method:@"delete" timeout:interval callback:block];
        } timeout:interval>0?@(interval):nil];

    }
    return nil;
}

- (MoyaNetStub *)head:(NSString *)url
{
    return [self head:url parameters:nil];
}

- (MoyaNetStub *)head:(NSString *)url parameters:(NSDictionary *)params
{
    return [[NZAlamoSmartNetAgent shared] head:url parameters:params.allKeys.count>0?params:nil bodyData:nil success:^(NSURLSessionTask *task, id responseData) {
        
    } failure:^(NSURLSessionTask *task, NSError * error, id response) {
        
    } timeout:@(nzTime_out)];
}


#pragma mark - 错误处理
- (void)setErrorHandleBlock:(NZErrorHandleBlock)errorHandleBlock forErrorCode:(NSString *)errorCode
{
    if (errorHandleBlock) {
        [self.lock lock];
        [self.errorHandlerBlocks setObject:errorHandleBlock forKey:errorCode];
        [self.lock unlock];
    }
}

- (void)removeErrorHandlerBlockForErrorCode:(NSString *)errorCode
{
    [self.lock lock];
    [self.errorHandlerBlocks removeObjectForKey:errorCode];
    [self.lock unlock];
}

#pragma mark - 下载文件
- (MoyaNetStub *)download:(NSString *)url downloading:(void(^)(CGFloat progress))downloadingBlock finishedBlock:(NZNetWorkingBlock)block
{
    return [self download:url downloading:downloadingBlock destination:nil finishedBlock:block];
}

- (MoyaNetStub *)download:(NSString *)url downloading:(void(^)(CGFloat progress))downloadingBlock destination:(NZNetworkingDestination)destBlock finishedBlock:(NZNetWorkingBlock)block
{
    if (self.netStatus == AlamoSmartNetStatusNotReachable) {
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block([NZNetData badNetData]);
            });
        }
        return nil;
    } else {
        __block NSURL *destPath = nil;
        return [[NZAlamoSmartNetAgent shared] download:url parameters:nil destination:^NSURL *(NSURL * targetPath, NSURLResponse * response) {
            if (destBlock) {
                return destBlock(targetPath,response);
            }
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            destPath = [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
            return destPath;
        } progress:^(NSProgress * progress) {
            if (downloadingBlock) {
                CGFloat total = progress.totalUnitCount + 0.0;
                CGFloat completed = progress.completedUnitCount + 0.0;
                if (total == 0) {
                    return;
                }
                CGFloat p = completed / total;
                if (p < 0) {
                   NSLog(@"进度异常（总：%f，完成：%f）：%f", total, completed, p);
                   return;
                }
                if (p < 1) {
                    if (![[NSThread currentThread] isMainThread]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            downloadingBlock(p);
                        });
                    } else {
                        downloadingBlock(p);
                    }
                }
            }
        } success:^(NSURLSessionTask * session, id response) {
            if (downloadingBlock) {
                downloadingBlock(1);
            }
            if (block) {
                block([NZNetData netdataWithObject:destPath]);
            }
        } failure:^(NSURLSessionTask * task, NSError * error, id response) {
            if (block) {
                block([NZNetData errorData:error]);
            }
        } timeout:@(nzDownloadTime_out)];
    }

}

#pragma mark - 上传文件
- (MoyaNetStub *)upload:(NSString *)url withFilePath:(NSString *)filePath parameters:(NSDictionary *)parameters callback:(NZNetWorkingBlock)block
{
    if (self.netStatus == AlamoSmartNetStatusNotReachable) {
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block([NZNetData badNetData]);
            });
        }
        return nil;
    } else {
        NSURL *file = [NSURL fileURLWithPath:filePath];
        return [[NZAlamoSmartNetAgent shared] postFileUrl:url parameters:parameters.allKeys.count>0?parameters:nil fileUrl:file name:@"file" progress:nil success:^(NSURLSessionTask * task, id responseObject) {
            NSLog(@"Success: %@", responseObject);
            id parsedObject = [NZAlamoSmartResponseDeserializer deserializeDataByEnvelopClass:[NZNetData class] modelClass:nil dataClass:nil data:responseObject];
            if (block) {
                block(parsedObject);
            }
        } failure:^(NSURLSessionTask * task, NSError * error, id response) {
            NSLog(@"Error: %@", error);
            if (block) {
                block([NZNetData errorData:error]);
            }
        } timeout:@(nzUploadTime_out)];
    }
}

- (MoyaNetStub *)upload:(NSString *)url filePath:(NSURL *)fileURL parameters:(NSDictionary *)parameters callback:(NZNetWorkingBlock)block
{
    if (self.netStatus == AlamoSmartNetStatusNotReachable) {
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block([NZNetData badNetData]);
            });
        }
        return nil;
    } else {
        if (!url || !fileURL) {
            if (block) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block([NZNetData badNetData]);
                });
            }
            return nil;
        }
        NSData *data = [NSData dataWithContentsOfURL:fileURL];
        return [[NZAlamoSmartNetAgent shared] postFileData:url parameters:parameters.allKeys.count>0?parameters:nil data:data name:@"log" fileName:@"file.zip" mimeType:@"application/zip" progress:nil success:^(NSURLSessionTask * task, id responseObject) {
            NSLog(@"Success: %@", responseObject);
            id parsedObject = [NZAlamoSmartResponseDeserializer deserializeDataByEnvelopClass:[NZNetData class] modelClass:nil dataClass:nil data:responseObject];
            if (block) {
                block(parsedObject);
            }
        } failure:^(NSURLSessionTask * task, NSError * error, id response) {
            NSLog(@"Error: %@", error);
            if (block) {
                block([NZNetData errorData:error]);
            }
        } timeout:@(nzUploadTime_out)];
    }
}

- (MoyaNetStub *)upload:(NSString *)url withImage:(UIImage *)image parameters:(NSDictionary *)parameters callback:(NZNetWorkingBlock)block
{
    if (self.netStatus == AlamoSmartNetStatusNotReachable) {
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block([NZNetData badNetData]);
            });
        }
        return nil;
    } else {
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        return [[NZAlamoSmartNetAgent shared] postFileData:url parameters:parameters.allKeys.count>0?parameters:nil data:data name:@"headimage" fileName:@"image" mimeType:@"image/jpeg" progress:nil success:^(NSURLSessionTask * task, id responseObject) {
            NSLog(@"Success: %@", responseObject);
            id parsedObject = [NZAlamoSmartResponseDeserializer deserializeDataByEnvelopClass:[NZNetData class] modelClass:nil dataClass:nil data:responseObject];
            if (block) {
                block(parsedObject);
            }
        } failure:^(NSURLSessionTask * task, NSError * error, id response) {
            NSLog(@"Error: %@", error);
            if (block) {
                block([NZNetData errorData:error]);
            }
        } timeout:@(nzUploadTime_out)];
    }
}

- (MoyaNetStub *)upload:(NSString *)url
      withImage:(UIImage *)image
      imageName:(NSString *)imageName
       mimeType:(NSString *)mimeType
     parameters:(NSDictionary *)parameters
      modelCls:(Class)modelCls
       callback:(NZNetWorkingBlock)block
{
    if (self.netStatus == AlamoSmartNetStatusNotReachable) {
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block([NZNetData badNetData]);
            });
        }
        return nil;
    } else {
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        return [[NZAlamoSmartNetAgent shared] postFileData:url parameters:parameters.allKeys.count>0?parameters:nil data:data name:@"file" fileName:imageName? :@"" mimeType:mimeType progress:nil success:^(NSURLSessionTask * task, id responseObject) {
            NSLog(@"Success: %@", responseObject);
            id parsedObject = [NZAlamoSmartResponseDeserializer deserializeDataByEnvelopClass:[NZNetData class] modelClass:modelCls dataClass:nil data:responseObject];
            if (block) {
                block(parsedObject);
            }
        } failure:^(NSURLSessionTask * task, NSError * error, id response) {
            NSLog(@"Error: %@", error);
            if (block) {
                block([NZNetData errorData:error]);
            }
        } timeout:@(nzUploadTime_out)];
    }
}

- (MoyaNetStub *)uploadVideoWithURL:(NSString *)url
                  videoURL:(NSURL *)videoURL
                 videoName:(NSString *)videoName
                  mimeType:(NSString *)mimeType
                parameters:(NSDictionary *)parameters
                  callback:(NZNetWorkingBlock)block
{
    if (self.netStatus == AlamoSmartNetStatusNotReachable) {
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block([NZNetData badNetData]);
            });
        }
        return nil;
    } else {
        NSData *data = [NSData dataWithContentsOfURL:videoURL];
        return [[NZAlamoSmartNetAgent shared] postFileData:url parameters:parameters.allKeys.count>0?parameters:nil data:data name:@"file" fileName:videoName mimeType:mimeType progress:nil success:^(NSURLSessionTask * task, id responseObject) {
            NSLog(@"Success: %@", responseObject);
            id parsedObject = [NZAlamoSmartResponseDeserializer deserializeDataByEnvelopClass:[NZNetData class] modelClass:nil dataClass:nil data:responseObject];
            if (block) {
                block(parsedObject);
            }
        } failure:^(NSURLSessionTask * task, NSError * error, id response) {
            NSLog(@"Error: %@", error);
            if (block) {
                block([NZNetData errorData:error]);
            }
        } timeout:@(nzUploadTime_out)];
    }
}

- (MoyaNetStub *)uploadFileWithURL:(NSString *)url
                  fileURL:(NSURL *)fileURL
               parameters:(NSDictionary *)parameters
                 callback:(NZNetWorkingBlock)block
{
    if (self.netStatus == AlamoSmartNetStatusNotReachable) {
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block([NZNetData badNetData]);
            });
        }
        return nil;
    } else {
        NSString *fileName = [fileURL lastPathComponent];
        NSString *mimeType = [self contentTypeForPathExtension:[fileURL pathExtension]];
        NSData *data = [NSData dataWithContentsOfURL:fileURL];
        if (!data) {
            if (block) {
                block([NZNetData badNetData]);
            }
            return nil;
        }
        return [[NZAlamoSmartNetAgent shared] postFileData:url parameters:parameters.allKeys.count>0?parameters:nil data:data name:@"file" fileName:fileName mimeType:mimeType progress:nil success:^(NSURLSessionTask * task, id responseObject) {
            NSLog(@"Success: %@", responseObject);
            id parsedObject = [NZAlamoSmartResponseDeserializer deserializeDataByEnvelopClass:[NZNetData class] modelClass:nil dataClass:nil data:responseObject];
            if (block) {
                block(parsedObject);
            }
        } failure:^(NSURLSessionTask * task, NSError * error, id response) {
            NSLog(@"Error: %@", error);
            if (block) {
                block([NZNetData errorData:error]);
            }
        } timeout:@(nzUploadTime_out)];

    }
}

#pragma mark - error handler
- (void)handlerErrorWithNetData:(NZNetData *)netData url:(NSString *)url parameters:(NSDictionary *)parameters method:(NSString *)method timeout:(CGFloat)interval callback:(NZNetWorkingBlock)callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *errorCode = [NSString stringWithFormat:@"%ld", netData.code];
        NZErrorHandleBlock block = [self.errorHandlerBlocks objectForKey:errorCode];
        BOOL shouldReRequest = NO;
        if (block) {
            shouldReRequest = block(netData);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (shouldReRequest)
            {
                if ([method isEqualToString:@"get"])
                {
                    [self get:url parameters:parameters timeout:interval callback:callback];
                }
                else if ([method isEqualToString:@"post"])
                {
                    [self post:url parameters:parameters timeout:interval callback:callback];
                }
                else if ([method isEqualToString:@"put"])
                {
                    [self put:url parameters:parameters timeout:interval callback:callback];
                }
                else if ([method isEqualToString:@"delete"])
                {
                    [self delete:url parameters:parameters timeout:interval callback:callback];
                }
            }
            else
            {
                if (callback) {
                    callback(netData);
                }
            }
        });
        
    });
}

- (NSString *)contentTypeForPathExtension:(NSString *)extension {
#ifdef __UTTYPE__
    NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
    NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
    if (!contentType) {
        return @"application/octet-stream";
    } else {
        return contentType;
    }
#else
#pragma unused (extension)
    return @"application/octet-stream";
#endif
}

@end
