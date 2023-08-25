//
//  NZNetworkingConfiguration.h
//  nfzm
//
//  Created by anthony zhu on 2021/12/23.
//
#import <Foundation/Foundation.h>

@interface NZNetworkingConfiguration:NSObject

+ (instancetype)sharedInstance;

#pragma mark - 设置头部信息
/**
 *  设置头信息
 *
 *  @param value 值
 *  @param key   键
 */
- (void)setHeader:(NSString *)value forKey:(NSString *)key;

/**
 *  移除头健值信息
 *
 *  @param key   键
 */
- (void)removeHeaderForKey:(NSString *)key;

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
 *  设置userId
 *
 *  @param userId  用户id
 */
- (void)setUserId:(NSString *)userId;

/**
 *  设置userAgent
 *
 *  @param userAgent  用户agent
 */
- (void)setUserAgent:(NSString *)userAgent;

/**
 *  设置平台
 *
 *  @param platform  平台
 */
- (void)setPlatform:(NSString *)platform;

@end
