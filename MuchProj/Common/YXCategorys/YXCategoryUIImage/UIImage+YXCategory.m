//
//  UIImage+YXCategory.m
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//
//TODO hue值网址 http://www.color-blindness.com/color-name-hue/

#import "UIImage+YXCategory.h"
#import <sys/utsname.h>
#import <AVFoundation/AVFoundation.h>

#define timeInterval @(600)
#define tolerance @(0.01)

typedef NS_ENUM(NSUInteger, GifSize) {
    GifSizeVeryLow = 2,
    GifSizeLow = 3,
    GifSizeMedium = 5,
    GifSizeHigh = 7,
    GifSizeOriginal = 10
};

@implementation UIImage (YXCategory)

void yxProviderReleaseData(void *info, const void *data, size_t size) {
    
    free((void *)data);
}
void yxRGBToHSV(float r, float g, float b, float *h, float *s, float *v) {
    
    float min, max, delta;
    min = MIN(r, MIN(g, b));
    max = MAX(r, MAX(g, b));
    *v = max; //v
    delta = max - min;
    if (max != 0) {
        *s = delta /max; //s
    }
    else {
        //r = g = b = 0 //s = 0, v is undefined
        *s = 0;
        *h = -1;
        return;
    }
    if (r == max) { //between yellow & magenta
        *h = (g - b) /delta;
    }
    else if (g == max) { //between cyan & yellow
        *h = 2 + (b - r) /delta;
    }
    else { //between magenta & cyan
        *h = 4 + (r - g) /delta;
    }
    
    *h *= 60; //degrees
    if (*h < 0) {
        *h += 360;
    }
}

#pragma mark - 获取视频缩略图
+ (UIImage *)yxGetVideoThumbnailWithVideoUrl:(NSString *)videoUrl second:(CGFloat)second {

    if (!videoUrl) {
        return nil;
    }
    NSURL *url;
    if ([videoUrl containsString:@"http"]) {
        url = [NSURL URLWithString:videoUrl];
    }
    else {
        url = [NSURL fileURLWithPath:videoUrl];
    }
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:audioAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    BOOL getThumbnail = YES;
    if (getThumbnail) { //缩略图大小
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

#pragma mark - 根据时间、帧率获取视频帧图片集合
- (void)getVideoFrameImageWithUrl:(NSURL *)videoUrl second:(CGFloat)second fps:(float)fps durationSec:(CGFloat)durationSec finishBlock:(void(^)(NSMutableArray *arr))finishBlock {
    
    if (!videoUrl) {
        return;
    }
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:videoUrl options:opts];
    //视频总时长
    Float64 cmtimeSecond = ceil(audioAsset.duration.value /audioAsset.duration.timescale);
    //判断指定开始时间大于视频总时长时，则从0开始
    Float64 begianSecond = second > cmtimeSecond ? 0 : (second *fps);
    //视频剩余时长（总时长大于指定开始时间，则使用总时长减指定开始时间之差，否则使用总时长）
    Float64 restTimeSecond = (cmtimeSecond - second) > 0 ? (cmtimeSecond - second) : cmtimeSecond;
    //计算后的持续时间（剩余时间大于指定持续时间，则使用指定持续时间，否则使用剩余时间）
    Float64 durationSeconds = restTimeSecond > durationSec ? durationSec : restTimeSecond;
  
    NSMutableArray *times = [NSMutableArray array];
    Float64 totalFrames = durationSeconds *fps; //获得视频持续帧数
    
    CMTime timeFrame;
    for (int i = 1; i <= totalFrames; i++) {
        timeFrame = CMTimeMake(i + begianSecond, fps); //第i帧 帧率
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [times addObject:timeValue];
    }
    
    NSInteger timesCount = [times count] + begianSecond;
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    
    //指定获取视频帧动画的图片
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:audioAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    [imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:
     ^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error) {
    
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                NSLog(@"Cancelled");
                break;
            case AVAssetImageGeneratorFailed:
                NSLog(@"Failed");
                break;
            case AVAssetImageGeneratorSucceeded: {
                UIImage *frameImg = [UIImage imageWithCGImage:image];
                [imgArr addObject:frameImg];
//                NSLog(@"requestedTime.value == %@", @(requestedTime.value));
                if (requestedTime.value == timesCount && finishBlock) {
                    finishBlock(imgArr);
                }
                break;
            }
            default:
                break;
        }
     }];
}

