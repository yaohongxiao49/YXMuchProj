//
//  YXToolAlertVC.m
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/13.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXToolAlertVC.h"

@interface YXToolAlertVC ()

@end

@implementation YXToolAlertVC

#pragma mark - 状态栏设置
- (BOOL)prefersStatusBarHidden {
    
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return _statusBarStyle;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationSlide;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
