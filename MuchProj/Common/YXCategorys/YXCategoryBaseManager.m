//
//  YXBaseManager.m
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXCategoryBaseManager.h"

@interface YXCategoryBaseManager () <CBCentralManagerDelegate>

@end

@implementation YXCategoryBaseManager

+ (YXCategoryBaseManager *)instanceManager {
    
    static YXCategoryBaseManager *yxBaseManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        yxBaseManager = [YXCategoryBaseManager new];
    });
    
    return yxBaseManager;
}

#pragma mark - 钩子方法
+ (void)swizzlingInClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    
    Class class = cls;
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark - 打电话
+ (void)yxCallMobile:(NSString *)mobile {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", mobile]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly:@YES};
        [[UIApplication sharedApplication] openURL:url options:options completionHandler:nil];
    }
}

#pragma mark - 发短信
- (void)yxSendSMSByMobile:(NSString *)mobile {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", mobile]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly:@YES};
        [[UIApplication sharedApplication] openURL:url options:options completionHandler:nil];
    }
}

#pragma mark - 打开app设置页面
- (void)yxOpenAppSetting {
    
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly:@YES};
        [[UIApplication sharedApplication] openURL:url options:options completionHandler:nil];
    }
}

#pragma mark - 打开safari
- (void)yxOpenSafariByUrl:(NSString *)url {
    
    NSURL *urls = [NSURL URLWithString:url];
    if ([[UIApplication sharedApplication] canOpenURL:urls]) {
        NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly:@YES};
        [[UIApplication sharedApplication] openURL:urls options:options completionHandler:nil];
    }
}

#pragma mark - 打开app商店
- (void)yxOpenAppStoreByIdent:(NSString *)ident boolDetail:(BOOL)boolDetail {
    
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@", ident];
    if (boolDetail) str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa /wa/viewContentsUserReviews?type=Purple+Software&id=%@", ident];
    
    NSURL *urls = [NSURL URLWithString:str];
    if ([[UIApplication sharedApplication] canOpenURL:urls]) {
        NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly:@YES};
        [[UIApplication sharedApplication] openURL:urls options:options completionHandler:nil];
    }
}

#pragma mark - 判断当前设备是否开启相机功能
- (void)yxJudgeAVCaptureDevice:(UIViewController *)vc resultBlock:(void(^)(BOOL boolSuccess))resultBlock {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        if (resultBlock) {
                            resultBlock(YES);
                        }
                    });
                }
            }];
        }
        else if (status == AVAuthorizationStatusAuthorized) {
            if (resultBlock) {
                resultBlock(YES);
            }
        }
        else if (status == AVAuthorizationStatusDenied) {
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"请在iPhone的”设置-隐私-相机”中，允许访问您的相机" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sureAlert = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@", @"确定"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self yxOpenAppSetting];
            }];
            UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@", @"取消"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
            
            [alertControl addAction:sureAlert];
            [alertControl addAction:cancelAlert];
            [vc presentViewController:alertControl animated:YES completion:nil];
            
        }
        else if (status == AVAuthorizationStatusRestricted) {
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"因为系统原因, 无法访问相册" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAlert = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@", @"确定"] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {}];
            
            [alertControl addAction:sureAlert];
            [vc presentViewController:alertControl animated:YES completion:nil];
        }
    }
    else {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@", @"未检测到您的摄像头"] message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAlert = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@", @"确定"] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {}];
        
        [alertControl addAction:sureAlert];
        [vc presentViewController:alertControl animated:YES completion:nil];
    }
}

#pragma mark - 判断权限开启情况
- (void)yxJudgePermissionsByType:(YXCategoryPermissionsType)type failBlock:(void(^)(void))failBlock {
    
    __weak typeof(self) weakSelf = self;
    __block CBCentralManager *centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
         
           dispatch_async(dispatch_get_main_queue(), ^{
               
               if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) { //相册权限
                   [weakSelf yxShowAlertViewWithTitle:@"无法访问相册" message:@"请在设置-隐私-照片中允许访问相册" buttonTitles:@[@"设置", @"取消"]];
               }
               else if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusRestricted || [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied) { //相机权限
                   [weakSelf yxShowAlertViewWithTitle:@"无法访问相机" message:@"请在设置-隐私-相机中允许访问相机" buttonTitles:@[@"设置", @"取消"]];
               }
               else if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio] == AVAuthorizationStatusRestricted || [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio] == AVAuthorizationStatusDenied) { //麦克风权限
                   [weakSelf yxShowAlertViewWithTitle:@"无法访问麦克风" message:@"请在设置-隐私-麦克风中允许访问麦克风" buttonTitles:@[@"设置", @"取消"]];
               }
               else if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) { //定位权限
                   [weakSelf yxShowAlertViewWithTitle:@"无法访问定位信息" message:@"请在设置-隐私-定位服务中允许访问定位信息" buttonTitles:@[@"设置", @"取消"]];
               }
               else if (![self yxGetNotificationPermissions]) {
                   [weakSelf yxShowAlertViewWithTitle:@"无法进行消息推送" message:@"请在设置-通知-app中允许通知" buttonTitles:@[@"设置", @"取消"]];
               }
               else if (self.cbManagerState != CBManagerStatePoweredOn) {
                   centralManager = nil;
                   [weakSelf yxShowAlertViewWithTitle:@"无法使用蓝牙" message:@"请在设置中检查蓝牙" buttonTitles:@[@"设置", @"取消"]];
               }
               else {
                   if (failBlock) {
                       failBlock();
                   }
               }
           });
       }];
}

