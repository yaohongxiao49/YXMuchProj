//
//  NSObject+YXCategory.m
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/9.
//  Copyright © 2020 August. All rights reserved.
//

#import "NSObject+YXCategory.h"

@implementation NSObject (YXCategory)

#pragma mark - 安全区域
- (UIEdgeInsets)yxSafeAreaInsets {
    
    if (@available(iOS 11.0, *)) {
        return [[UIApplication sharedApplication] windows].firstObject.safeAreaInsets;
    }
    
    return UIEdgeInsetsZero;
}

#pragma mark - 是否是竖屏
- (BOOL)yxBoolPortrait {
    
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) { //是竖屏
        return YES;
    }
    else if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) { //横屏
        return NO;
    }
    
    return YES;
}

#pragma mark - 是否是全面屏
- (BOOL)yxBoolFullScreen {
    
    if (self.yxSafeAreaInsets.bottom > 0.f) {
        return YES;
    }
    
    return NO;
}

#pragma mark - 状态栏高度
- (CGFloat)yxStatusBarHeight {
    
    if (self.yxBoolFullScreen) {
        return self.yxSafeAreaInsets.top;
    }
    
    return 20.f;
}

#pragma mark - 导航栏高度
- (CGFloat)yxNaviHeight {
    
    return 44.f + self.yxStatusBarHeight;
}

#pragma mark - 工具栏高度
- (CGFloat)yxToolHeight {
    
    return 49.f + self.yxBottomSafeHeight;
}

#pragma mark - 苹果底部安全区域高度（底部横条区域）
- (CGFloat)yxBottomSafeHeight {
    
    if (self.yxBoolFullScreen) {
        return self.yxSafeAreaInsets.bottom;
    }
    
    return 0.f;
}

#pragma mark - 屏幕宽
- (CGFloat)yxScreenWidth {
    
    return [UIScreen mainScreen].bounds.size.width;
}

#pragma mark - 屏幕高
- (CGFloat)yxScreenHeight {
    
    return [UIScreen mainScreen].bounds.size.height;
}

@end
