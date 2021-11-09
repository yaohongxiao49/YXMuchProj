//
//  YXProgressSlider.m
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#import "YXProgressSlider.h"

@interface YXProgressSlider ()

/** 滑动的水平方向 */
@property (nonatomic, assign) NSInteger panDirectionH;
/** 滑动的垂直方向 */
@property (nonatomic, assign) NSInteger panDirectionV;
/** 滑动的起点位置 */
@property (nonatomic, assign) CGPoint panBeganPoint;

@end

@implementation YXProgressSlider

#pragma mark - 初始化
- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder*)coder {
    
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize {
    
    [self initView];
    [self addGesture];
    [self initData];
}

#pragma mark - 添加手势
- (void)addGesture {
    
    _panGesture = [[UIPanGestureRecognizer alloc] init];
    [_panGesture addTarget:self action:@selector(panGesture:)];
    [_sliderBaseView addGestureRecognizer:_panGesture];
}

#pragma mark - 滑动手势
- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    
    if (_isHiddenSlider) {
        return;
    }
    
    CGPoint panPoint = [gesture translationInView:self];
    
    //手势开始
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _panDirectionH = -1;
        _panDirectionV = -1;
        _panBeganPoint = [gesture locationInView:self];
        
        //按住滑块的回调
        if (_touchBeganBlock) {
            _touchBeganBlock();
        }
    }
    
    //手势滑动
    if (gesture.state == UIGestureRecognizerStateChanged) {
        if (_panDirectionV == -1 && _panDirectionH == -1) {
            if (fabs(panPoint.x) > fabs(panPoint.y)) {
                //水平滑动
                _panDirectionH = 1;
                _panDirectionV = 0;
            }
            else if (fabs(panPoint.x) < fabs(panPoint.y)) {
                //竖直滑动
                _panDirectionV = 1;
                _panDirectionH = 0;
            }
        }
        
        if (_panDirectionV == 1) {
            //竖直滑动
            if (panPoint.y >= 0) {
                //NSLog(@"向下 -- : %f", panPoint.y);
            }
            else {
                //NSLog(@"向上 -- : %f", -panPoint.y);
            }
        }
        else if (_panDirectionH == 1) {
            //水平滑动
            if (panPoint.x >= 0) {
                //NSLog(@"向右 -- : %f", panPoint.x);
            }
            else {
                //NSLog(@"向左 -- : %f", panPoint.x);
            }
            
            CGFloat margin = (_sliderTouchSize - _sliderSize) / 2.f;
            CGFloat minX = -margin;
            CGFloat maxX = self.width - _sliderTouchSize + margin;
            CGFloat panX = [gesture locationInView:self].x - (_sliderTouchSize / 2.f);
            if (panX < minX) {
                panX = minX;
            }
            else if (panX > maxX) {
                panX = maxX;
            }
            
            CGFloat ratio = (panX + margin) / (maxX + margin);
            _value = ratio * (_maximumValue - _minimumValue) + _minimumValue;
            _sliderBaseView.x = panX;
            _minimumView.width = self.width * ratio;
            
            //滑动滑块的回调
            if (_valueChangedBlock) {
                _valueChangedBlock(_value);
            }
        }
    }
    
    //滑动结束或取消
    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed) {
        if (_panDirectionV == 1) {
            //NSLog(@"竖直滑动距离 -- : %f", panPoint.y);
        }
        else if (_panDirectionH == 1) {
            //NSLog(@"水平滑动距离 -- : %f", panPoint.x);
        }
        
        //还原记录
        _panDirectionH = -1;
        _panDirectionV = -1;
        _panBeganPoint = CGPointZero;
        
        //放开滑块的回调
        if (_touchEndedBlock) {
            _touchEndedBlock();
        }
    }
}

#pragma mark - setting
#pragma mark - 设置滑块颜色
- (void)setSliderColor:(UIColor *)sliderColor {
    
    _sliderColor = sliderColor;
    _sliderView.backgroundColor = sliderColor;
}

#pragma mark - 设置最小值颜色
- (void)setMinimumColor:(UIColor *)minimumColor {
    
    _minimumColor = minimumColor;
    _minimumView.backgroundColor = minimumColor;
}

#pragma mark - 设置最大值颜色
- (void)setMaximumColor:(UIColor *)maximumColor {
    
    _maximumColor = maximumColor;
    _maximumView.backgroundColor = maximumColor;
}

#pragma mark - 设置是否隐藏滑块
- (void)setIsHiddenSlider:(BOOL)isHiddenSlider {

    _isHiddenSlider = isHiddenSlider;
    _sliderView.hidden = isHiddenSlider;
    _panGesture.enabled = !isHiddenSlider;
}

