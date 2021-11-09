//
//  YXSharedHTTPManager.h
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXSharedHTTPManager : AFHTTPSessionManager

+ (AFHTTPSessionManager *)shareManager;

@end

NS_ASSUME_NONNULL_END
