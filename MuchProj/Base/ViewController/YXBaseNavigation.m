//
//  YXBaseNavigation.m
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#import "YXBaseNavigation.h"

@interface YXBaseNavigation ()

@end

@implementation YXBaseNavigation

#pragma mark - 支持的屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return [self.topViewController supportedInterfaceOrientations];
}

#pragma mark - 初始化
- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

#pragma mark - 加载视图
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 解决iOS14以上系统TabBar显示异常的问题
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    
    if (viewControllers.count == 1) {
        [self popToRootViewControllerAnimated:animated];
        return;
    }
    
    for (NSInteger i = 0; i < viewControllers.count; ++i) {
        UIViewController *vc = viewControllers[i];
        if (i == 1) {
            vc.hidesBottomBarWhenPushed = YES;
        }
        else {
            vc.hidesBottomBarWhenPushed = NO;
        }
    }
    
    [super setViewControllers:viewControllers animated:animated];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count == 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
