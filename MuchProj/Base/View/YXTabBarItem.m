//
//  YXTabBarItem.m
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#import "YXTabBarItem.h"

@implementation YXTabBarItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - progress
- (void)progressBtn {
    
    if (self.clickItemBlock) {
        self.clickItemBlock(self.itemIndex);
    }
}

#pragma mark - 设置项目数据
- (void)setItemModel:(YXTabBarItemModel *)itemModel {
    
    _itemModel = itemModel;
    self.iconImgV.image = [UIImage imageNamed:_itemModel.normalIconName];
    self.titleLab.text = _itemModel.title;
    self.titleLab.textColor = _itemModel.normalTitleColor;
}

#pragma mark - 设置项目状态
- (void)setItemState:(YXTabBarItemModelState)itemState {
    
    _itemState = itemState;
    switch (_itemState) {
        case YXTabBarItemModelStateNormal: {
            self.iconImgV.image = [UIImage imageNamed:self.itemModel.normalIconName];
            self.titleLab.textColor = self.itemModel.normalTitleColor;
            break;
        }
        case YXTabBarItemModelStateSelected: {
            self.iconImgV.image = [UIImage imageNamed:self.itemModel.selectedIconName];
            self.titleLab.textColor = self.itemModel.selectedTitleColor;
            break;
        }
        default:
            break;
    }
}

#pragma mark - 初始化视图
- (void)initView {
    
    self.btn.hidden = self.titleLab.hidden = NO;
}

#pragma mark - 懒加载
- (UIButton *)btn {
    
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn addTarget:self action:@selector(progressBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
        
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.equalTo(self);
        }];
    }
    return _btn;
}
- (UIImageView *)iconImgV {
    
    if (!_iconImgV) {
        _iconImgV = [[UIImageView alloc] init];
        _iconImgV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_iconImgV];
        
        [_iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.and.right.equalTo(self);
            make.bottom.equalTo(self.titleLab.mas_top).with.offset(- 2);
            make.height.mas_equalTo(24);
        }];
    }
    return _iconImgV;
}
- (UILabel *)titleLab {
    
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = kYXFontSystem(14);
        _titleLab.textColor = kYXTitleNormalColor;
        [self addSubview:_titleLab];
        
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.and.right.and.bottom.equalTo(self);
            make.height.mas_equalTo(16);
        }];
        
    }
    return _titleLab;
}

@end
