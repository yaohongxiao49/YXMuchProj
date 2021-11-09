//
//  NSMutableDictionary+YXCategory.m
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import "NSMutableDictionary+YXCategory.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (YXCategory)

#pragma mark - 模型转字典
+ (NSMutableDictionary *)yxDicFromObject:(NSObject *)obj {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([obj class], &count);
 
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        NSObject *value = [obj valueForKey:name]; //valueForKey返回的数字和字符串都是对象
 
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) { //string，bool，int，NSinteger
            [dic yxSetObj:value forKey:name];
        }
        else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) { //字典或字典
            [dic yxSetObj:[self yxArrayOrDicWithObject:(NSArray*)value] forKey:name];
        }
        else if (value == nil) { //null
            //[dic setObj:[NSNull null] forKey:name];
        }
        else { //model
            [dic yxSetObj:[self yxDicFromObject:value] forKey:name];
        }
    }
 
    return dic;
}

#pragma mark - 检查获取的value值
- (id)yxObjForKey:(id<NSCopying>)key {
    
    id obj = [self objectForKey:key];
    
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        return nil;
    }
    else if ([obj isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", obj];
    }
    
    return obj;
}

#pragma mark - 检查设置的value值
- (void)yxSetObj:(id)obj forKey:(id<NSCopying>)key {
    
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        obj = @"";
    }
    
    [self setObject:obj forKey:key];
}

#pragma mark - 将可能存在model数组转化为普通数组
+ (id)yxArrayOrDicWithObject:(id)origin {
    
   if ([origin isKindOfClass:[NSArray class]]) { //数组
       NSMutableArray *array = [NSMutableArray array];
       for (NSObject *object in origin) {
           if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) { //string，bool，int，NSinteger
               [array addObject:object];
           }
           else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) { //数组或字典
               [array addObject:[self yxArrayOrDicWithObject:(NSArray *)object]];
           }
           else { //model
               [array addObject:[self yxDicFromObject:object]];
           }
       }

       return [array copy];
   }
   else if ([origin isKindOfClass:[NSDictionary class]]) { //字典
       NSDictionary *originDic = (NSDictionary *)origin;
       NSMutableDictionary *dic = [NSMutableDictionary dictionary];
       for (NSString *key in originDic.allKeys) {
           id object = [originDic objectForKey:key];
           if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) { //string，bool，int，NSinteger
               [dic yxSetObj:object forKey:key];
           }
           else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) { //数组或字典
               [dic yxSetObj:[self yxArrayOrDicWithObject:object] forKey:key];
           }
           else { //model
               [dic yxSetObj:[self yxDicFromObject:object] forKey:key];
           }
       }

       return [dic copy];
   }

   return [NSNull null];
}

#pragma mark - 将链接中的参数转为字典
+ (NSDictionary *)yxConversionToDicByUrl:(NSString *)url {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSURL *realUrl = [NSURL URLWithString:url];
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:realUrl.absoluteString];
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [params setObject:obj.value forKey:obj.name];
    }];
    
    return params;
}

@end
