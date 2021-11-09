//
//  YXToolLogs.m
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/10.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXToolLogs.h"
#import <objc/runtime.h>

@implementation YXToolLogs

@end

#ifdef DEBUG

#pragma mark - 方法交换
static inline void yx_swizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector) {
    
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


#pragma mark - NSObject分类
@implementation NSObject (YXJSON)

#pragma mark - 将obj转换成json字符串，如果失败则返回nil
- (NSString *)convertToJsonString {
    
    //先判断是否能转化为JSON格式
    if (![NSJSONSerialization isValidJSONObject:self]) {
        return nil;
    }
    
    NSJSONWritingOptions jsonOptions = NSJSONWritingPrettyPrinted;
    if (@available(iOS 11.0, *)) {
        //11.0之后，可以将JSON按照key排列后输出，看起来会更舒服
        jsonOptions = NSJSONWritingPrettyPrinted | NSJSONWritingSortedKeys;
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error || !jsonData) {
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
    
}

@end

#pragma mark - NSDictionary分类
@implementation NSDictionary (YXJsonLog)

#pragma mark - 用此方法交换系统的descriptionWithLocale:方法，该方法在代码打印的时候调用
- (NSString *)yxJsonlog_descriptionWithLocale:(id)locale {
    
    //转换成JSON格式字符串
    NSString *result = [self convertToJsonString];
    if (!result) {
        //如果无法转换，就使用原先的格式
        return [self yxJsonlog_descriptionWithLocale:locale];
    }
    
    return result;
}

#pragma mark - 用此方法交换系统的descriptionWithLocale:indent:方法，功能同上
- (NSString *)yxJsonlog_descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    
    NSString *result = [self convertToJsonString];
    if (!result) {
        return [self yxJsonlog_descriptionWithLocale:locale indent:level];
    }
    
    return result;
}

#pragma mark - 用此方法交换系统的debugDescription方法，该方法在控制台使用po打印的时候调用
- (NSString *)yxJsonlog_debugDescription {
    
    NSString *result = [self convertToJsonString];
    if (!result) {
        return [self yxJsonlog_debugDescription];
    }
    
    return result;
}

#pragma mark - 在load方法中完成方法交换
+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        yx_swizzleSelector(class, @selector(descriptionWithLocale:), @selector(yxJsonlog_descriptionWithLocale:));
        yx_swizzleSelector(class, @selector(descriptionWithLocale:indent:), @selector(yxJsonlog_descriptionWithLocale:indent:));
        yx_swizzleSelector(class, @selector(debugDescription), @selector(yxJsonlog_debugDescription));
    });
}

@end

#pragma mark - NSArray分类
@implementation NSArray (YXJsonLog)

#pragma mark - 用此方法交换系统的descriptionWithLocale:方法，该方法在代码打印的时候调用
- (NSString *)yxJsonlog_descriptionWithLocale:(id)locale {
    
    NSString *result = [self convertToJsonString];
    if (!result) {
        return [self yxJsonlog_descriptionWithLocale:locale];
    }
    
    return result;
}

#pragma mark - 用此方法交换系统的descriptionWithLocale:indent:方法，功能同上
- (NSString *)yxJsonlog_descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    
    NSString *result = [self convertToJsonString];
    if (!result) {
        return [self yxJsonlog_descriptionWithLocale:locale indent:level];
    }
    
    return result;
}

#pragma mark - 用此方法交换系统的debugDescription方法，该方法在控制台使用po打印的时候调用
- (NSString *)yxJsonlog_debugDescription {
    
    NSString *result = [self convertToJsonString];
    if (!result) {
        return [self yxJsonlog_debugDescription];
    }
    
    return result;
}

#pragma mark - 在load方法中完成方法交换
+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        yx_swizzleSelector(class, @selector(descriptionWithLocale:), @selector(yxJsonlog_descriptionWithLocale:));
        yx_swizzleSelector(class, @selector(descriptionWithLocale:indent:), @selector(yxJsonlog_descriptionWithLocale:indent:));
        yx_swizzleSelector(class, @selector(debugDescription), @selector(yxJsonlog_debugDescription));
    });
}

@end

#endif