#pragma mark - 合成gif
- (NSString *)yxSyntheticGifByImgArr:(NSMutableArray *)imagePathArray gifNamed:(NSString *)gifNamed targetSize:(CGSize)targetSize {
    
    //创建储存路径
    NSString *savePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *gifPath = [NSString stringWithFormat:@"%@/%@.gif", savePath, gifNamed];
    NSLog(@"gifPath == %@", gifPath);
    
    //图像目标
    CGImageDestinationRef destination;
    CFURLRef url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)gifPath, kCFURLPOSIXPathStyle, false);
    //通过一个url返回图像目标
    destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, imagePathArray.count, NULL);
    
    //设置gif的信息，播放间隔时间、基本数据、delay时间
    NSDictionary *frameProperties = [NSDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0.1], (NSString *)kCGImagePropertyGIFDelayTime, nil]
                                     forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    //设置gif信息
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCGImagePropertyGIFHasGlobalColorMap];
    [dict setObject:(NSString *)kCGImagePropertyColorModelRGB forKey:(NSString *)kCGImagePropertyColorModel];
    [dict setObject:[NSNumber numberWithInt:16] forKey:(NSString*)kCGImagePropertyDepth]; //颜色深度
    [dict setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
    NSDictionary *gifproperty = [NSDictionary dictionaryWithObject:dict forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    //合成gif
    for (UIImage *img in imagePathArray) {
        UIImage *imgs = img;
        if (targetSize.width != 0) imgs = [UIImage yxImgCompressForSizeImg:img targetSize:targetSize];
        CGImageDestinationAddImage(destination, imgs.CGImage, (__bridge CFDictionaryRef)frameProperties);
    }

    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)gifproperty);
    CGImageDestinationFinalize(destination);
    
    CFRelease(destination);
    
    return gifPath;
}

#pragma mark - 分割gif
- (NSMutableArray *)yxSegmentationGifByUrl:(NSURL *)url {
    
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    size_t imgCount = CGImageSourceGetCount(gifSource);
    NSMutableArray *mutableArr = [[NSMutableArray alloc] init];
    for (size_t i = 0; i < imgCount; i++) {
        //获取源图片
        CGImageRef imgRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *img = [UIImage imageWithCGImage:imgRef];
        [mutableArr addObject:img];
        CGImageRelease(imgRef);
    }
    
    CFRelease(gifSource);
    
    return mutableArr;
}

#pragma mark - 获取启动图
+ (UIImage *)yxGetLaunchImage {

    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait"; //方向
    NSString *imgName = [[NSString alloc] init];
    NSArray *lauchImages = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in lauchImages) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(viewSize, imageSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            imgName = dict[@"UILaunchImageName"];
        }
    }
    
    return [UIImage imageNamed:imgName];
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

