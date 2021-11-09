//
//  YXToolMediaManager.m
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/13.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXToolMediaManager.h"

@implementation YXToolMediaManager

#pragma mark - 获取音视频时长
+ (NSInteger)yxGetMediaTimeByPath:(NSString *)path {
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    NSURL *url = [path containsString:@"http"] ? [NSURL URLWithString:path] : [NSURL fileURLWithPath:path];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    CMTime audioDuration = urlAsset.duration;
    int audioDurationSeconds = ceil(audioDuration.value /audioDuration.timescale);
    return (NSInteger)audioDurationSeconds;
}

#pragma mark - 获取视频缩略图
+ (UIImage *)yxGetVideoThumbnailWithVideoUrl:(NSString *)videoUrl second:(CGFloat)second {

    if (!videoUrl) {
        return nil;
    }
    NSURL *url = [videoUrl containsString:@"http"] ? [NSURL URLWithString:videoUrl] : [NSURL fileURLWithPath:videoUrl];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:audioAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    BOOL getThumbnail = YES;
    if (getThumbnail) { //缩略图及cell大小
        CGFloat width = [UIScreen mainScreen].scale *75;
        imageGenerator.maximumSize = CGSizeMake(width, width);
    }
    NSError *error = nil;
    //一秒想取多少帧
    CMTime time = CMTimeMake(second, 1);
    CMTime actucalTime;
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
    if (error) {
        NSLog(@"ERROR:获取视频图片失败, %@", error.description);
    }
    CMTimeShow(actucalTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return image;
}

#pragma mark - 获取视频缩放类型
+ (YXVideoGravityType)yxGetVideoGravityWithVideoUrl:(NSString *)videoUrl {
    
    AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:videoUrl]];
    return [self yxGetVideoGravityWithAsset:asset];
}
+ (YXVideoGravityType)yxGetVideoGravityWithAsset:(AVAsset *)asset {
    
    NSInteger videoGravity = 0;
    NSInteger degress = 0;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if (tracks.count > 0) {
        AVAssetTrack *videoTrack = [tracks firstObject];
        CGAffineTransform t = videoTrack.preferredTransform;
        if (t.a == 1.0 && t.b == 0.0 && t.c == 0.0 && t.d == 1.0) {
            degress = 0;
        }
        else if (t.a == 0.0 && t.b == 1.0 && t.c == -1.0 && t.d == 0.0) {
            degress = 90;
        }
        else if (t.a == -1.0 && t.b == 0.0 && t.c == 0.0 && t.d == -1.0) {
            degress = 180;
        }
        else if (t.a == 0.0 && t.b == -1.0 && t.c == 1.0 && t.d == 0.0) {
            degress = 270;
        }
        
        CGFloat videoScale = 1;
        if (degress == 0 || degress == 180) {
            videoScale = videoTrack.naturalSize.width / videoTrack.naturalSize.height;
        }
        else if (degress == 90 || degress == 270) {
            videoScale = videoTrack.naturalSize.height / videoTrack.naturalSize.width;
        }
        
        //9:16左右的视频铺满
        if (videoScale >= 0.5 && videoScale <= 0.6) {
            videoGravity = 1;
        }
    }
    return videoGravity == 0 ? YXVideoGravityTypeEqualProportions : YXVideoGravityTypeCovered;
}

