//
//  YXTabBarView.h
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#import <UIKit/UIKit.h>
#import "YXTabBarItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXTabBarView : UIView

/** 选中的控制器 */
@property (nonatomic, assign) NSInteger selectedIndex;
/** 点击项目的回调 */
@property (nonatomic, copy) void (^clickItemBlock) (NSInteger itemIndex);

/** 自定义标签栏 */
+ (YXTabBarView *)customTabBarWithTabBarVC:(UITabBarController *)tabBarVC;

@end

NS_ASSUME_NONNULL_END