#pragma mark - 按比例缩放/压缩图片
+ (UIImage *)yxImgCompressForSizeImg:(id)imgValue targetSize:(CGSize)targetSize {
    
    UIImage *img = [[UIImage alloc] init];
    if ([imgValue isKindOfClass:[UIImage class]]) {
        img = imgValue;
    }
    else {
        img = [UIImage imageNamed:imgValue];
    }
    UIImage *newImg = nil;
    CGSize imgSize = img.size;
    CGFloat width = imgSize.width;
    CGFloat height = imgSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if (CGSizeEqualToSize(imgSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth /width;
        CGFloat heightFactor = targetHeight /height;

        scaleFactor = widthFactor > heightFactor ? widthFactor : heightFactor;
        scaledWidth = width *scaleFactor;
        scaledHeight = height *scaleFactor;

        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) *0.5;
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) *0.5;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(targetSize, YES, 0);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [img drawInRect:thumbnailRect];
    newImg = UIGraphicsGetImageFromCurrentImageContext();

    if (newImg == nil) {
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    
    return newImg;
}

#pragma mark - 根据颜色创建图片
+ (UIImage *)yxCreateImgByColorArr:(NSArray *)colorArr imgSize:(CGSize)imgSize directionType:(YXGradientDirectionType)directionType {
    
    CGRect rect = CGRectMake(0, 0, imgSize.width, imgSize.height);
    UIGraphicsBeginImageContext(imgSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (colorArr.count > 1) {
        [self yxDrawRadialGradient:context rect:rect startColor:[colorArr firstObject] endColor:[colorArr lastObject] directionType:directionType];
    }
    else {
        CGContextSetFillColorWithColor(context, [[colorArr lastObject] CGColor]);
        CGContextFillRect(context, rect);
    }
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark - 渐变色
+ (void)yxDrawRadialGradient:(CGContextRef)context rect:(CGRect)rect startColor:(UIColor *)startColor endColor:(UIColor *)endColor directionType:(YXGradientDirectionType)directionType {
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPathCloseSubpath(path);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};

    NSArray *colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
    switch (directionType) {
        case YXGradientDirectionTypeTop: {
            startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
            endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
            break;
        }
        case YXGradientDirectionTypeBottom: {
            startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
            endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
            break;
        }
        case YXGradientDirectionTypeLeft: {
            startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
            endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
            break;
        }
        case YXGradientDirectionTypeRight: {
            startPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
            endPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
            break;
        }
        default:
            break;
    }
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    CGPathRelease(path);
}

#pragma mark - 人脸位置检测，并裁剪包含五官的人脸
+ (void)yxDetectingAndCuttingFaceByImg:(UIImage *)img boolOnlyDetectionFace:(BOOL)boolOnlyDetectionFace pointSize:(CGRect)pointSize boolOnlyOriginalFace:(BOOL)boolOnlyOriginalFace boolAccurate:(BOOL)boolAccurate finished:(void(^)(BOOL success, UIImage *img))finished {
    
    if (img) {
        BOOL face = NO;
        CGRect faceBounds;
        CIImage *cgImg;
        CIContext *context = [CIContext contextWithOptions:nil];
        if (pointSize.size.width != 0 && boolOnlyDetectionFace != YES) {
            face = YES;
            faceBounds = pointSize;
        }
        else {
            cgImg = [[CIImage alloc] initWithImage:img];
            CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
            //检测到的人脸数组
            NSArray *faceArr = [faceDetector featuresInImage:cgImg];
            face = faceArr.count > 0;
            //检测到人脸时获取最后一次监测到的人脸
            CIFeature *faceFeature = [faceArr lastObject];
            faceBounds = faceFeature.bounds;
            if (boolOnlyDetectionFace) {
                finished(YES, nil);
                return;
            }
        }
        
        if (face) {
            //cgImage计算的尺寸是像素，需要与空间的尺寸做个计算
            if (!boolOnlyOriginalFace) {
                //下面几句是为了获取到额头部位做的处理，如果只需要定位到五官可直接取faceBounds的值
                //屏幕尺寸换算原图元素尺寸比例（以宽高比为3：4设置）
                CGFloat faceProportionWidth = faceBounds.size.width * 1.4;
                CGFloat faceProportionHeight = faceProportionWidth / 3 * 4;
                CGFloat faceOffsetX = faceBounds.origin.x - (faceProportionWidth / 6);
                CGFloat faceOffsetY = boolAccurate ? faceBounds.size.height - (faceBounds.origin.y - (faceProportionHeight / 4)) : faceBounds.origin.y - (faceProportionHeight / 8);
                faceBounds.origin.x = faceOffsetX;
                faceBounds.origin.y = faceOffsetY;
                faceBounds.size.width = faceProportionWidth;
                faceBounds.size.height = faceProportionHeight;
            }
            
            UIImage *resultImg;
            if (boolAccurate) { //这种裁剪方法在低头时和抬头时会截取不到完整的脸部，但是可以定位全脸位置更精确
                CGImageRef cgImage = CGImageCreateWithImageInRect(img.CGImage, faceBounds);
                resultImg = [UIImage imageWithCGImage:cgImage];
                CGImageRelease(cgImage);
            }
            else { //这种裁剪方法不会出现脸部裁剪不到的情况，但是会裁剪到脖子的位置
                CIImage *faceImg = [cgImg imageByCroppingToRect:faceBounds];
                resultImg = [UIImage imageWithCGImage:[context createCGImage:faceImg fromRect:faceImg.extent]];
            }
            
            finished(YES, resultImg);
        }
        else {
            finished(NO, nil);
        }
    }
    else {
        finished(NO, nil);
    }
}

#pragma mark - 动态拉伸图片
+ (UIImage *)yxGetTensileImgByImgName:(NSString *)imgName tensileTop:(NSString *)tensileTop tensileLeft:(NSString *)tensileLeft tensileBottom:(NSString *)tensileBottom tensileRight:(NSString *)tensileRight {
    
    UIImage *img;
    if ([imgName containsString:@"http"]) {
        img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgName]]];
    }
    else {
        img = [UIImage imageNamed:imgName];
    }
    //设置端盖的值
    CGFloat top = img.size.height;
    CGFloat left = img.size.width;
    CGFloat bottom = img.size.height;
    CGFloat right = img.size.width;
    if ([tensileTop isKindOfClass:[NSString class]] && tensileTop.length > 0) {
        top = [tensileTop floatValue];
    }
    if ([tensileLeft isKindOfClass:[NSString class]] && tensileLeft.length > 0) {
        left = [tensileLeft floatValue];
    }
    if ([tensileBottom isKindOfClass:[NSString class]] && tensileBottom.length > 0) {
        bottom = [tensileBottom floatValue];
    }
    if ([tensileRight isKindOfClass:[NSString class]] && tensileRight.length > 0) {
        right = [tensileRight floatValue];
    }
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
    UIImageResizingMode mode = UIImageResizingModeStretch;
    //拉伸图片
    UIImage *newImage = [img resizableImageWithCapInsets:edgeInsets resizingMode:mode];
    
    return newImage;
}

