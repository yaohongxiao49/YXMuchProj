//
//  YXTabBarView.m
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#import "YXTabBarView.h"

@interface YXTabBarView ()

/** 标签栏背景图 */
@property (nonatomic, strong) UIImageView *tabBarImageView;
/** 标签栏项目 */
@property (nonatomic, strong) NSMutableArray *tabBarItemArr;
@property (nonatomic, strong) NSMutableArray *itemModelArr;
/** 标签栏控制器 */
@property (nonatomic, weak) UITabBarController *tabBarVC;

@end

@implementation YXTabBarView

#pragma mark - 自定义标签栏
+ (YXTabBarView *)customTabBarWithTabBarVC:(UITabBarController *)tabBarVC {
    
    YXTabBarView *tabBar = [[YXTabBarView alloc] init];
    tabBar.tabBarVC = tabBarVC;
    [tabBar customTabBar];
    return tabBar;
}

- (void)customTabBar {
    
    __weak typeof(self) weakSelf = self;
        
    //替换默认标签栏
    self.backgroundColor = [UIColor clearColor];
    [_tabBarVC.tabBar addSubview:self];
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *standardAppearance = _tabBarVC.tabBar.standardAppearance;
        standardAppearance.backgroundEffect = nil;
        standardAppearance.backgroundColor = [UIColor clearColor];
        standardAppearance.backgroundImage = [[UIImage alloc] init];
        standardAppearance.shadowImage = [[UIImage alloc] init];
        standardAppearance.shadowColor = [UIColor clearColor];
        _tabBarVC.tabBar.standardAppearance = standardAppearance;
    }
    else {
        _tabBarVC.tabBar.backgroundImage = [[UIImage alloc] init];
        _tabBarVC.tabBar.shadowImage = [[UIImage alloc] init];
    }
    
    //阴影
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowRadius = 6;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    
    //标签栏背景图
    _tabBarImageView = [[UIImageView alloc] init];
    _tabBarImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tabBarImageView];
    
    //标签栏项目
    [self initTabBarItemData];
    _tabBarItemArr = [NSMutableArray array];
    for (NSInteger i = 0; i < _itemModelArr.count; ++i) {
        YXTabBarItem *tabBarItem = [[YXTabBarItem alloc] init];
        tabBarItem.itemModel = _itemModelArr[i];
        tabBarItem.itemIndex = i;
        tabBarItem.clickItemBlock = ^(NSInteger itemIndex) {
            
            [weakSelf setSelectedIndex:itemIndex];
            if (weakSelf.clickItemBlock) {
                weakSelf.clickItemBlock(itemIndex);
            }
        };
        [_tabBarItemArr addObject:tabBarItem];
        [self addSubview:tabBarItem];
    }
    
    //默认选中第一个
    [self setSelectedIndex:0];
}

#pragma mark - 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, 0, kYXWidth, kYXTabBarHeight);
    
    _tabBarImageView.frame = self.bounds;

    CGFloat itemWidth = self.width / _tabBarItemArr.count;
    CGFloat itemHeight = 49;
    for (NSInteger i = 0; i < _tabBarItemArr.count; ++i) {
        YXTabBarItem *tabBarItem = _tabBarItemArr[i];
        tabBarItem.frame = CGRectMake(i *itemWidth, 0, itemWidth, itemHeight);
    }
}

#pragma mark - 初始化标签栏项目数据
- (void)initTabBarItemData {
    
    //标题
    NSArray *titleArr = @[@"首页"];
    
    //正常状态图标
    NSArray *normalIconNameArr = @[@"YXBlindBoxTabNorImg"];
    
    //选中状态图标
    NSArray *selectedIconNameArr = @[@"YXBlindBoxTabSelImg"];
    
    //项目数据
    _itemModelArr = [NSMutableArray array];
    for (NSInteger i = 0; i < titleArr.count; ++i) {
        YXTabBarItemModel *model = [[YXTabBarItemModel alloc] init];
        model.title = titleArr[i];
        model.normalIconName = normalIconNameArr[i];
        model.selectedIconName = selectedIconNameArr[i];
        model.normalTitleColor = kYXTitleNormalColor;
        model.selectedTitleColor = kYXTitleSelectedColor;
        [_itemModelArr addObject:model];
    }
}

#pragma mark - 选中的控制器
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    YXTabBarItem *tabBarItem = _tabBarItemArr[_selectedIndex];
    tabBarItem.itemState = YXTabBarItemModelStateNormal;
    
    tabBarItem = _tabBarItemArr[selectedIndex];
    tabBarItem.itemState = YXTabBarItemModelStateSelected;
    
    _selectedIndex = selectedIndex;
    _tabBarVC.selectedIndex = selectedIndex;
}

@end
