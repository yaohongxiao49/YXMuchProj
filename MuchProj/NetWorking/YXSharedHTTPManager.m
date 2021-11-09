//
//  YXSharedHTTPManager.m
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#import "YXSharedHTTPManager.h"

@implementation YXSharedHTTPManager

+ (AFHTTPSessionManager *)shareManager {
    
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [AFHTTPSessionManager manager];
        //设置请求超时时间
        manager.requestSerializer.timeoutInterval = 10.0;
        //缓存策略
        manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        //数据格式
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/ javascript", @"text/html", @"text/plain", @"*/*", nil];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //安全相关
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.securityPolicy.validatesDomainName = NO;
        manager.securityPolicy.allowInvalidCertificates = YES;
    });
    
    return manager;
}

@end
