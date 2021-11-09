//
//  PublicEvaluationStarView.h
//  Yanwei
//
//  Created by Believer Just on 2017/12/11.
//  Copyright © 2017年 DCloud. All rights reserved.
//
/// 评价星级视图

#import <UIKit/UIKit.h>

@class YXEvaluationStarView;

typedef void(^finishBlock)(CGFloat currentScore);

/** 评价星级显示类型 */
typedef NS_ENUM(NSInteger, RateStyle) {
    /** 只能整星评论 */
    WholeStar = 0,
    /** 允许半星评论 */
    HalfStar = 1,
    /** 允许不完整星评论 */
    IncompleteStar = 2,
};

@protocol PublicEvaluationStarViewDelegate <NSObject>

- (void)starRateView:(YXEvaluationStarView *)starRateView currentScore:(CGFloat)currentScore;

@end

@interface YXEvaluationStarView : UIView

/** 是否动画显示，默认NO */
@property (nonatomic, assign) BOOL isAnimation;
/** 评分样式 默认是WholeStar */
@property (nonatomic, assign) RateStyle rateStyle;
@property (nonatomic, weak) id<PublicEvaluationStarViewDelegate>delegate;
/** 设置字体*/
@property (nonatomic, assign) UIFont *startfont;
/** 填充字 */
@property (nonatomic, copy) NSString *fullString;
/** 填充色*/
@property (nonatomic, strong) UIColor *fullColor;
/** 默认色*/
@property (nonatomic, strong) UIColor *emptyColor;
/** 默认字 */
@property (nonatomic, copy) NSString *emptyString;
/** 星数 */
@property (nonatomic, assign) NSInteger numberOfStars;
/** 当前评分：0-5 默认0 */
@property (nonatomic, assign) CGFloat currentScore;
/** 是否不能点击 默认能点击 */
@property (nonatomic, assign) BOOL canotClick;
/** 充满图片 */
@property (nonatomic, copy) NSString *fullImgName;
/** 空白图片 */
@property (nonatomic, copy) NSString *emptyImgName;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars currentScore:(CGFloat)currentScore startfont:(UIFont *)startfont fullString:(NSString *)fullString emptyString:(NSString *)emptyString fullColor:(UIColor *)fullColor emptyColor:(UIColor *)emptyColor rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation delegate:(id)delegate;


- (instancetype)initWithFrame:(CGRect)frame finish:(finishBlock)finish;
- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars currentScore:(CGFloat)currentScore startfont:(UIFont *)startfont fullString:(NSString *)fullString emptyString:(NSString *)emptyString fullColor:(UIColor *)fullColor emptyColor:(UIColor *)emptyColor rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation finish:(finishBlock)finish;

/**
 * 图片星
 * @param frame 尺寸
 * @param numberOfStars 有几颗星
 * @param rateStyle 选中类型
 * @param isAnimation 是否带动画
 * @param boolAutoImg 是否显示图片原大小
 * @param finish 选中结束
 * @param fullImg 充满图片
 * @param emptyImg 正常图片
 */
- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation boolAutoImg:(BOOL)boolAutoImg finish:(finishBlock)finish fullImg:(NSString *)fullImg emptyImg:(NSString *)emptyImg;

@end