#pragma mark - 更改照片方向
- (UIImage *)fixOrientation:(UIImageOrientation)orientation {

    UIImageOrientation imgOrientation = orientation == UIImageOrientationUp ? self.imageOrientation : orientation;
    if (imgOrientation == UIImageOrientationUp) {
        return self;
    }
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (imgOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored: {
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        }
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored: {
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        }
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored: {
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        }
        default:
            break;
    }
    switch (imgOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored: {
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        }
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height, CGImageGetBitsPerComponent(self.CGImage), 0, CGImageGetColorSpace(self.CGImage), CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    
    switch(imgOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *endImg = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return endImg;
}

#pragma mark - 使用CoreImage，分离图片并与指定背景图片合成一张图片（分离图片需要纯色背景）
+ (UIImage *)yxSegmentationAndCompositionImgBySegmentationImg:(UIImage *)segmentationImg bgImg:(UIImage *)bgImg {
    
    CIFilter *colorCubeFilter = [CIFilter filterWithName:@"CIColorCube"];
    
    //Allocate memory
    const unsigned int size = 64;
    float *cubeData = (float *)malloc (size *size *size *sizeof(float) *4);
    [colorCubeFilter setValue:@(size) forKey:@"inputCubeDimension"];
    
    CIImage *myImg = [[CIImage alloc] initWithImage:segmentationImg];
    [colorCubeFilter setValue:myImg forKey:@"inputImage"];
    
    float rgb[3], hsv[3], *c = cubeData;
    //Populate cube with a simple gradient going from 0 to 1
    for (int z = 0; z < size; z++) {
        rgb[2] = ((double)z) /(size - 1); //Blue value
        for (int y = 0; y < size; y++) {
            rgb[1] = ((double)y) /(size - 1); //Green value
            for (int x = 0; x < size; x ++) {
                rgb[0] = ((double)x) /(size - 1); //Red value
                //Convert RGB to HSV
                //You can find publicly available rgbToHSV functions on the Internet
                yxRGBToHSV(rgb[0], rgb[1], rgb[2], &hsv[0], &hsv[1], &hsv[2]);
                //颜色判断
                float alpha = (hsv[0] >= 50 && hsv[0] <= 170) ? 0.0f : 1.0f; //绿色
                //饱和度
                if (hsv[1] < 0.2) {
                    alpha = 1.0f;
                }
                //亮度
                if (hsv[2] < 0.2) {
                    alpha = 1.0f;
                }

                //Calculate premultiplied alpha values for the cube
                c[0] = rgb[0] *alpha;
                c[1] = rgb[1] *alpha;
                c[2] = rgb[2] *alpha;
                c[3] = alpha;
                c += 4;
            }
        }
    }
    
    //Create memory with the cube data
    NSData *data = [NSData dataWithBytesNoCopy:cubeData length:size *size *size *sizeof(float) *4 freeWhenDone:YES];
    [colorCubeFilter setValue:data forKey:@"inputCubeData"];
    myImg = [colorCubeFilter outputImage];
    
    //组合
    CIImage *backgroundCIImg = [[CIImage alloc] initWithImage:bgImg];
    CIImage *resultImg = [[CIFilter filterWithName:@"CISourceOverCompositing" keysAndValues:kCIInputImageKey, myImg, kCIInputBackgroundImageKey, backgroundCIImg, nil] valueForKey:kCIOutputImageKey];

    return [[UIImage imageWithCIImage:resultImg] copy];
}

#pragma mark - 使用Quarz 2D，移除图片纯色背景（黑/白）
+ (UIImage *)yxRemoveColorByColorType:(BOOL)colorType segmentationImg:(UIImage *)segmentationImg {
    
    CGFloat imgWidth = segmentationImg.size.width;
    CGFloat imgHeight = segmentationImg.size.height;
    size_t bytesPerRow = imgWidth *4;
    uint32_t *rgbImageBuf = (uint32_t *)malloc(bytesPerRow *imgHeight);
    
    //创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); //色彩范围的容器
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imgWidth, imgHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imgWidth, imgHeight), segmentationImg.CGImage);
    
    //遍历像素
    int pixelNum = imgWidth *imgHeight;
    uint32_t *pCurPtr = rgbImageBuf;
    CGFloat minR = colorType ? 0 : 250;
    CGFloat maxR = colorType ? 15 : 255;
    CGFloat minG = colorType ? 0 : 240;
    CGFloat maxG = colorType ? 15 : 255;
    CGFloat minB = colorType ? 0 : 240;
    CGFloat maxB = colorType ? 15 : 255;
    for (int i = 0; i < pixelNum; i++, pCurPtr++) {
        uint8_t *ptr = (uint8_t *)pCurPtr;
        if (ptr[3] >= minR && ptr[3] <= maxR &&
            ptr[2] >= minG && ptr[2] <= maxG &&
            ptr[1] >= minB && ptr[1] <= maxB) {
            ptr[0] = 0;
        }
        else {
            printf("\n---->ptr0:%d ptr1:%d ptr2:%d ptr3:%d<----\n", ptr[0], ptr[1], ptr[2], ptr[3]);
        }
    }
    
    //将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow *imgHeight, nil);
    CGImageRef imageRef = CGImageCreate(imgWidth, imgHeight, 8, 32, bytesPerRow, colorSpace, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    UIImage *resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    //释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return resultUIImage;
}

#pragma mark - 动态填充图片色值
- (UIImage *)yxFillImgColorByImg:(UIImage *)img showSize:(CGSize)showSize toColor:(UIColor *)color fillWidth:(CGFloat)fillWidth {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(showSize.width, img.size.height), NO, img.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, img.size.height);

    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, showSize.width, img.size.height);

    CGContextClipToMask(context, rect, img.CGImage);
    [color setFill];
    
    CGContextFillRect(context, CGRectMake(0, 0, fillWidth, rect.size.height));
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return colorImage;
}

