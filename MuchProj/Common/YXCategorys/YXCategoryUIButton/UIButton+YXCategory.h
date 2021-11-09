//
//  UIButton+YXCategory.h
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/9.
//  Copyright © 2020 August. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 按钮文字、图片显示类型枚举 */
typedef NS_ENUM(NSUInteger, YXBtnEdgeInsetsStyle) {
    /** img在上，lab在下 */
    YXBtnEdgeInsetsStyleTop,
    /** img在左，lab在右 */
    YXBtnEdgeInsetsStyleLeft,
    /** img在下，lab在上 */
    YXBtnEdgeInsetsStyleBottom,
    /** img在右，lab在左 */
    YXBtnEdgeInsetsStyleRight,
};

typedef void(^YXBtnTapActionBlock)(UIButton *button, BOOL boolSelected);
typedef void(^YXStartWithTimeIsEndBlock)(id);

@interface UIButton (YXCategory)

@property (nonatomic, copy) YXBtnTapActionBlock yxBtnTapActionBlock;

/** 防止按钮重复点击 */
@property (nonatomic, assign) NSTimeInterval repeatClickEventInterval;
/** 重复点击的间隔 */
@property (nonatomic, assign) NSTimeInterval acceptEventTime;

/**
 * 通过block对button的点击事件封装
 * @param frame frame
 * @param title 标题
 * @param bgImgName 背景图片
 * @param action 点击事件回调block
 * @return button
 */
+ (UIButton *)yxCreateBtnByFrame:(CGRect)frame
                           title:(NSString *__nullable)title
                    nomalImgName:(NSString *__nullable)nomalImgName
                 selectedImgName:(NSString *__nullable)selectedImgName
              highlightedImgName:(NSString *__nullable)highlightedImgName
                       bgImgName:(NSString *__nullable)bgImgName
                          action:(YXBtnTapActionBlock)action;

/**
 * 创建按钮包含普通及选中状态
 * @param frame 尺寸
 * @param norTitle 普通标题
 * @param norTitleColor 普通标题颜色
 * @param norTitleFont 普通标题字号
 * @param norImgName 普通图片
 * @param norBgColor 普通背景色
 * @param selTitle 选中标题
 * @param selTitleColor 选中标题色
 * @param selTitleFont 选中标题字号
 * @param selImgName 选中图片
 * @param selBgColor 选中背景色
 * @param bgImgName 背景图片
 * @param bgCorner 圆角
 * @param boolSel 是否选中
 * @param action 点击事件回调
 */
+ (UIButton *)yxCreateSelectedBtnByFrame:(CGRect)frame
                                norTitle:(NSString *__nullable)norTitle
                           norTitleColor:(UIColor *__nullable)norTitleColor
                            norTitleFont:(UIFont *__nullable)norTitleFont
                              norImgName:(NSString *__nullable)norImgName
                              norBgColor:(UIColor *__nullable)norBgColor
                                selTitle:(NSString *__nullable)selTitle
                           selTitleColor:(UIColor *__nullable)selTitleColor
                            selTitleFont:(UIFont *__nullable)selTitleFont
                              selImgName:(NSString *__nullable)selImgName
                              selBgColor:(UIColor *__nullable)selBgColor
                               bgImgName:(NSString *__nullable)bgImgName
                                bgCorner:(NSString *__nullable)bgCorner
                                 boolSel:(BOOL)boolSel
                                  action:(YXBtnTapActionBlock)action;

/**
* 修改按钮包含普通及选中状态
* @param norTitle 普通标题
* @param norTitleColor 普通标题颜色
* @param norTitleFont 普通标题字号
* @param norImgName 普通图片
* @param norBgColor 普通背景色
* @param selTitle 选中标题
* @param selTitleColor 选中标题色
* @param selTitleFont 选中标题字号
* @param selImgName 选中图片
* @param selBgColor 选中背景色
* @param bgImgName 背景图片
* @param bgCorner 圆角
* @param boolSel 是否选中
* @param action 点击事件回调
*/
- (UIButton *)yxChangeSelectedBtnByTitle:(NSString *__nullable)norTitle
                           norTitleColor:(UIColor *__nullable)norTitleColor
                            norTitleFont:(UIFont *__nullable)norTitleFont
                              norImgName:(NSString *__nullable)norImgName
                              norBgColor:(UIColor *__nullable)norBgColor
                                selTitle:(NSString *__nullable)selTitle
                           selTitleColor:(UIColor *__nullable)selTitleColor
                            selTitleFont:(UIFont *__nullable)selTitleFont
                              selImgName:(NSString *__nullable)selImgName
                              selBgColor:(UIColor *__nullable)selBgColor
                               bgImgName:(NSString *__nullable)bgImgName
                                bgCorner:(NSString *__nullable)bgCorner
                                 boolSel:(BOOL)boolSel
                                  action:(YXBtnTapActionBlock)action;

@property (nonatomic, copy) NSString *norTitle; //普通标题
@property (nonatomic, strong) UIColor *norTitleColor; //普通标题颜色
@property (nonatomic, strong) UIFont *norTitleFont; //普通标题字号
@property (nonatomic, copy) NSString *norImgName; //普通图片
@property (nonatomic, strong) UIColor *norBgColor; //普通背景颜色
@property (nonatomic, copy) NSString *selTitle; //选中标题
@property (nonatomic, strong) UIColor *selTitleColor; //选中标题颜色
@property (nonatomic, strong) UIFont *selTitleFont; //选中标题字号
@property (nonatomic, copy) NSString *selImgName; //选中图片
@property (nonatomic, strong) UIColor *selBgColor; //选中背景颜色
@property (nonatomic, assign) BOOL boolSel; //是否选中

/**
 * 设置button的titleLab和ImgView的布局样式，及间距
 * @param style titleLab和ImgView的布局样式
 * @param imgTitleSpace titleLabel和ImgView的间距
 */
- (void)yxLayoutBtnWithEdgeInsetsStyle:(YXBtnEdgeInsetsStyle)style
                         imgTitleSpace:(CGFloat)imgTitleSpace;

/**
 * 倒计时按钮
 * @param timeAmount 倒计时总时间
 * @param title 还没倒计时的title
 * @param beforeSubTitle 时间之前的描述
 * @param subTitle 倒计时中的子名字，如时、分
 * @param mColor 还没倒计时的颜色
 * @param color 倒计时中的颜色
 * @param isCerificationCode 是否为验证码
 */
- (void)yxBtnCountdownByTimeAmount:(NSInteger)timeAmount
                             title:(NSString *)title
                    beforeSubTitle:(NSString *)beforeSubTitle
                    countDownTitle:(NSString *)subTitle
                         mainColor:(UIColor *)mColor
                        countColor:(UIColor *)color
                isCerificationCode:(BOOL)isCerificationCode
           startWithTimeIsEndBlock:(YXStartWithTimeIsEndBlock)startWithTimeIsEndBlock;

@end

NS_ASSUME_NONNULL_END
