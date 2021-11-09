//
//  UIColor+YXCategory.h
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (YXCategory)

/**
 * 二进制色值
 * @param hexString 二进制（如#000000）
 */
+ (UIColor *)yxColorByHexString:(NSString *)hexString;

/**
 * 二进制色值
 * @param hexString 二进制（如#000000）
 * @param alpha 透明度
 */
+ (UIColor *)yxColorByHexString:(NSString *)hexString
                          alpha:(CGFloat)alpha;

/**
 * 视图渐变色
 * @param view 基础视图
 * @param colorArr 色值数组
 * @param startPoint 开始点
 * @param endPoint 结束点
 * @param locations 设置颜色变化点（分割点），取值范围 0.0 ~ 1.0。默认@[@0, @1]
 */
+ (CAGradientLayer *)yxDrawGradient:(UIView *)view
                           colorArr:(NSArray *)colorArr
                         startPoint:(CGPoint)startPoint
                           endPoint:(CGPoint)endPoint
                          locations:(NSArray *)locations;

/**
 * 文字渐变色（基于视图的，如label）
 * @param view 渐变色的显示视图
 * @param bgView 显示视图的父视图
 * @param colorArr 渐变色数组
 * @param startPoint 开始点
 * @param endPoint 结束点
 */
+ (void)yxTextGradientByView:(UIView *)view
                      bgView:(UIView *)bgView
                    colorArr:(NSArray *)colorArr
                  startPoint:(CGPoint)startPoint
                    endPoint:(CGPoint)endPoint;

/**
 * 文字渐变色（基于控件的，如button）
 * @param control 渐变色的显示视图
 * @param bgView 显示视图的父视图
 * @param colorArr 渐变色数组
 * @param startPoint 开始点
 * @param endPoint 结束点
 */
+ (void)yxTextGradientByControl:(UIControl *)control
                         bgView:(UIView *)bgView
                       colorArr:(NSArray *)colorArr
                     startPoint:(CGPoint)startPoint
                       endPoint:(CGPoint)endPoint;

/**
 * 视图阴影
 * @param view 阴影显示视图
 * @param shadowColor 阴影颜色
 * @param shadowOffset 阴影偏移量
 * @param shadowOpacity 阴影透明度
 * @param shadowRadius 阴影半径
 * @param cornerRadius 阴影圆角
 */
+ (void)yxDrawShadowColorByView:(UIView *)view
                    shadowColor:(UIColor *)shadowColor
                   shadowOffset:(CGSize)shadowOffset
                  shadowOpacity:(CGFloat)shadowOpacity
                   shadowRadius:(CGFloat)shadowRadius
                   cornerRadius:(CGFloat)cornerRadius;

/**
 * 文字阴影
 * @param lab 阴影显示视图
 * @param shadowColor 阴影颜色
 * @param shadowOffset 阴影偏移量
 * @param shadowBlurRadius 阴影半径
 */
+ (void)yxDrawTextShadowByLab:(UILabel *)lab
                  shadowColor:(UIColor *)shadowColor
                 shadowOffset:(CGSize)shadowOffset
             shadowBlurRadius:(CGFloat)shadowBlurRadius;

@end

NS_ASSUME_NONNULL_END