#pragma mark - 获取推送权限
- (BOOL)yxGetNotificationPermissions {
    
    __block BOOL boolOpen;
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
       
        if (settings.authorizationStatus == UNAuthorizationStatusDenied || settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
            boolOpen = NO;
        }
        else {
            boolOpen = YES;
        }
    }];
    
    return boolOpen;
}

#pragma mark - <CBCentralManagerDelegate>获取蓝牙权限
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
 
    switch (central.state) {
        case CBManagerStatePoweredOn:
            NSLog(@"蓝牙开启且可用");
            break;
        case CBManagerStateUnknown:
            NSLog(@"手机没有识别到蓝牙，请检查手机。");
            break;
        case CBManagerStateResetting:
            NSLog(@"手机蓝牙已断开连接，重置中。");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"手机不支持蓝牙功能，请更换手机。");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"手机蓝牙功能关闭，请前往设置打开蓝牙及控制中心打开蓝牙。");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"手机蓝牙功能没有权限，请前往设置。");
            break;
        default:
            break;
    }
    self.cbManagerState = (int)central.state;
}

#pragma mark - 显示弹窗
- (void)yxShowAlertViewWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttontitles {
    
    NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly:@YES};
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@", title] message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAlert = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@", buttontitles[0]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:options completionHandler:nil];
    }];
    UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@", buttontitles[1]] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alertControl addAction:sureAlert];
    [alertControl addAction:cancelAlert];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertControl animated:YES completion:nil];
}

#pragma mark - 输入框输入字数限制
- (void)yxLimitInputByView:(id)view maxNum:(NSInteger)maxNum resultBlock:(void(^)(BOOL boolSuccess))resultBlock {
    
    if ([view isKindOfClass:[UITextField class]]) {
        UITextField *textField = view;
        NSString *toBeString = textField.text;
        
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxNum) {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxNum];
                if (rangeIndex.length == 1) {
                    textField.text = [toBeString substringToIndex:maxNum];
                    if (resultBlock) {
                        resultBlock(YES);
                    }
                }
                else {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxNum)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }
    else {
        UITextView *textView = view;
        NSString *toBeString = textView.text;
        
        //获取高亮部分
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxNum) {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxNum];
                if (rangeIndex.length == 1) {
                    textView.text = [toBeString substringToIndex:maxNum];
                    if (resultBlock) {
                        resultBlock(YES);
                    }
                }
                else {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxNum)];
                    textView.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }
}

#pragma mark - 替换控制器
- (void)yxReplaceVCByVC:(UIViewController *)vc toReplace:(UIViewController *)toReplace beReplaceVCName:(NSString *)beReplaceVCName {
    
    NSMutableArray *vcArr = [NSMutableArray arrayWithArray:vc.navigationController.viewControllers];
    [vcArr enumerateObjectsUsingBlock:^(id  _Nonnull vcObj, NSUInteger vcIdx, BOOL * _Nonnull stop) {
       
        if ([beReplaceVCName isKindOfClass:[vcObj class]]) {
            [vcArr replaceObjectAtIndex:vcIdx withObject:toReplace];
        }
    }];
    [toReplace setHidesBottomBarWhenPushed:YES];
    [vc.navigationController setViewControllers:vcArr animated:YES];
}

#pragma mark - 移除控制器
- (UIViewController *)yxRemoveVCByVCNameArr:(NSArray *)vcNameArr currentVC:(UIViewController *)currentVC animated:(BOOL)animated {
    
    UINavigationController *naVC = currentVC.navigationController;
    NSMutableArray *vcArr = naVC.viewControllers.mutableCopy;
    NSMutableIndexSet *deleteIndexs = [NSMutableIndexSet indexSet];
    for (NSInteger i = 0; i < vcArr.count; ++i) {
        UIViewController *vc = vcArr[i];
        NSString *vcName = NSStringFromClass([vc class]);
        if ([vcNameArr containsObject:vcName]) {
            [deleteIndexs addIndex:i];
        }
    }
    
    if (deleteIndexs.count > 0) {
        [vcArr removeObjectsAtIndexes:deleteIndexs];
        [naVC setViewControllers:vcArr animated:animated];
    }
    
    UIViewController *lastVC = [vcArr lastObject];
    return lastVC;
}

@end
