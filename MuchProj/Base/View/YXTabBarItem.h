//
//  YXTabBarItem.h
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#import <UIKit/UIKit.h>
#import "YXTabBarItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXTabBarItem : UIView

/** 按钮 */
@property (nonatomic, strong) UIButton *btn;
/** icon图片 */
@property (nonatomic, strong) UIImageView *iconImgV;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLab;

/** 项目数据 */
@property (nonatomic, strong) YXTabBarItemModel *itemModel;
/** 项目状态 */
@property (nonatomic, assign) YXTabBarItemModelState itemState;
/** 项目位置 */
@property (nonatomic, assign) NSInteger itemIndex;
/** 点击项目的回调 */
@property (nonatomic, copy) void (^clickItemBlock) (NSInteger itemIndex);

@end

NS_ASSUME_NONNULL_END