#pragma mark - 设置是否隐藏进度条圆角
- (void)setIsHiddenCorner:(BOOL)isHiddenCorner {
    
    _isHiddenCorner = isHiddenCorner;
    [self setProgressHeight:_progressHeight];
}

#pragma mark - 设置当前的值
- (void)setValue:(CGFloat)value {
    
    _value = value < 0 ? 0 : value;
    [self layoutSubviews];
}
- (void)setProgressValue:(CGFloat)value animated:(BOOL)animated {
    
    _value = value < 0 ? 0 : value;
    
    if (animated) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
            
            [weakSelf layoutSubviews];
        }
        completion:^(BOOL finished) {
            
        }];
    }
    else {
        [self layoutSubviews];
    }
}

#pragma mark - 设置最小值
- (void)setMinimumValue:(CGFloat)minimumValue {
    
    _minimumValue = minimumValue;
    [self layoutSubviews];
}

#pragma mark - 设置最大值
- (void)setMaximumValue:(CGFloat)maximumValue {
    
    _maximumValue = maximumValue;
    [self layoutSubviews];
}

#pragma mark - 设置滑块触摸区域大小
- (void)setSliderTouchSize:(CGFloat)sliderTouchSize {
    
    _sliderTouchSize = sliderTouchSize;
    [self layoutSubviews];
}

#pragma mark - 设置滑块大小
- (void)setSliderSize:(CGFloat)sliderSize {
    
    _sliderSize = sliderSize;
    _sliderView.layer.cornerRadius = sliderSize / 2.f;
    [self layoutSubviews];
}

#pragma mark - 设置进度条高度
- (void)setProgressHeight:(CGFloat)progressHeight {
    
    _progressHeight = progressHeight;
    
    if (_isHiddenCorner) {
        _minimumView.layer.cornerRadius = 0.f;
        _maximumView.layer.cornerRadius = 0.f;
    }
    else {
        _minimumView.layer.cornerRadius = progressHeight / 2.f;
        _maximumView.layer.cornerRadius = progressHeight / 2.f;
    }
    
    [self layoutSubviews];
}

#pragma mark - 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 0;
    CGFloat ratio = 0;
    if (_sliderTouchSize > 0 && _sliderSize > 0) {
        margin = (_sliderTouchSize - _sliderSize) / 2.f;
        ratio = (_value - _minimumValue) / (_maximumValue - _minimumValue);
    }
    
    CGFloat left = (self.width - _sliderSize) * ratio - margin;
    _sliderBaseView.frame = CGRectMake(left, (self.height - _sliderTouchSize) / 2.f, _sliderTouchSize, _sliderTouchSize);
    _sliderView.frame = CGRectMake((_sliderTouchSize - _sliderSize) / 2.f, (_sliderTouchSize - _sliderSize) / 2.f, _sliderSize, _sliderSize);
    
    _minimumView.frame = CGRectMake(0, (self.height - _progressHeight) / 2.f, self.width * ratio, _progressHeight);
    _maximumView.frame = CGRectMake(0, (self.height - _progressHeight) / 2.f, self.width, _progressHeight);
}

#pragma mark - 初始化视图
- (void)initView {
    
    //滑块底视图
    _sliderBaseView = [[UIView alloc] init];
    _sliderBaseView.backgroundColor = [UIColor clearColor];
    [self addSubview:_sliderBaseView];
    
    //滑块视图
    _sliderView = [[UIImageView alloc] init];
    _sliderView.layer.masksToBounds = YES;
    [_sliderBaseView addSubview:_sliderView];
    
    //最小值视图
    _minimumView = [[UIView alloc] init];
    _minimumView.layer.masksToBounds = YES;
    [self addSubview:_minimumView];
    
    //最大值视图
    _maximumView = [[UIView alloc] init];
    _maximumView.layer.masksToBounds = YES;
    [self addSubview:_maximumView];
    [self sendSubviewToBack:_maximumView];
    [self bringSubviewToFront:_sliderBaseView];
}

#pragma mark - 初始化数据
- (void)initData {
    
    self.backgroundColor = [UIColor clearColor];
    self.sliderColor = [UIColor whiteColor];
    self.minimumColor = [UIColor whiteColor];
    self.maximumColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    self.isHiddenSlider = NO;
    self.isHiddenCorner = NO;
    
    self.value = 0;
    self.minimumValue = 0;
    self.maximumValue = 1;
    
    self.sliderTouchSize = 30;
    self.sliderSize = 10;
    self.progressHeight = 2;
}

@end
