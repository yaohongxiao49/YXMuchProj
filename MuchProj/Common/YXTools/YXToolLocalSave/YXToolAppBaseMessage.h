//
//  YXToolAppBaseMessage.h
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/10.
//  Copyright © 2020 August. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXToolLocalSaveBySqlite.h"

/** 应用使用状态 */
typedef NS_ENUM(NSInteger, YXToolAppBaseType) {
    /** 通常情况 */
    YXToolAppBaseTypeNormal = 0,
    /** 首次启动 */
    YXToolAppBaseTypeFirstUse,
    /** 升级后首次启动 */
    YXToolAppBaseTypeUpgrade,
};

NS_ASSUME_NONNULL_BEGIN

@interface YXToolAppBaseMessage : NSObject

/** 0，普通情况；1，初次启用；2，系统更新(该值不做保存，每次启动临时使用) */
@property (nonatomic, assign) YXToolAppBaseType appState;
/** 版本号（用以区分是否发生更新） */
@property (nonatomic, copy) NSString *version;
/** 登录名 */
@property (nonatomic, copy) NSString *username;
/** 登录密码 */
@property (nonatomic, copy) NSString *password;
/** YES:记住登录信息 */
@property (nonatomic, assign) BOOL rememberLogin;
/** 首次启动是否未进入首页 */
@property (nonatomic, assign) BOOL boolNotInHomeFirstUse;

+ (id)instanceManager;
+ (void)synchronize;
/** 注册App应用使用状态 */
+ (void)registerUserDefaults;

@end

NS_ASSUME_NONNULL_END
