//
//  NSObject+YXCategory.h
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/9.
//  Copyright © 2020 August. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (YXCategory)

/** 获取安全区域 */
- (UIEdgeInsets)yxSafeAreaInsets;

/** 是否是竖屏 */
- (BOOL)yxBoolPortrait;

/** 是否是全面屏 */
- (BOOL)yxBoolFullScreen;

/** 状态栏高度 */
- (CGFloat)yxStatusBarHeight;

/** 导航栏高度 */
- (CGFloat)yxNaviHeight;

/** 工具栏高度 */
- (CGFloat)yxToolHeight;

/** 苹果底部安全区域高度（底部横条区域）*/
- (CGFloat)yxBottomSafeHeight;

/** 屏幕宽 */
- (CGFloat)yxScreenWidth;

/** 屏幕高 */
- (CGFloat)yxScreenHeight;

@end

NS_ASSUME_NONNULL_END
