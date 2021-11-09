//
//  AppDelegate.m
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#import "AppDelegate.h"
#import "YXTabBarVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //防止UITableView跳动
    if (@available(iOS 11.0, *)) {
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    
    //UINavigationBar按钮颜色
    [UINavigationBar appearance].tintColor = kYXThemeColor;
    //UINavigationBar标题
    [UINavigationBar appearance].titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kYXThemeColor, NSForegroundColorAttributeName, kYXFontBold(18), NSFontAttributeName, nil];

    //输入框光标颜色
    [[UITextField appearance] setTintColor:kYXThemeColor];
    [[UITextView appearance] setTintColor:kYXThemeColor];

    //设置键盘管理
    [self setKeyboardManager];
    
    //窗口视图
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[YXTabBarVC alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

#pragma mark - 设置键盘管理
- (void)setKeyboardManager {
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //设置管理键盘打开
    manager.enable = YES;
    //点击关闭键盘
    manager.shouldResignOnTouchOutside = YES;
    //工具栏显示占位字符
    manager.shouldShowToolbarPlaceholder = YES;
    //显示键盘工具栏
    manager.enableAutoToolbar = YES;
    //键盘工具栏按钮颜色
    manager.toolbarTintColor = kYXThemeColor;
}

@end
