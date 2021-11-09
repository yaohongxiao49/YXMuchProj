//
//  PublicEvaluationStarView.m
//  Yanwei
//
//  Created by Believer Just on 2017/12/11.
//  Copyright © 2017年 DCloud. All rights reserved.
//

#import "YXEvaluationStarView.h"

typedef void(^completeBlock)(CGFloat currentScore);

@interface YXEvaluationStarView ()

@property (nonatomic, strong) UIView *foregroundStarView;
@property (nonatomic, strong) UIView *backgroundStarView;

@property (nonatomic, strong) completeBlock complete;

@property (nonatomic, assign) CGFloat starWidth;

@end

@implementation YXEvaluationStarView

#pragma mark - 代理方式
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = 5;
        _rateStyle = WholeStar;
        [self createStarView:NO boolAuto:NO];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars currentScore:(CGFloat)currentScore startfont:(UIFont *)startfont fullString:(NSString *)fullString emptyString:(NSString *)emptyString fullColor:(UIColor *)fullColor emptyColor:(UIColor *)emptyColor rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation delegate:(id)delegate {
    
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = numberOfStars;
        _currentScore = currentScore;
        _startfont = startfont;
        _fullString = fullString;
        _emptyString = emptyString;
        _fullColor = fullColor;
        _emptyColor = emptyColor;
        _rateStyle = rateStyle;
        _isAnimation = isAnimation;
        _delegate = delegate;
        [self createStarView:NO boolAuto:NO];
    }
    return self;
}

#pragma mark - block方式
- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation boolAutoImg:(BOOL)boolAutoImg finish:(finishBlock)finish fullImg:(NSString *)fullImg emptyImg:(NSString *)emptyImg {
    
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = numberOfStars;
        _rateStyle = rateStyle;
        _isAnimation = isAnimation;
        _complete = ^(CGFloat currentScore) {
            
            finish(currentScore);
        };
        _fullImgName = fullImg;
        _emptyImgName = emptyImg;
        [self createStarView:YES boolAuto:boolAutoImg];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame finish:(finishBlock)finish {
    
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = 5;
        _rateStyle = WholeStar;
        _complete = ^(CGFloat currentScore) {
            
            finish(currentScore);
        };
        [self createStarView:NO boolAuto:NO];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars currentScore:(CGFloat)currentScore startfont:(UIFont *)startfont fullString:(NSString *)fullString emptyString:(NSString *)emptyString fullColor:(UIColor *)fullColor emptyColor:(UIColor *)emptyColor rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation finish:(finishBlock)finish {
    
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = numberOfStars;
        _currentScore = currentScore;
        _startfont = startfont;
        _fullString = fullString;
        _emptyString = emptyString;
        _fullColor = fullColor;
        _emptyColor = emptyColor;
        _rateStyle = rateStyle;
        _isAnimation = isAnimation;
        _complete = ^(CGFloat currentScore) {
            
            finish(currentScore);
        };
        [self createStarView:NO boolAuto:NO];
    }
    return self;
}

#pragma mark - private Method
- (void)createStarView:(BOOL)boolImg boolAuto:(BOOL)boolAuto {
    
    if (boolImg) {
        self.foregroundStarView = [self createStarViewWithImage:_fullImgName boolAutoImg:boolAuto];
        self.backgroundStarView = [self createStarViewWithImage:_emptyImgName boolAutoImg:boolAuto];
    }
    else {
        self.foregroundStarView = [self createStarViewWithString:_fullString textColor:_fullColor textFont:_startfont];
        self.backgroundStarView = [self createStarViewWithString:_emptyString textColor:_emptyColor textFont:_startfont];
    }
    self.foregroundStarView.frame = CGRectMake(0, 0, _currentScore *self.starWidth, self.bounds.size.height);
    
    [self addSubview:self.backgroundStarView];
    [self addSubview:self.foregroundStarView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapRateView:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(userTapRateView:)];
    [panGestureRecognizer setMinimumNumberOfTouches:1];
    [panGestureRecognizer setMaximumNumberOfTouches:1];
    [self addGestureRecognizer:panGestureRecognizer];
}

- (UIView *)createStarViewWithString:(NSString *)starString textColor:(UIColor *)textColor textFont:(UIFont *)textFont {
    
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    for (NSInteger i = 0; i < self.numberOfStars; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i *self.starWidth, 0, self.starWidth, self.bounds.size.height)];
        label.text = starString;
        label.textColor = textColor;
        label.font = textFont;
        [view addSubview:label];
    }
    return view;
}

- (UIView *)createStarViewWithImage:(NSString *)imageName boolAutoImg:(BOOL)boolAutoImg {
    
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    for (NSInteger i = 0; i < self.numberOfStars; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i *self.starWidth, 0, self.starWidth, self.bounds.size.height);
        if (boolAutoImg) {
            imageView.contentMode = UIViewContentModeCenter;
        }
        else {
            imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        [view addSubview:imageView];
    }
    return view;
}

- (void)userTapRateView:(UITapGestureRecognizer *)gesture {
    
    CGPoint tapPoint = [gesture locationInView:self];
    CGFloat offset = tapPoint.x;
    CGFloat realStarScore = offset /self.starWidth;
    if (self.canotClick) {
        
    }
    else {
        switch (_rateStyle) {
            case WholeStar: {
                self.currentScore = ceilf(realStarScore);
                break;
            }
            case HalfStar:
                self.currentScore = roundf(realStarScore) > realStarScore ? ceilf(realStarScore) : (ceilf(realStarScore) - 0.5);
                break;
            case IncompleteStar:
                self.currentScore = realStarScore;
                break;
            default:
                break;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    __weak YXEvaluationStarView *weakSelf = self;
    CGFloat animationTimeInterval = self.isAnimation ? 0.2 : 0;
    [UIView animateWithDuration:animationTimeInterval animations:^{
        
        weakSelf.foregroundStarView.frame = CGRectMake(0, 0, weakSelf.currentScore *weakSelf.starWidth, weakSelf.bounds.size.height);
    }];
}

- (void)setCurrentScore:(CGFloat)currentScore {
    
    if (_currentScore == currentScore) {
        return;
    }
    if (currentScore < 0) {
        _currentScore = 0;
    }
    else if (currentScore > _numberOfStars) {
        _currentScore = _numberOfStars;
    }
    else {
        _currentScore = currentScore;
    }
    
    if ([self.delegate respondsToSelector:@selector(starRateView:currentScore:)]) {
        [self.delegate starRateView:self currentScore:_currentScore];
    }
    
    if (self.complete) {
        _complete(_currentScore);
    }
    
    [self setNeedsLayout];
}

#pragma mark - 星标宽度
- (CGFloat)starWidth {
    
    return ceilf(self.bounds.size.width /self.numberOfStars);
}

@end
