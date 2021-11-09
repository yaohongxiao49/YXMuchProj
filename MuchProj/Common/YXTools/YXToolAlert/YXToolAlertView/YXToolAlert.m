//
//  YXToolAlert.m
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/13.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXToolAlert.h"
#import "YXToolAlertVC.h"

static UIWindow *_alertWindow = nil;

@interface YXToolAlert ()

@end

@implementation YXToolAlert

#pragma mark - 释放资源
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 状态栏设置
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    
    _statusBarStyle = statusBarStyle;
    
    YXToolAlertVC *alertVC = (YXToolAlertVC *)_alertWindow.rootViewController;
    alertVC.statusBarStyle = statusBarStyle;
    [alertVC setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - 初始化默认弹窗
+ (YXToolAlert *)yxShowAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles tapBlock:(YXToolAlertBlock)tapBlock {
    
    return [self yxShowAlertWithTitle:title message:message style:YXToolAlertTypeDefault buttonTitles:buttonTitles tapBlock:tapBlock];
}

#pragma mark - 初始化弹窗（可选类型）
+ (YXToolAlert *)yxShowAlertWithTitle:(NSString *)title message:(NSString *)message style:(YXToolAlertType)style buttonTitles:(NSArray *)buttonTitles tapBlock:(YXToolAlertBlock)tapBlock {
    
    return [self yxShowAlertWithTitle:title message:message style:style buttonTitles:buttonTitles isShow:YES tapBlock:tapBlock];
}

#pragma mark - 初始化弹窗（可选类型，是否弹出）
+ (YXToolAlert *)yxShowAlertWithTitle:(NSString *)title message:(NSString *)message style:(YXToolAlertType)style buttonTitles:(NSArray *)buttonTitles isShow:(BOOL)isShow tapBlock:(YXToolAlertBlock)tapBlock {
    
    if (_alertWindow == nil) {
        _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _alertWindow.backgroundColor = [UIColor clearColor];
        _alertWindow.rootViewController = [[YXToolAlertVC alloc] init];
    }
    
    YXToolAlert *alertView = [YXToolAlert alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    alertView.statusBarStyle = UIStatusBarStyleDefault;
    alertView.alertViewStyle = style;
    alertView.buttonTitles = [NSMutableArray arrayWithArray:buttonTitles];
    alertView.tapBlock = tapBlock;
    
    //设置内容
    [alertView setContent];
    
    //是否弹出
    if (isShow) {
        [alertView yxShowAlert];
    }

    return alertView;
}

#pragma mark - 设置内容
- (void)setContent {
    
    //进入后台关闭弹框(默认:YES)
    _isEnterBackgroundClose = YES;
    
    //监听进入后台的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];

    //设置按钮
    for (NSInteger i = 0; i < _buttonTitles.count; ++i) {
        [self yxAddButtonTitle:_buttonTitles[i] style:UIAlertActionStyleDefault];
    }
}

#pragma mark - 弹出
- (void)yxShowAlert {
    
    _alertWindow.hidden = NO;
    _alertWindow.windowLevel = UIWindowLevelAlert;
    [_alertWindow makeKeyAndVisible];
    [_alertWindow.rootViewController presentViewController:self animated:YES completion:nil];
}

#pragma mark - 单独添加按钮
- (void)yxAddButtonTitle:(NSString *)title style:(UIAlertActionStyle)style {
    
    __weak typeof(self) alertVC = self;
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
        
        _alertWindow.hidden = YES;
        [_alertWindow resignKeyWindow];
        
        NSUInteger index = [alertVC.actions indexOfObject:action];
        if (alertVC.tapBlock) {
            alertVC.tapBlock(alertVC, index);
        }
    }];
    [self addAction:alertAction];
}

#pragma mark - 设置弹框样式
- (void)setAlertViewStyle:(YXToolAlertType)alertViewStyle {
    
    _alertViewStyle = alertViewStyle;
    
    __weak typeof(self) weakSelf = self;
    if (_alertViewStyle == YXToolAlertTypeDefault) {
    
    }
    else if (_alertViewStyle == YXToolAlertTypePlainTextInput || _alertViewStyle == YXToolAlertTypeSecureTextInput) {
        [self addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            if (weakSelf.alertViewStyle == YXToolAlertTypePlainTextInput) {
                textField.secureTextEntry = NO;
            }
            else {
                textField.secureTextEntry = YES;
            }
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }];
    }
    else if (_alertViewStyle == YXToolAlertTypeLoginWithPasswordInput) {
        [self addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.secureTextEntry = NO;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }];
        [self addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.secureTextEntry = YES;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }];
    }
}

#pragma mark - 外部获取输入框
- (UITextField *)yxTextFieldAtIndex:(NSInteger)textFieldIndex {
    
    if ((_alertViewStyle == YXToolAlertTypePlainTextInput || _alertViewStyle == YXToolAlertTypeSecureTextInput || _alertViewStyle == YXToolAlertTypeLoginWithPasswordInput) && textFieldIndex == 0) {
        return self.textFields[0];
    }
    else if (_alertViewStyle == YXToolAlertTypeLoginWithPasswordInput && textFieldIndex == 1) {
        return self.textFields[1];
    }
    
    return nil;
}

#pragma mark - 监听进入后台
- (void)applicationDidEnterBackground {
    
    if (_isEnterBackgroundClose) {
//        _alertWindow.hidden = YES;
//        _alertWindow.windowLevel = UIWindowLevelNormal - 1;
//        [_alertWindow resignKeyWindow];
//
//        _tapBlock = nil;
//        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

@end