#pragma mark - 视频转为gif
+ (void)yxCreateGifByUrl:(NSURL *)videoUrl frameCount:(int)frameCount delayTime:(float)delayTime loopCount:(int)loopCount boolNeedCompression:(BOOL)boolNeedCompression compressionWidth:(float)compressionWidth compressionHight:(float)compressionHight filleName:(NSString *)filleName completionBlock:(void(^)(NSString *gifPath))completionBlock {
    
    NSDictionary *fileProperties = [self filePropertiesWithLoopCount:loopCount];
    NSDictionary *frameProperties = [self framePropertiesWithDelayTime:delayTime];
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoUrl];
    
    float videoLength = (float)asset.duration.value /asset.duration.timescale;
    float increment = (float)videoLength /frameCount;
    
    NSMutableArray *timePoints = [NSMutableArray array];
    for (int currentFrame = 0; currentFrame<frameCount; ++currentFrame) {
        float seconds = (float)increment * currentFrame;
        CMTime time = CMTimeMakeWithSeconds(seconds, [timeInterval intValue]);
        [timePoints addObject:[NSValue valueWithCMTime:time]];
    }
    
    dispatch_group_t gifQueue = dispatch_group_create();
    dispatch_group_enter(gifQueue);
    
    __block NSString *gifPath;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        gifPath = [weakSelf createGifByTimePoints:timePoints url:videoUrl fileProperties:fileProperties frameProperties:frameProperties frameCount:frameCount gifSize:GifSizeMedium boolNeedCompression:boolNeedCompression compressionWidth:compressionWidth compressionHight:compressionHight filleName:filleName];
        
        dispatch_group_leave(gifQueue);
    });
    
    dispatch_group_notify(gifQueue, dispatch_get_main_queue(), ^{
        //Return GIF URL
        completionBlock(gifPath);
    });
}

