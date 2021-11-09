//
//  YXTabBarItemModel.h
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 项目状态 */
typedef NS_ENUM (NSInteger, YXTabBarItemModelState) {
    /** 正常状态 */
    YXTabBarItemModelStateNormal = 0,
    /** 选中状态 */
    YXTabBarItemModelStateSelected,
};

@interface YXTabBarItemModel : NSObject

/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 正常状态图标名称 */
@property (nonatomic, copy) NSString *normalIconName;
/** 选中状态图标名称 */
@property (nonatomic, copy) NSString *selectedIconName;
/** 正常状态标题颜色 */
@property (nonatomic, strong) UIColor *normalTitleColor;
/** 选中状态标题颜色 */
@property (nonatomic, strong) UIColor *selectedTitleColor;

@end

NS_ASSUME_NONNULL_END