#pragma mark - 合并音视频
+ (void)yxMergeMediaWithPath:(NSString *)path mediaArr:(NSMutableArray *)mediaArr bgmUrl:(NSString *)bgmUrl muteName:(NSString *)muteName boolMixing:(BOOL)boolMixing successBlock:(void(^)(id success))successBlock failBlock:(void(^)(id fail))failBlock {
    
    NSDictionary *optDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    //创建可变的音视频组
    AVMutableComposition *composition = [AVMutableComposition composition];
    //为视频类型的的Track
    AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //创建音轨，只合并视频，导出后声音会消失，所以需要把声音插入到混淆器中；添加音频，添加本地其他音乐也可以,与视频一致
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //设置音轨参数
    AVMutableAudioMixInputParameters *originAudioInputParams = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioTrack];
    [originAudioInputParams setTrackID:audioTrack.trackID];
    
    //创建最终混合的音频实例
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    
    NSArray *reversedArray = [[(NSArray *)mediaArr reverseObjectEnumerator] allObjects];
    [reversedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[obj objectForKey:kYXToolMediaManagerUrl] options:optDict];
        AVURLAsset *muteAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.mp4", muteName] ofType:nil]] options:nil];
        
        //由于没有计算当前CMTime的起始位置，现在插入0的位置,所以合并出来的视频是后添加在前面，可以计算一下时间，插入到指定位置
        //CMTimeRangeMake 指定起去始位置
        CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
        //插入视频轨道
        [compositionTrack insertTimeRange:timeRange ofTrack:[asset tracksWithMediaType:AVMediaTypeVideo][0] atTime:kCMTimeZero error:nil];
        
        //插入音频轨道
        if ([[obj objectForKey:kYXToolMediaMute] boolValue]) {
            [audioTrack insertTimeRange:timeRange ofTrack:([[muteAsset tracksWithMediaType:AVMediaTypeAudio] count] > 0) ? [muteAsset tracksWithMediaType:AVMediaTypeAudio][0] : nil atTime:kCMTimeZero error:nil];
        }
        else {
            [audioTrack insertTimeRange:timeRange ofTrack:([[asset tracksWithMediaType:AVMediaTypeAudio] count] > 0) ? [asset tracksWithMediaType:AVMediaTypeAudio][0] : nil atTime:kCMTimeZero error:nil];
        }
        
        [originAudioInputParams setVolumeRampFromStartVolume:1.0f toEndVolume:1.0f timeRange:timeRange];
    }];
    
    audioMix.inputParameters = @[originAudioInputParams];

    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:path];
    [YXToolLocalSaveBySqlite yxRemoveFileByPath:filePath];
    AVAssetExportSession *exporterSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
    exporterSession.outputFileType = AVFileTypeMPEG4;
    exporterSession.outputURL = [NSURL fileURLWithPath:filePath]; //如果文件已存在，将造成导出失败
    exporterSession.shouldOptimizeForNetworkUse = YES; //用于互联网传输
    exporterSession.audioMix = audioMix;
    [exporterSession exportAsynchronouslyWithCompletionHandler:^{
        
        switch (exporterSession.status) {
            case AVAssetExportSessionStatusUnknown:
                NSLog(@"exporter Unknow");
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"exporter Canceled");
                break;
            case AVAssetExportSessionStatusFailed: {
                NSLog(@"exporter Failed == %@", exporterSession.error.localizedDescription);
                if (failBlock) {
                    failBlock(exporterSession.error.localizedDescription);
                }
                break;
            }
            case AVAssetExportSessionStatusWaiting:
                NSLog(@"exporter Waiting");
                break;
            case AVAssetExportSessionStatusExporting:
                NSLog(@"exporter Exporting");
                break;
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"exporter Completed");
                if (bgmUrl) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [YXToolMediaManager yxMergeBgmWithPath:filePath bgmUrl:bgmUrl boolMixing:boolMixing successBlock:^(id  _Nonnull success) {
                            
                            if (successBlock) {
                                successBlock(success);
                            }
                        } failBlock:^(id  _Nonnull fail) {
                            
                            if (failBlock) {
                                failBlock(fail);
                            }
                        }];
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (successBlock) {
                            successBlock([NSURL fileURLWithPath:filePath]);
                        }
                    });
                }
                break;
        }
    }];
}