#pragma mark - 图片缓存
+ (NSString *)yxCacheImgByName:(NSString *)name img:(UIImage *)img {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dirPath = [NSString stringWithFormat:@"%@/%@/%@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject], @"circleCache", @""];
    
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    if (!(isDir && existed)) {
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *imgPath = [[NSURL fileURLWithPath:[dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.png", name]]] path];
    
    @autoreleasepool {
        NSData *data = UIImageJPEGRepresentation(img, 0.5);
        [data writeToFile:imgPath atomically:YES];
    }
    
    return imgPath;
}

#pragma mark - 全屏截图
+ (void)yxScreenShotByView:(UIView *)view pointRect:(CGRect)pointRect finishedBlock:(void(^)(UIImage *img))finishedBlock {
    
    CGRect rect = view.frame;
    if (pointRect.size.width != 0) rect = pointRect;
    
    //开启图片上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    //获取截图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图片上下文
    UIGraphicsEndImageContext();
    //保存相册
    UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
    if (finishedBlock) {
        finishedBlock(image);
    }
}

#pragma mark - 内容截图
+ (void)yxScreenShotsByScrollView:(UIScrollView *)scrollView finishedBlock:(void(^)(UIImage *img))finishedBlock {
    
    UIScrollView *shadowView = scrollView;
    //开启图片上下文
    UIGraphicsBeginImageContextWithOptions(shadowView.contentSize, NO, 0.f);
    //保存现在视图的位置偏移信息
    CGPoint saveContentOffset = shadowView.contentOffset;
    //保存现在视图的frame信息
    CGRect saveFrame = shadowView.frame;
    //把要截图的视图偏移量设置为0
    shadowView.contentOffset = CGPointZero;
    //设置要截图的视图的frame为内容尺寸大小
    shadowView.frame = CGRectMake(0, 0, shadowView.contentSize.width, shadowView.contentSize.height);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [scrollView.layer renderInContext:ctx];
//    [shadowView drawViewHierarchyInRect:shadowView.frame afterScreenUpdates:YES];
    //获取截图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图片上下文
    UIGraphicsEndImageContext();
    //将视图的偏移量设置回原来的状态
    shadowView.contentOffset = saveContentOffset;
    //将视图的frame信息设置回原来的状态
    shadowView.frame = saveFrame;
    //保存相册
    UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
    if (finishedBlock) {
        finishedBlock(image);
    }
}

#pragma mark - 创建gif
+ (NSString *)createGifByTimePoints:(NSArray *)timePoints url:(NSURL *)url fileProperties:(NSDictionary *)fileProperties frameProperties:(NSDictionary *)frameProperties frameCount:(int)frameCount gifSize:(GifSize)gifSize boolNeedCompression:(BOOL)boolNeedCompression compressionWidth:(float)compressionWidth compressionHight:(float)compressionHight filleName:(NSString *)filleName {
    
    NSString *temporaryFile = [NSTemporaryDirectory() stringByAppendingString:filleName];
    NSURL *fileURL = [NSURL fileURLWithPath:temporaryFile];
    if (fileURL == nil) {
        return nil;
    }
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF , frameCount, NULL);

    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    
    CMTime tol = CMTimeMakeWithSeconds([tolerance floatValue], [timeInterval intValue]);
    generator.requestedTimeToleranceBefore = tol;
    generator.requestedTimeToleranceAfter = tol;
    
    NSError *error = nil;
    CGImageRef previousImageRefCopy = nil;
    for (NSValue *time in timePoints) {
        CGImageRef imageRef;
        
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
        imageRef = (float)gifSize/10 != 1 ? createImageWithScale([generator copyCGImageAtTime:[time CMTimeValue] actualTime:nil error:&error], (float)gifSize/10) : [generator copyCGImageAtTime:[time CMTimeValue] actualTime:nil error:&error];
#elif TARGET_OS_MAC
        imageRef = [generator copyCGImageAtTime:[time CMTimeValue] actualTime:nil error:&error];
#endif
        
        if (error) {
            NSLog(@"Error copying image: %@", error);
        }
        if (imageRef) {
            CGImageRelease(previousImageRefCopy);
            previousImageRefCopy = CGImageCreateCopy(imageRef);
        }
        else if (previousImageRefCopy) {
            imageRef = CGImageCreateCopy(previousImageRefCopy);
        }
        else {
            NSLog(@"Error copying image and no previous frames to duplicate");
            return nil;
        }
        if (boolNeedCompression) {
            UIImage *img = [UIImage imageWithCGImage:imageRef];
            
            CGSize targetSize = CGSizeMake(compressionWidth, compressionHight);
            UIImage *sourceImage = img;
            UIImage *newImage = nil;
            CGSize imageSize = sourceImage.size;
            CGFloat width = imageSize.width;
            CGFloat height = imageSize.height;
            CGFloat targetWidth = targetSize.width;
            CGFloat targetHeight = targetSize.height;
            CGFloat scaleFactor = 0.0;
            CGFloat scaledWidth = targetWidth;
            CGFloat scaledHeight = targetHeight;
            CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
            
            if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
                
                CGFloat widthFactor = targetWidth /width;
                CGFloat heightFactor = targetHeight /height;
                
                if (widthFactor > heightFactor) {
                    scaleFactor = widthFactor; //scale to fit height
                }
                else {
                    scaleFactor = heightFactor; //scale to fit width
                }
                scaledWidth = width *scaleFactor;
                scaledHeight = height *scaleFactor;
                
                //center the image
                if (widthFactor > heightFactor) {
                    thumbnailPoint.y = (targetHeight - scaledHeight) *0.5;
                }
                else if (widthFactor < heightFactor) {
                    thumbnailPoint.x = (targetWidth - scaledWidth) *0.5;
                }
            }
            
            UIGraphicsBeginImageContext(targetSize); //this will crop
            
            CGRect thumbnailRect = CGRectZero;
            thumbnailRect.origin = thumbnailPoint;
            thumbnailRect.size.width= scaledWidth;
            thumbnailRect.size.height = scaledHeight;
            [sourceImage drawInRect:thumbnailRect];
            
            newImage = UIGraphicsGetImageFromCurrentImageContext();
            if(newImage == nil) {
                NSLog(@"could not scale image");
            }
                
            //pop the context to get back to the default
            UIGraphicsEndImageContext();
            
            CGImageRef imageRef1 = newImage.CGImage;
            NSLog(@"开始add，%@", time);
            CGImageDestinationAddImage(destination, imageRef1, (CFDictionaryRef)frameProperties);
            NSLog(@"当此add完成，%@", time);
        }
        else {
            CGImageDestinationAddImage(destination, imageRef, (CFDictionaryRef)frameProperties);
        }
        
        CGImageRelease(imageRef);
    }
    CGImageRelease(previousImageRefCopy);
    NSLog(@"取出imageRef完成");
    CGImageDestinationSetProperties(destination, (CFDictionaryRef)fileProperties);
    //Finalize the GIF
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"Failed to finalize GIF destination: %@", error);
        if (destination != nil) {
            CFRelease(destination);
        }
        return nil;
    }
    CFRelease(destination);
    
    return temporaryFile;
}

#pragma mark - Helpers
CGImageRef createImageWithScale(CGImageRef imageRef, float scale) {
    
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    CGSize newSize = CGSizeMake(CGImageGetWidth(imageRef) *scale, CGImageGetHeight(imageRef) *scale);
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        return nil;
    }
    
    //Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    //Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    //Release old image
    CFRelease(imageRef);
    //Get the resized image from the context and a UIImage
    imageRef = CGBitmapContextCreateImage(context);
    
    UIGraphicsEndImageContext();
#endif
    return imageRef;
}

#pragma mark - Properties
+ (NSDictionary *)filePropertiesWithLoopCount:(int)loopCount {
    
    return @{(NSString *)kCGImagePropertyGIFDictionary:@{(NSString *)kCGImagePropertyGIFLoopCount:@(loopCount)}};
}
+ (NSDictionary *)framePropertiesWithDelayTime:(float)delayTime {
    
    return @{(NSString *)kCGImagePropertyGIFDictionary:@{(NSString *)kCGImagePropertyGIFDelayTime: @(delayTime)}, (NSString *)kCGImagePropertyColorModel:(NSString *)kCGImagePropertyColorModelRGB};
}

@end
