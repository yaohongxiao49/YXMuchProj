//
//  UIView+YXCategory.h
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/9.
//  Copyright © 2020 August. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, YXFilterActionType) {
    /** 替换字符串为空 */
    YXFilterKeyWordsType = 0x001,
    /** 限制Emoji表情 */
    YXFilterEmojiType = 0x010,
    /** 限制字数 */
    YXFilterLimitType = 0x100,
    /** 显示字数及Emoji表情 */
    YXFilterLimitEmojiType = 0x003,
    /** 不做控制 */
    YXFilterNoneType = 0x000
};

@interface UIView (YXCategory)

/** 视图x坐标 */
@property (nonatomic, assign) CGFloat x;
/** 视图y坐标 */
@property (nonatomic, assign) CGFloat y;
/** 视图宽 */
@property (nonatomic, assign) CGFloat width;
/** 视图高 */
@property (nonatomic, assign) CGFloat height;

/** 视图最右侧坐标 */
@property (nonatomic, assign) CGFloat right;
/** 视图最底部坐标 */
@property (nonatomic, assign) CGFloat bottom;

/** 视图中心x坐标 */
@property (nonatomic, assign) CGFloat centerX;
/** 视图中心y坐标 */
@property (nonatomic, assign) CGFloat centerY;

/** 视图坐标 */
@property (nonatomic, assign) CGPoint origin;
/** 视图大小 */
@property (nonatomic, assign) CGSize size;

#pragma mark - 输入框限制
/** 需要替换的文字数组 */
@property (nonatomic, strong) NSArray *filterKeyWordsArray;
/** 限制字符串总数 */
@property (nonatomic, assign) int limitInputWords;
/** 限制类型 */
@property (nonatomic, assign) int filterActionType;

/** 获取当前视图所在的视图控制器 */
- (UIViewController *)viewController;

/**
 * 添加点击手势
 * @param block 点击回调
 */
- (void)yxTapUpWithBlock:(void(^)(UIView *view))block;

/**
 * 指定圆角
 * @param view 视图
 * @param corners 圆角方位
 * @param cornerRadii 圆角程度
 */
+ (void)yxSpecifiedCornerFilletByView:(UIView *)view
                              corners:(UIRectCorner)corners
                          cornerRadii:(CGSize)cornerRadii;

/**
 * 指定圆角带边框
 * @param view 视图
 * @param corners 圆角方位
 * @param cornerRadii 圆角程度
 * @param lineWidth 边框宽度
 * @param lineColor 边框色值
 */
+ (void)getSpecifiedFilletWithBorder:(UIView *)view
                             corners:(UIRectCorner)corners
                         cornerRadii:(CGSize)cornerRadii
                           lineWidth:(CGFloat)lineWidth
                           lineColor:(UIColor *)lineColor;

@end

NS_ASSUME_NONNULL_END
