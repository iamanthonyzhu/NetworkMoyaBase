//
//  NZNetworkingConfiguration.m
//  nfzm
//
//  Created by anthony zhu on 2021/12/23.
//

#import <Foundation/Foundation.h>
#import "NZNetworkingConfiguration.h"
#import "NZNetworkingMacros.h"

static NSString *const kContentType = @"Content-Type";
static NSString *const kAccept = @"Accept";
static NSString *const kTokenKey = @"PET-SESSION-TOKEN";
static NSString *const kSignKey = @"X-XCLOUD-SIGN";
static NSString *const kUserId = @"User-Id";
static NSString *const kUserAgent = @"User-Agent";
static NSString *const kPlatform = @"platform";


@interface NZNetworkingConfiguration()

@end

@implementation NZNetworkingConfiguration

+ (instancetype)sharedInstance
{
    static NZNetworkingConfiguration *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NZNetworkingConfiguration alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [NZAlamoSmartNetAgent setHeaderWithValue:@"application/json" key:kAccept];
}

#pragma mark - getter setter
- (void)setHeader:(NSString *)value forKey:(NSString *)key
{
    [NZAlamoSmartNetAgent setHeaderWithValue:value key:key];
}

- (void)removeHeaderForKey:(NSString *)key
{
    [NZAlamoSmartNetAgent removeHeaderWithKey:key];
}

- (void)setSign:(NSString *)sign
{
    [NZAlamoSmartNetAgent setSignWithSign:sign];
}

- (void)setSessionToken:(NSString *)sessionToken
{
    [NZAlamoSmartNetAgent setSessionTokenWithToken:sessionToken];
}


- (void)setUserId:(NSString *)userId {
    [NZAlamoSmartNetAgent setUserIdWithUserId:userId];
}

- (void)setUserAgent:(NSString *)userAgent {
    [NZAlamoSmartNetAgent setUserAgentWithAgent:userAgent];
}

- (void)setPlatform:(NSString *)platform {
    [NZAlamoSmartNetAgent setPlatformWithPlatform:platform];
}

@end


