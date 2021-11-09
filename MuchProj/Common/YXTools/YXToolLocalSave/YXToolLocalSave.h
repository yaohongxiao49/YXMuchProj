//
//  YXToolLocalSave.h
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/10.
//  Copyright © 2020 August. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 储存类型 */
typedef NS_ENUM(NSUInteger, YXToolLocalSaveMediaType) {
    /** 图片 */
    YXToolLocalSaveMediaTypeImg,
    /** 视频 */
    YXToolLocalSaveMediaTypeVideo,
    /** 音频 */
    YXToolLocalSaveMediaTypeAudio,
};

@interface YXToolLocalSave : NSObject

/**
 * 多媒体储存到相册
 * @param path 音视频/图片地址
 * @param successBlock 成功回调
 * @param failBlock 失败回调
 */
+ (void)yxSaveMediaByPath:(NSString *)path
                mediaType:(YXToolLocalSaveMediaType)mediaType
             successBlock:(void(^)(void))successBlock
                failBlock:(void(^)(id fail))failBlock;

@end

NS_ASSUME_NONNULL_END
