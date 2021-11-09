//
//  UIView+YXCategory.m
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/9.
//  Copyright © 2020 August. All rights reserved.
//

#import "UIView+YXCategory.h"
#import <objc/runtime.h>

static const char *kTapGestureRecognizerBlockAddress;

#pragma mark - 输入框限制
static const char kLimitInputWordsCountAddressKey;
static const char kFilterKeyWordsAddressKey;
static const char kFilterActionTypeAddressKey;

@implementation UIView (YXCategory)

#pragma mark - 视图x坐标
- (CGFloat)x {
    
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)x {
    
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

#pragma mark - 视图y坐标
- (CGFloat)y {
    
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)y {
    
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

#pragma mark - 视图宽
- (CGFloat)width {
    
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

#pragma mark - 视图高
- (CGFloat)height {
    
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

#pragma mark - 视图最右边坐标
- (CGFloat)right {
    
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setRight:(CGFloat)right {
    
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

#pragma mark - 视图最下边坐标
- (CGFloat)bottom {
    
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setBottom:(CGFloat)bottom {
    
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

#pragma mark - 视图中心x坐标
- (CGFloat)centerX {
    
    return self.center.x;
}
- (void)setCenterX:(CGFloat)centerX {
    
    self.center = CGPointMake(centerX, self.center.y);
}

#pragma mark - 视图中心y坐标
- (CGFloat)centerY {
    
    return self.center.y;
}
- (void)setCenterY:(CGFloat)centerY {
    
    self.center = CGPointMake(self.center.x, centerY);
}

#pragma mark - 视图坐标
- (CGPoint)origin {
    
    return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin {
    
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

#pragma mark - 视图大小
- (CGSize)size {
    
    return self.frame.size;
}
- (void)setSize:(CGSize)size {
    
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

#pragma mark - 获取当前视图所在的视图控制器
- (UIViewController *)viewController {
    
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - 添加点击手势
- (void)yxTapUpWithBlock:(void(^)(UIView *))aBlock {
    
    if (aBlock) {
        self.tapAction = aBlock;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelfTargetAction)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
}
- (void)setTapAction:(void (^)(UIView *))tapAction {
    
    objc_setAssociatedObject(self, &kTapGestureRecognizerBlockAddress, tapAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void(^)(UIView *))tapAction {
    
    return objc_getAssociatedObject(self, &kTapGestureRecognizerBlockAddress);
}
- (void)tapSelfTargetAction {
    
    id block = objc_getAssociatedObject(self, &kTapGestureRecognizerBlockAddress);
    if (!block) {
        return;
    }
    void(^touchUpBlock)(UIView *) = block;
    touchUpBlock(self);
}

#pragma mark - 指定圆角
+ (void)yxSpecifiedCornerFilletByView:(UIView *)view corners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

#pragma mark - 指定圆角带边框
+ (void)getSpecifiedFilletWithBorder:(UIView *)view corners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor {
    
    [self yxSpecifiedCornerFilletByView:view corners:corners cornerRadii:cornerRadii];
    [view.layer.sublayers enumerateObjectsUsingBlock:^(__kindof CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj isKindOfClass:[CAShapeLayer class]]) {
            [obj removeFromSuperlayer];
        }
    }];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.strokeColor = lineColor.CGColor;
    maskLayer.lineWidth = lineWidth;
    [view.layer addSublayer:maskLayer];
}

#pragma mark - 输入框限制
- (void)setFilterActionType:(int)filterActionType {
    
    objc_setAssociatedObject(self, &kFilterActionTypeAddressKey, [NSString stringWithFormat:@"%d", filterActionType], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (filterActionType == YXFilterNoneType) {
        return;
    }
    [self registerFilterNotification];
}

- (int)filterActionType {
    
    return 0;
}

- (NSString *)filterActionTypeString {
    
    return objc_getAssociatedObject(self, &kFilterActionTypeAddressKey);
}

- (void)setLimitInputWords:(int)limitInputWords {
    
    if (limitInputWords <= 0) {
        return;
    }
    objc_setAssociatedObject(self, &kLimitInputWordsCountAddressKey, [NSString stringWithFormat:@"%d", limitInputWords], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (int)limitInputWords {
    
    return [objc_getAssociatedObject(self, &kLimitInputWordsCountAddressKey) intValue];
}

- (NSArray *)filterKeyWordsArray {
    
    return objc_getAssociatedObject(self, &kFilterKeyWordsAddressKey);
}

- (void)setFilterKeyWordsArray:(NSArray *)filterKeyWordsArray {
    
    objc_setAssociatedObject(self, &kFilterKeyWordsAddressKey, filterKeyWordsArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)registerFilterNotification {
    
    NSString *textDidChangeNotificationName = ([self isKindOfClass:[UITextField class]] && ![(UITextField *)self isSecureTextEntry]) ?
    UITextFieldTextDidChangeNotification : [self isKindOfClass:[UITextView class]] ?
    UITextViewTextDidChangeNotification : nil;
    if(!textDidChangeNotificationName) {
        return;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeAction:) name:textDidChangeNotificationName object:nil];
}

- (void)textDidChangeAction:(NSNotification *)notify {
    
    NSString *selfText = [self valueForKey:@"text"];
    NSString *lang = [self.textInputMode primaryLanguage]; //键盘输入模式
    int limitCount = self.limitInputWords;
    YXFilterActionType actionType = [[self filterActionTypeString] intValue];
    if ([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self valueForKey:@"markedTextRange"];
        //获取高亮部分
        UITextPosition *position = nil;
        if ([self isKindOfClass:[UITextField class]]) {
            position = [(UITextField *)self positionFromPosition:selectedRange.start offset:0];
        }
        else if ([self isKindOfClass:[UITextView class]]) {
            position = [(UITextView *)self positionFromPosition:selectedRange.start offset:0];
        }
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if ((actionType & YXFilterLimitType || actionType & YXFilterLimitEmojiType) && selfText.length > limitCount) {
                selfText = [selfText substringToIndex:limitCount];
            }
            [self setValue:[self textFilterWordsWithText:selfText] forKey:@"text"];
        }
        //有高亮选择的字符串，则暂不对文字进行统计和限制
        else {
            
        }
    }
    //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else {
        if ((actionType & YXFilterLimitType || actionType & YXFilterLimitEmojiType) && selfText.length > limitCount) {
            selfText = [selfText substringToIndex:limitCount];
        }
        [self setValue:[self textFilterWordsWithText:selfText] forKey:@"text"];
    }
}

- (NSString *)textFilterWordsWithText:(NSString *)aText {
    
    NSString *tempString = aText;
    YXFilterActionType actionType = [[self filterActionTypeString] intValue];
    if (actionType == YXFilterNoneType) {
        return aText;
    }
    
    if (actionType & YXFilterKeyWordsType) {
        __block NSString *replaceString = tempString;
        [self.filterKeyWordsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            if ([obj isKindOfClass:[NSString class]] && [obj length] > 0) {
                replaceString = [replaceString stringByReplacingOccurrencesOfString:obj withString:@""];
            }
        }];
        tempString = replaceString;
    }
    
    if (actionType & YXFilterEmojiType || actionType & YXFilterLimitEmojiType) {
        tempString = [tempString stringByReplacingOccurrencesOfString:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [tempString length])];
    }
    return tempString;
}

@end
