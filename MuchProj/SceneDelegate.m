//
//  SceneDelegate.m
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#import "SceneDelegate.h"
#import "YXTabBarVC.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    //防止UITableView跳动
    if (@available(iOS 11.0, *)) {
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    
    //UINavigationBar按钮颜色
    [UINavigationBar appearance].tintColor = kYXThemeColor;
    //UINavigationBar标题
    [UINavigationBar appearance].titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:18], NSFontAttributeName, nil];

    //输入框光标颜色
    [[UITextField appearance] setTintColor:kYXThemeColor];
    [[UITextView appearance] setTintColor:kYXThemeColor];

    //设置键盘管理
    [self setKeyboardManager];
    
    //窗口视图
    if (@available(iOS 13.0, *)) {
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    }
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[YXTabBarVC alloc] init];
    [self.window makeKeyAndVisible];
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
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
