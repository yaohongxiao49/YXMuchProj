//
//  YXBaseVC.m
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#import "YXBaseVC.h"

@interface YXBaseVC ()

@end

@implementation YXBaseVC

#pragma mark - 支持的屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - 初始化
- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

#pragma mark - 加载视图
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
    }
    else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 把指定的VC设置到最前并返回
- (YXBaseVC *)bringVCToFront:(NSString *)vcName animated:(BOOL)animated {
    
    YXBaseVC *tempVC = nil;
    UINavigationController *naVC = self.navigationController;
    NSMutableArray *vcArr = naVC.viewControllers.mutableCopy;
    NSMutableIndexSet *deleteIndexs = [NSMutableIndexSet indexSet];
    for (NSInteger i = 0; i < vcArr.count; ++i) {
        UIViewController *vc = vcArr[i];
        NSString *tempVCName = NSStringFromClass([vc class]);
        if ([tempVCName isEqualToString:vcName]) {
            [deleteIndexs addIndex:i];
            tempVC = (YXBaseVC *)vc;
        }
    }
    
    YXBaseVC *lastVC = [vcArr lastObject];
    if (deleteIndexs.count > 0 && tempVC != lastVC) {
        [vcArr removeObjectsAtIndexes:deleteIndexs];
        [naVC setViewControllers:vcArr animated:NO];
    }
    
    if (tempVC && tempVC != lastVC) {
        tempVC.hidesBottomBarWhenPushed = YES;
        [naVC pushViewController:tempVC animated:animated];
    }
    
    return tempVC;
}

#pragma mark - 移除指定的VC并返回最前的VC
- (YXBaseVC *)removeVCByVCNameArr:(NSArray *)vcNameArr animated:(BOOL)animated {
    
    UINavigationController *naVC = self.navigationController;
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
    
    YXBaseVC *lastVC = [vcArr lastObject];
    return lastVC;
}

#pragma mark - 懒加载
- (YXBaseNavigationView *)navView {
    
    if (!_navView) {
        __weak typeof(self) weakSelf = self;
        
        _navView = [[YXBaseNavigationView alloc] init];
        _navView.clickBackBlock = ^{

            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        [self.view addSubview:_navView];
        
        [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.and.right.and.top.equalTo(self.view);
            make.height.mas_equalTo(kYXNavigationBarHeight);
        }];
        [_navView setNeedsLayout];
        [_navView layoutIfNeeded];
    }
    return _navView;
}

@end
