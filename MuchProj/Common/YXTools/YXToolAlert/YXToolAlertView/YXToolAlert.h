//
//  YXToolAlert.h
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/13.
//  Copyright © 2020 August. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 弹窗视图枚举 */
typedef NS_ENUM(NSInteger, YXToolAlertType) {
    /** 没有输入框 */
    YXToolAlertTypeDefault = 0,
    /** 纯文本输入框 */
    YXToolAlertTypePlainTextInput,
    /** 安全的文本输入框 */
    YXToolAlertTypeSecureTextInput,
    /** 账号和密码形式的输入框 */
    YXToolAlertTypeLoginWithPasswordInput,
};

@class YXToolAlert;
typedef void (^YXToolAlertBlock) (YXToolAlert * _Nonnull alertView, NSInteger buttonIndex);

NS_ASSUME_NONNULL_BEGIN

@interface YXToolAlert : UIAlertController

@property (nonatomic, assign) YXToolAlertType alertViewStyle;
@property (nonatomic, copy) YXToolAlertBlock tapBlock;

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, strong) NSMutableArray *buttonTitles;
@property (nonatomic, assign) NSInteger tag; //用来标记
/** 进入后台关闭弹框(默认:YES) */
@property (nonatomic, assign) BOOL isEnterBackgroundClose;

/**
 * 初始化默认弹窗
 * @param title 标题
 * @param message 描述
 * @param buttonTitles 按钮数组
 * @param tapBlock 按钮点击回调
 */
+ (YXToolAlert *)yxShowAlertWithTitle:(NSString *__nullable)title
                              message:(NSString *__nullable)message
                         buttonTitles:(NSArray *__nullable)buttonTitles
                             tapBlock:(YXToolAlertBlock)tapBlock;

/**
 * 初始化弹窗（可选类型）
 * @param title 标题
 * @param message 描述
 * @param style 弹窗类型
 * @param buttonTitles 按钮数组
 * @param tapBlock 按钮点击回调
 */
+ (YXToolAlert *)yxShowAlertWithTitle:(NSString *__nullable)title
                              message:(NSString *__nullable)message
                                style:(YXToolAlertType)style
                         buttonTitles:(NSArray *__nullable)buttonTitles
                             tapBlock:(YXToolAlertBlock)tapBlock;

/**
 * 初始化弹窗（可选类型，是否弹出）
 * @param title 标题
 * @param message 描述
 * @param style 弹窗类型
 * @param buttonTitles 按钮数组
 * @param isShow 是否立即弹出
 * @param tapBlock 按钮点击回调
 */
+ (YXToolAlert *)yxShowAlertWithTitle:(NSString *__nullable)title
                              message:(NSString *__nullable)message
                                style:(YXToolAlertType)style
                         buttonTitles:(NSArray *__nullable)buttonTitles
                               isShow:(BOOL)isShow
                             tapBlock:(YXToolAlertBlock)tapBlock;
/** 弹出弹出（一般与控制是否弹出的初始化方法配合使用） */
- (void)yxShowAlert;

/**
 * 外部获取输入框
 * @param textFieldIndex 需要获取的输入框下标（0/1）
 */
- (UITextField *)yxTextFieldAtIndex:(NSInteger)textFieldIndex;

/**
 * 弹窗中单独添加按钮
 * @param title 标题
 * @param style 类型
 */
- (void)yxAddButtonTitle:(NSString *)title
                   style:(UIAlertActionStyle)style;

@end

NS_ASSUME_NONNULL_END
