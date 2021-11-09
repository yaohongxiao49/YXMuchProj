//
//  NSMutableArray+YXCategory.h
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (YXCategory)

/**
 * 转模型
 * @param result 需要转换的参数（数组）
 * @param className 需要转换的对应模型名
 * @param valuePath 需要转换的对应地址（一般跟"className"一致）
 */
+ (NSArray *)yxConversionToModelByResult:(id)result
                               className:(NSString *)className
                               valuePath:(NSString *)valuePath;

/**
 * 去除重复数据
 * @param arr 需要去除重复数据的数组
 */
+ (NSMutableArray *)yxStatisticalRepeatNum:(NSMutableArray *)arr;

/**
 * 排序
 * @param arr 需要排序的数组
 * @param type 排序规则
 */
+ (NSArray *)yxSortingByArr:(NSArray *)arr type:(NSComparisonResult)type;

/**
 * 去重并统计重复数据
 * @param arr 需要计算的数组
 */
- (NSMutableArray *)yxStatisticalRepeatNum:(NSMutableArray *)arr;


@end

NS_ASSUME_NONNULL_END