#pragma mark - 合并背景音乐
+ (void)yxMergeBgmWithPath:(NSString *)mediaPath bgmUrl:(NSString *)bgmUrl boolMixing:(BOOL)boolMixing successBlock:(void(^)(id success))successBlock failBlock:(void(^)(id fail))failBlock {
    
    NSDictionary *optDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    //创建可变的音视频组
    AVMutableComposition *composition = [AVMutableComposition composition];
    //为视频类型的的Track
    AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //创建音轨，只合并视频，导出后声音会消失，所以需要把声音插入到混淆器中；添加音频，添加本地其他音乐也可以,与视频一致
    AVMutableCompositionTrack *bgmAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //设置音轨参数
    AVMutableAudioMixInputParameters *bgmOriginAudioInputParams = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:bgmAudioTrack];
    [bgmOriginAudioInputParams setTrackID:bgmAudioTrack.trackID];
    
    //创建最终混合的音频实例
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    
    AVURLAsset *bgmAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:bgmUrl] options:optDict];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:mediaPath] options:optDict];
    
    CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    [compositionTrack insertTimeRange:timeRange ofTrack:([[asset tracksWithMediaType:AVMediaTypeVideo] count] > 0) ? [asset tracksWithMediaType:AVMediaTypeVideo][0] : nil atTime:kCMTimeZero error:nil];
    
    CMTime audioDuration = bgmAsset.duration;
    int audioDurationSeconds = ceil(audioDuration.value /audioDuration.timescale);
    NSLog(@"音频时长：%@, 时长：%@", @([YXToolMediaManager yxGetMediaTimeByPath:bgmUrl]), [NSString stringWithFormat:@"%@″", @(audioDurationSeconds)]);
    
    [bgmAudioTrack insertTimeRange:timeRange ofTrack:([[bgmAsset tracksWithMediaType:AVMediaTypeAudio] count] > 0) ? [bgmAsset tracksWithMediaType:AVMediaTypeAudio][0] : nil atTime:kCMTimeZero error:nil];
    
    [bgmOriginAudioInputParams setVolumeRampFromStartVolume:.5f toEndVolume:.5f timeRange:timeRange];
    
    if (boolMixing) {
        AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        AVMutableAudioMixInputParameters *originAudioInputParams = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioTrack];
        [originAudioInputParams setTrackID:audioTrack.trackID];
        
        [audioTrack insertTimeRange:timeRange ofTrack:[asset tracksWithMediaType:AVMediaTypeAudio][0] atTime:kCMTimeZero error:nil];
        [originAudioInputParams setVolumeRampFromStartVolume:1.0f toEndVolume:1.0f timeRange:timeRange];
        
        audioMix.inputParameters = @[bgmOriginAudioInputParams, originAudioInputParams];
    }
    else {
        audioMix.inputParameters = @[bgmOriginAudioInputParams];
    }
    
    [YXToolLocalSaveBySqlite yxRemoveFileByPath:mediaPath];
    AVAssetExportSession *exporterSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
    exporterSession.outputFileType = AVFileTypeMPEG4;
    exporterSession.outputURL = [NSURL fileURLWithPath:mediaPath]; //如果文件已存在，将造成导出失败
    exporterSession.shouldOptimizeForNetworkUse = YES; //用于互联网传输
    exporterSession.audioMix = audioMix;
    [exporterSession exportAsynchronouslyWithCompletionHandler:^{
        
        switch (exporterSession.status) {
            case AVAssetExportSessionStatusUnknown:
                NSLog(@"exporter Unknow");
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"exporter Canceled");
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog(@"exporter Failed == %@", exporterSession.error.localizedDescription);
                if (failBlock) {
                    failBlock(exporterSession.error.localizedDescription);
                }
                break;
            case AVAssetExportSessionStatusWaiting:
                NSLog(@"exporter Waiting");
                break;
            case AVAssetExportSessionStatusExporting:
                NSLog(@"exporter Exporting");
                break;
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"exporter Completed");
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (successBlock) {
                        successBlock([NSURL fileURLWithPath:mediaPath]);
                    }
                });
                break;
        }
    }];
}

