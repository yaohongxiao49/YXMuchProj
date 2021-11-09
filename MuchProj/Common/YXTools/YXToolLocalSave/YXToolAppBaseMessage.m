//
//  YXToolAppBaseMessage.m
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/10.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXToolAppBaseMessage.h"
#import "YXToolLocalSaveBySqlite.h"

#define kYXToolSqliteUserDefaultHandle [NSUserDefaults standardUserDefaults]

#define kYXToolAppBaseMsgUserInfos @"YXToolAppBaseMsgUserInfos"
#define kYXToolAppBaseMsgUserNames @"YXToolAppBaseMsgVersionUserNames"
#define kYXToolAppBaseMsgUserPassWords @"YXToolAppBaseMsgVersionUserPassWords"

@implementation YXToolAppBaseMessage

+ (id)instanceManager {
    
    static YXToolAppBaseMessage *yxToolAppBaseMessage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        yxToolAppBaseMessage = [YXToolAppBaseMessage new];
    });
    
    return yxToolAppBaseMessage;
}

+ (void)synchronize {
    
    [kYXToolSqliteUserDefaultHandle synchronize];
}

+ (void)registerUserDefaults {
    
    YXToolAppBaseMessage *defaults = [YXToolAppBaseMessage instanceManager];
    NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *settingVersion = [defaults version];
    if (settingVersion == nil) { //初次使用应用
        [defaults setVersion:bundleVersion];
        defaults.appState = YXToolAppBaseTypeFirstUse;
    }
    else if (![bundleVersion isEqualToString:settingVersion]) { //通过版本和bundleVersion进行匹配来判断是否进行了更新
        [defaults setVersion:bundleVersion];
        defaults.appState = YXToolAppBaseTypeUpgrade;
    }
    else { //正常情况
        defaults.appState = YXToolAppBaseTypeNormal;
    }
    [YXToolAppBaseMessage synchronize];
}

#pragma mark - saved key&value
#pragma mark - version
- (NSString *)version {
    
    return [YXToolLocalSaveBySqlite yxReadUserDefaultsByKey:@"YXToolAppBaseMsgVersion"];
}
- (void)setVersion:(NSString *)version {
    
    return [YXToolLocalSaveBySqlite yxSaveUserDefaultsByValue:version Key:@"YXToolAppBaseMsgVersion"];
}

#pragma mark - userName
- (NSString *)username {
    
    return [YXToolLocalSaveBySqlite yxReadKeychainsByKey:kYXToolAppBaseMsgUserNames keychainKey:kYXToolAppBaseMsgUserInfos];
}
- (void)setUsername:(NSString *)username {
    
    [YXToolLocalSaveBySqlite yxSaveKeychainsByValue:username dicKey:kYXToolAppBaseMsgUserNames keychainKey:kYXToolAppBaseMsgUserInfos];
}

#pragma mark - password
- (NSString *)password {
    
    return [YXToolLocalSaveBySqlite yxReadKeychainsByKey:kYXToolAppBaseMsgUserPassWords keychainKey:kYXToolAppBaseMsgUserInfos];
}
- (void)setPassword:(NSString *)password {
    
    [YXToolLocalSaveBySqlite yxSaveKeychainsByValue:password dicKey:kYXToolAppBaseMsgUserPassWords keychainKey:kYXToolAppBaseMsgUserInfos];
}

#pragma mark - rememberLogin
- (BOOL)rememberLogin {
    
    return [kYXToolSqliteUserDefaultHandle boolForKey:@"YXToolAppBaseMsgRemLogin"];
}
- (void)setRememberLogin:(BOOL)rememberLogin {
    
    [kYXToolSqliteUserDefaultHandle setBool:rememberLogin forKey:@"YXToolAppBaseMsgRemLogin"];
}

#pragma mark - boolNotInHomeFirstUse
- (BOOL)boolNotInHomeFirstUse {
    
    return [kYXToolSqliteUserDefaultHandle boolForKey:@"BoolNotInHomeFirstUse"];
}

- (void)setBoolNotInHomeFirstUse:(BOOL)boolNotInHomeFirstUse {
    
    [kYXToolSqliteUserDefaultHandle setBool:boolNotInHomeFirstUse forKey:@"BoolNotInHomeFirstUse"];
}

@end
