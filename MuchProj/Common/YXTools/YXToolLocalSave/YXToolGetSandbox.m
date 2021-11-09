//
//  YXToolGetSandbox.m
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/10.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXToolGetSandbox.h"

#define kYXToolSqliteFileDefaultHandle [NSFileManager defaultManager]

@implementation YXToolGetSandbox

+ (NSString *)yxHomePath {
    
    return NSHomeDirectory();
}

+ (NSString *)yxAppPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    
    return [paths firstObject];
}

#pragma mark - 您应该将所有的应用程序数据文件写入到这个目录下。这个目录用于存储用户数据或其它应该定期备份的信息。
+ (NSString *)yxDocPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [paths firstObject];
}

#pragma mark - 目录包含应用程序的偏好设置文件。您不应该直接创建偏好设置文件，而是应该使用NSUserDefaults类来取得和设置应用程序的偏好。
+ (NSString *)yxLibPrefPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    
    return [[paths firstObject] stringByAppendingFormat:@"/Preference"];
}

#pragma mark - 目录用于存放应用程序专用的支持文件，保存应用程序再次启动过程中需要的信息。
+ (NSString *)yxLibCachePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    
    return [[paths firstObject] stringByAppendingFormat:@"/Caches"];
}

#pragma mark - 这个目录用于存放临时文件，保存应用程序再次启动过程中不需要的信息。
+ (NSString *)yxTmpPath {
    
    return [[self yxHomePath] stringByAppendingFormat:@"/tmp"];
}

#pragma mark - 创建目录
+ (BOOL)yxHasLive:(NSString *)path {
    
    if (![kYXToolSqliteFileDefaultHandle fileExistsAtPath:path]) {
        return [kYXToolSqliteFileDefaultHandle createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    return NO;
}

@end
