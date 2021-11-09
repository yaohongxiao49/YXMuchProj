//
//  YXProgressSlider.h
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXProgressSlider : UIView

/** 滑动手势 */
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGesture;

/** 滑块底视图 */
@property (nonatomic, strong) UIView *sliderBaseView;
/** 滑块视图 */
@property (nonatomic, strong) UIImageView *sliderView;
/** 最小值视图 */
@property (nonatomic, strong) UIView *minimumView;
/** 最大值视图 */
@property (nonatomic, strong) UIView *maximumView;

/** 滑块颜色，默认白色 */
@property (nonatomic, strong) UIColor *sliderColor;
/** 最小值颜色，默认白色 */
@property (nonatomic, strong) UIColor *minimumColor;
/** 最大值颜色，默认白色半透明 */
@property (nonatomic, strong) UIColor *maximumColor;

/** 是否隐藏滑块，默认NO */
@property (nonatomic, assign) BOOL isHiddenSlider;
/** 是否隐藏进度条圆角，默认NO */
@property (nonatomic, assign) BOOL isHiddenCorner;

/** 当前的值，默认0 */
@property (nonatomic, assign) CGFloat value;
/** 最小值，默认0 */
@property (nonatomic, assign) CGFloat minimumValue;
/** 最大值，默认1 */
@property (nonatomic, assign) CGFloat maximumValue;

/** 滑块触摸区域大小，默认30 */
@property (nonatomic, assign) CGFloat sliderTouchSize;
/** 滑块大小，默认10 */
@property (nonatomic, assign) CGFloat sliderSize;
/** 进度条高度，默认2 */
@property (nonatomic, assign) CGFloat progressHeight;

/** 按住滑块的回调 */
@property (nonatomic, copy) void (^touchBeganBlock) (void);
/** 放开滑块的回调 */
@property (nonatomic, copy) void (^touchEndedBlock) (void);
/** 滑动滑块的回调 */
@property (nonatomic, copy) void (^valueChangedBlock) (CGFloat value);

/** 设置进度条的值，是否需要动画 */
- (void)setProgressValue:(CGFloat)value animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
