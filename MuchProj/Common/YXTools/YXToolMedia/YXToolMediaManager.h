//
//  YXToolMediaManager.h
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/13.
//  Copyright © 2020 August. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#define kYXToolMediaManagerUrl @"YXToolMediaManagerUrl"
#define kYXToolMediaMute @"YXToolMediaMute"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YXVideoGravityType) {
    /** 等比例 */
    YXVideoGravityTypeEqualProportions,
    /** 铺满 */
    YXVideoGravityTypeCovered,
};

@interface YXToolMediaManager : NSObject

/**
 * 获取音视频时长
 * @param path 地址
 */
+ (NSInteger)yxGetMediaTimeByPath:(NSString *)path;

/**
 * 获取视频缩略图
 * @param videoUrl 视频地址
 * @param second 所需缩略图所在时间
 */
+ (UIImage *)yxGetVideoThumbnailWithVideoUrl:(NSString *)videoUrl
                                      second:(CGFloat)second;

/** 获取视频缩放类型，0等比例 1铺满 */
+ (YXVideoGravityType)yxGetVideoGravityWithVideoUrl:(NSString *)videoUrl;
+ (YXVideoGravityType)yxGetVideoGravityWithAsset:(AVAsset *)asset;

/**
 * 合并音视频
 * @param path 音视频储存地址地址
 * @param mediaArr 音视频地址数组（需包含@[@{kYXToolMediaManagerUrl:@"xxx", kYXToolMediaMute:@(NO)}]）
 * @param bgmUrl 背景音乐地址
 * @param muteName 静音视频地址（需要先创建一个静音的.mp4）
 * @param boolMixing 是否混音
 * @param successBlock 成功回调
 * @param failBlock 失败回调
 */
+ (void)yxMergeMediaWithPath:(NSString *)path
                    mediaArr:(NSMutableArray *)mediaArr
                      bgmUrl:(NSString *__nullable)bgmUrl
                    muteName:(NSString *__nullable)muteName
                  boolMixing:(BOOL)boolMixing
                successBlock:(void(^)(id success))successBlock
                   failBlock:(void(^)(id fail))failBlock;
/**
 * 合并背景音乐
 * @param mediaPath 视频地址
 * @param bgmUrl 背景音乐地址
 * @param boolMixing 是否混音
 * @param successBlock 成功回调
 * @param failBlock 失败回调
 */
+ (void)yxMergeBgmWithPath:(NSString *)mediaPath
                    bgmUrl:(NSString *__nullable)bgmUrl
                boolMixing:(BOOL)boolMixing
              successBlock:(void(^)(id success))successBlock
                 failBlock:(void(^)(id fail))failBlock;

/**
 * 合并两张图片
 * @param bgImgValue 背景图
 * @param bgImgFrame 背景图大小（可不传，默认为图片大小）
 * @param topImgValue 顶层图
 * @param topImgFrame 顶层图大小（可不传，默认为图片大小）
 * @param saveToFileWithName 储存至沙盒的名称（如不需要储存，可不传）
 * @param boolByBgView 是否依赖于背景图大小绘制
 */
+ (UIImage *)yxComposeImgWithBgImgValue:(id)bgImgValue
                             bgImgFrame:(CGRect)bgImgFrame
                            topImgValue:(id)topImgValue
                            topImgFrame:(CGRect)topImgFrame
                     saveToFileWithName:(NSString *)saveToFileWithName
                           boolByBgView:(BOOL)boolByBgView;

/**
 * 获取本地Bundle组成gif
 * @param bundleName .bundle的名称
 */
+ (NSArray *)yxGetAnimationImagesByBundleName:(NSString *)bundleName;

@end

NS_ASSUME_NONNULL_END
