//
//  UIColor+YXCategory.m
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import "UIColor+YXCategory.h"

@implementation UIColor (YXCategory)

#pragma mark - 二进制色值
+ (UIColor *)yxColorByHexString:(NSString *)hexString {
    
    return [self yxColorByHexString:hexString alpha:1.f];
}

#pragma mark - 二进制色值
+ (UIColor *)yxColorByHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    
    //删除字符串中的空格
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    //String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    //strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        return [UIColor clearColor];
    }

    //Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];

    //Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float)r /255.0f) green:((float)g /255.0f) blue:((float)b /255.0f) alpha:alpha];
}

#pragma mark - 视图渐变色
+ (CAGradientLayer *)yxDrawGradient:(UIView *)view colorArr:(NSArray *)colorArr startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint locations:(NSArray *)locations {
    
    //CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    
    gradientLayer.colors = colorArr;
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.locations = locations;
    
    return gradientLayer;
}

#pragma mark - 文字渐变色（基于视图的，如label）
+ (void)yxTextGradientByView:(UIView *)view bgView:(UIView *)bgView colorArr:(NSArray *)colorArr startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.frame;
    gradientLayer.colors = colorArr;
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    [bgView.layer addSublayer:gradientLayer];
    gradientLayer.mask = view.layer;
    view.frame = gradientLayer.bounds;
}

#pragma mark - 文字渐变色（基于控件的，如button）
+ (void)yxTextGradientByControl:(UIControl *)control bgView:(UIView *)bgView colorArr:(NSArray *)colorArr startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = control.frame;
    gradientLayer.colors = colorArr;
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    [bgView.layer addSublayer:gradientLayer];
    gradientLayer.mask = control.layer;
    control.frame = gradientLayer.bounds;
}

#pragma mark - 视图阴影
+ (void)yxDrawShadowColorByView:(UIView *)view shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius cornerRadius:(CGFloat)cornerRadius {
    
    view.layer.shadowColor = shadowColor.CGColor;
    view.layer.shadowOffset = shadowOffset;
    view.layer.shadowRadius = shadowRadius;
    view.layer.shadowOpacity = shadowOpacity;
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = NO; //必须为NO
}

#pragma mark - 文字阴影
+ (void)yxDrawTextShadowByLab:(UILabel *)lab shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowBlurRadius:(CGFloat)shadowBlurRadius {
    
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = shadowColor;
    shadow.shadowOffset = shadowOffset;
    shadow.shadowBlurRadius = shadowBlurRadius;
    
    NSAttributedString *butedStrin = [[NSAttributedString alloc] initWithString:lab.text attributes:@{NSShadowAttributeName:shadow}];
    
    lab.attributedText = butedStrin;
}

@end
