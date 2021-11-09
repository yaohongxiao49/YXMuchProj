//
//  YXTabBarVC.m
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#import "YXTabBarVC.h"

@interface YXTabBarVC ()

@property (nonatomic, strong) YXBaseNavigation *homeNaVC;

@end

@implementation YXTabBarVC

#pragma mark - 支持的屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    YXBaseNavigation *currentNaVC = [self getCurrentDisplayNaVC];
    return [currentNaVC supportedInterfaceOrientations];
}

#pragma mark - 初始化
- (instancetype)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - 加载视图
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addViewControllers];
}

#pragma mark - 添加控制器
- (void)addViewControllers {
    
    //首页
    _homeVC = [[YXBlindBoxHomeVC alloc] init];
    _homeNaVC = [[YXBaseNavigation alloc] initWithRootViewController:_homeVC];
    
    //设置标签栏
    self.viewControllers = @[_homeNaVC];
    self.customTabBar = [YXTabBarView customTabBarWithTabBarVC:self];
}

#pragma mark - 选中指定控制器
- (void)selectedBlindBoxHomeVC {
    
    self.customTabBar.selectedIndex = 0;
}

#pragma mark - 获取当前显示的导航控制器
- (YXBaseNavigation *)getCurrentDisplayNaVC {
    
    YXBaseNavigation *currentNaVC = (YXBaseNavigation *)self.viewControllers[self.selectedIndex];
    return currentNaVC;
}

#pragma mark - 获取当前显示的控制器
- (YXBaseVC *)getCurrentDisplayVC {
    
    YXBaseNavigation *currentNaVC = [self getCurrentDisplayNaVC];
    YXBaseVC *currentVC = (YXBaseVC *)[currentNaVC.viewControllers lastObject];
    return currentVC;
}


@end
