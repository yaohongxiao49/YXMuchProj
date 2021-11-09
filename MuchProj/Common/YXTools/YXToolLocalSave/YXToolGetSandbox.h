//
//  YXToolGetSandbox.h
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/10.
//  Copyright © 2020 August. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXToolGetSandbox : NSObject

+ (NSString *)yxHomePath;

+ (NSString *)yxAppPath;

/** 您应该将所有的应用程序数据文件写入到这个目录下。这个目录用于存储用户数据或其它应该定期备份的信息。 */
+ (NSString *)yxDocPath;

/** 目录包含应用程序的偏好设置文件。您不应该直接创建偏好设置文件，而是应该使用NSUserDefaults类来取得和设置应用程序的偏好。 */
+ (NSString *)yxLibPrefPath;

/** 目录用于存放应用程序专用的支持文件，保存应用程序再次启动过程中需要的信息。 */
+ (NSString *)yxLibCachePath;

/** 这个目录用于存放临时文件，保存应用程序再次启动过程中不需要的信息。 */
+ (NSString *)yxTmpPath;

/** 创建目录 */
+ (BOOL)yxHasLive:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