#pragma mark - 合并图片
+ (UIImage *)yxComposeImgWithBgImgValue:(id)bgImgValue bgImgFrame:(CGRect)bgImgFrame topImgValue:(id)topImgValue topImgFrame:(CGRect)topImgFrame saveToFileWithName:(NSString *)saveToFileWithName boolByBgView:(BOOL)boolByBgView {
    
    //底图
    UIImage *bgImg = [[UIImage alloc] init];
    if ([bgImgValue isKindOfClass:[UIImage class]]) {
        bgImg = bgImgValue;
    }
    else {
        bgImg = [UIImage imageNamed:bgImgValue];
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGImageRef bgImgRef = bgImg.CGImage;
    CGFloat bgImgW = CGImageGetWidth(bgImgRef) > width ? width : CGImageGetWidth(bgImgRef);
    CGFloat bgImgH = CGImageGetWidth(bgImgRef) > width ? CGImageGetHeight(bgImgRef) *(width /CGImageGetWidth(bgImgRef)) : CGImageGetHeight(bgImgRef);
    
    //顶图
    UIImage *topImg = [[UIImage alloc] init];
    if ([topImgValue isKindOfClass:[UIImage class]]) {
        topImg = topImgValue;
    }
    else {
        topImg = [UIImage imageNamed:topImgValue];
    }
    CGImageRef topImgRef = topImg.CGImage;
    CGFloat topImgW = CGImageGetWidth(topImgRef) > width ? width : CGImageGetWidth(topImgRef);
    CGFloat topImgH = CGImageGetWidth(topImgRef) > width ? CGImageGetHeight(topImgRef) *(width /CGImageGetWidth(topImgRef)) : CGImageGetHeight(topImgRef);

    //设置底图最终坐标
    CGRect endBgFrame = bgImgFrame.size.width != 0 ? bgImgFrame : CGRectMake(0, 0, bgImgW, bgImgH);
    //设置顶图最终坐标
    CGRect endTopFrame = topImgFrame.size.width != 0 ? topImgFrame : CGRectMake(0, 0, topImgW, topImgH);
    
    //绘制上下文
    if (boolByBgView) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(endBgFrame.size.width, endBgFrame.size.height), YES, 0);
    }
    else {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(endTopFrame.size.width, endTopFrame.size.height), YES, 0);
    }
    
    //先把底图画到上下文中
    [bgImg drawInRect:endBgFrame];
    //把顶图放在上下文中
    [topImg drawInRect:endTopFrame];
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext(); //从当前上下文中获得最终图片
    UIGraphicsEndImageContext(); //关闭上下文
    
    if ([saveToFileWithName isKindOfClass:[NSString class]] && saveToFileWithName.length > 0) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@%@", path, saveToFileWithName, @".png"];
        [UIImagePNGRepresentation(resultImg) writeToFile:filePath atomically:YES]; //保存图片到沙盒
        //TODO 如果崩溃，则删除一下代码。
        CGImageRelease(bgImgRef);
        CGImageRelease(topImgRef);
    }
    
    return resultImg;
}

#pragma mark - 获取本地Bundle组成gif
+ (NSArray *)yxGetAnimationImagesByBundleName:(NSString *)bundleName {
    
    NSMutableArray<UIImage *>* imgArr = [NSMutableArray array]; //protocol限定这个数组只用来装UIImage*，如果装其他的就提示警告
    NSMutableArray *photoArr = [self yxGetGifPngPathByBundleName:bundleName];
    NSArray *result = [(NSArray *)photoArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        return [obj1 compare:obj2];
    }];
    for (int i = 0; i < result.count; i++) {
        NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.bundle/%@", bundleName, result[i]]];
        UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
        [imgArr addObject:img];
    }
    return imgArr;
}
+ (NSMutableArray *)yxGetGifPngPathByBundleName:(NSString *)bundleName {
    
    NSMutableArray *imgArr = [NSMutableArray new];
    NSString *path = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:path];
    
    while ((path = [enumerator nextObject]) != nil) {
        [imgArr addObject:path];
    }
    return imgArr;
}

@end
