//
//  YXTabBarVC.h
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#import <UIKit/UIKit.h>
#import "YXTabBarView.h"
#import "YXBaseNavigation.h"

#import "YXBlindBoxHomeVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXTabBarVC : UITabBarController

@property (nonatomic, strong) YXBlindBoxHomeVC *homeVC;

/** 自定义标签栏 */
@property (nonatomic, strong) YXTabBarView *customTabBar;

#pragma mark - 选中指定控制器
/** 开个盲盒 */
- (void)selectedBlindBoxHomeVC;

/** 获取当前显示的导航控制器 */
- (YXBaseNavigation *)getCurrentDisplayNaVC;

/** 获取当前显示的控制器 */
- (YXBaseVC *)getCurrentDisplayVC;

@end

NS_ASSUME_NONNULL_END
