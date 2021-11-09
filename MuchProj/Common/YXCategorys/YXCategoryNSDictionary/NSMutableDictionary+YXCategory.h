//
//  NSMutableDictionary+YXCategory.h
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (YXCategory)

/**
 * 检查获取的value值
 * @param key 键
 */
- (id)yxObjForKey:(id<NSCopying>)key;

/**
 * 检查设置的value值
 * @param obj 值
 * @param key 键
 */
- (void)yxSetObj:(id)obj
          forKey:(id<NSCopying>)key;

/**
 * 将可能存在model数组转化为普通数组
 * @param origin 模型
 */
+ (id)yxArrayOrDicWithObject:(id)origin;

/**
 * 将链接中的参数转为字典
 * @param url 链接
 */
+ (NSDictionary *)yxConversionToDicByUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
