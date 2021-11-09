//
//  NSMutableArray+YXCategory.m
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import "NSMutableArray+YXCategory.h"

@implementation NSMutableArray (YXCategory)

#pragma mark - 转换"className"模型
+ (NSArray *)yxConversionToModelByResult:(id)result className:(NSString *)className valuePath:(NSString *)valuePath {
    
    NSMutableArray *models = [NSMutableArray array];
    Class dataClass = NSClassFromString(className);
    if ([result isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in result) {
            id model = [[dataClass alloc] initWithDictionary:dic];
            [models addObject:model];
        }
    }
    else if ([result isKindOfClass:[NSDictionary class]]) {
        if (valuePath.length == 0) {
            id model = [[dataClass alloc] initWithDictionary:result];
            [models addObject:model];
        }
        else {
            NSArray *paths = [valuePath componentsSeparatedByString:@"."];
            NSDictionary *dic = result;
            for (int i = 0; i < paths.count - 1; i++) {
                NSString *subPath = paths[i];
                dic = dic[subPath];
            }
            for (NSDictionary *dict in dic[paths.lastObject]) {
                id model = [[dataClass alloc] initWithDictionary:dict];
                [models addObject:model];
            }
        }
    }
    
    return models;
}

#pragma mark - 去除重复数据
+ (NSMutableArray *)yxStatisticalRepeatNum:(NSMutableArray *)arr {
    
    NSSet *set = [NSSet setWithArray:(NSArray *)arr];
    
    NSMutableArray *endArr = [[NSMutableArray alloc] initWithArray:[set allObjects]];
    return endArr;
}

#pragma mark - 排序
+ (NSArray *)yxSortingByArr:(NSArray *)arr type:(NSComparisonResult)type {
    
    NSArray *resultArray = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSNumber *number1 = obj1;
        NSNumber *number2 = obj2;
        
        NSComparisonResult result = [number1 compare:number2];
        
        return result == type;
    }];
    return resultArray;
}

#pragma mark - 去重并统计重复数据
- (NSMutableArray *)yxStatisticalRepeatNum:(NSMutableArray *)arr {
    
    NSMutableArray *amountArr = [[NSMutableArray alloc] init];

    NSCountedSet *countSet = [[NSCountedSet alloc] initWithArray:(NSArray *)arr];
    for (id item in countSet) { //去重并统计
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:item forKey:@"naem"];
        [dic setObject:@([countSet countForObject:item]) forKey:@"count"];
        [amountArr addObject:dic];
    }
    
    return amountArr;
}

@end
