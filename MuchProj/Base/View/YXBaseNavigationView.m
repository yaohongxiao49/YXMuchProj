//
//  YXBaseNavigationView.m
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#import "YXBaseNavigationView.h"

@interface YXBaseNavigationView ()

@end

@implementation YXBaseNavigationView

#pragma mark - progress
#pragma mark - 返回
- (void)progressBackBtn {
    
    if (self.clickBackBlock) {
        self.clickBackBlock();
    }
}

#pragma mark - 初始化视图
- (void)initView {
    
    self.backBtn.hidden = YES;
    self.titleLab.hidden = NO;
    self.lineImgV.hidden = YES;
}

#pragma mark - 懒加载
- (UIView *)bgView {
    
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.and.right.and.bottom.equalTo(self);
            make.height.mas_equalTo(44);
        }];
    }
    return _bgView;
}
- (UIButton *)backBtn {
    
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:kYXImage(@"") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(progressBackBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_backBtn];
        
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.and.bottom.and.top.equalTo(self.bgView);
            make.height.mas_equalTo(self.bgView.mas_width);
        }];
    }
    return _backBtn;
}
- (UILabel *)titleLab {
    
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = kYXFontBold(16);
        _titleLab.textColor = kYXTitleNormalColor;
        [self.bgView addSubview:_titleLab];
        
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.backBtn.mas_right).with.offset(15);
            make.right.equalTo(self.bgView).with.offset(15);
            make.centerY.equalTo(self.bgView);
        }];
    }
    return _titleLab;
}
- (UIImageView *)lineImgV {
    
    if (!_lineImgV) {
        _lineImgV = [[UIImageView alloc] init];
        _lineImgV.contentMode = UIViewContentModeScaleAspectFit;
        _lineImgV.backgroundColor = kYXDividerLineColor;
        [self.bgView addSubview:_lineImgV];
        
        [_lineImgV mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.and.bottom.right.equalTo(self.bgView);
            make.height.mas_equalTo(1);
        }];
    }
    return _lineImgV;
}

@end
