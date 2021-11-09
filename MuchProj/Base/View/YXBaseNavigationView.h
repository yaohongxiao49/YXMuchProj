//
//  YXBaseNavigationView.h
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXBaseNavigationView : UIView

/** 背景视图 */
@property (nonatomic, strong) UIView *bgView;
/** 按钮 */
@property (nonatomic, strong) UIButton *backBtn;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLab;
/** 分割线图片 */
@property (nonatomic, strong) UIImageView *lineImgV;

/** 点击返回的回调 */
@property (nonatomic, copy) void (^clickBackBlock) (void);

@end

NS_ASSUME_NONNULL_END
