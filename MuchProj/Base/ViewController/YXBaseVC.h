//
//  YXBaseVC.h
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#import <UIKit/UIKit.h>
#import "YXBaseNavigationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXBaseVC : UIViewController

/** 导航栏 */
@property (nonatomic, strong) YXBaseNavigationView *navView;

/** 把指定的VC设置到最前并返回 */
- (YXBaseVC *)bringVCToFront:(NSString *)vcName animated:(BOOL)animated;

/** 移除指定的VC并返回最前的VC */
- (YXBaseVC *)removeVCByVCNameArr:(NSArray *)vcNameArr animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
