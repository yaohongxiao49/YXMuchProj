//
//  UIImage+YXCategory.h
//  YXCategaryGroupTest
//
//  Created by ios on 2020/4/8.
//  Copyright © 2020 August. All rights reserved.
//

#import <UIKit/UIKit.h>

#if TARGET_OS_IPHONE
#import <MobileCoreServices/MobileCoreServices.h>
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <CoreServices/CoreServices.h>
#import <WebKit/WebKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

/** 渐变色方向枚举 */
typedef NS_ENUM(NSUInteger, YXGradientDirectionType) {
    /** 上启 */
    YXGradientDirectionTypeTop,
    /** 下启 */
    YXGradientDirectionTypeBottom,
    /** 左启 */
    YXGradientDirectionTypeLeft,
    /** 右启 */
    YXGradientDirectionTypeRight,
};

@interface UIImage (YXCategory)

/**
 * 获取视频缩略图
 * @param videoUrl 视频地址
 * @param second 所需缩略图所在时间
 */
+ (UIImage *)yxGetVideoThumbnailWithVideoUrl:(NSString *)videoUrl
                                      second:(CGFloat)second;

/**
 * 根据时间、帧率获取视频帧图片集合
 * @param videoUrl 视频地址
 * @param second 指定开始时间
 * @param fps 帧率
 * @param durationSec 指定持续时间
 */
- (void)getVideoFrameImageWithUrl:(NSURL *)videoUrl
                           second:(CGFloat)second
                              fps:(float)fps
                      durationSec:(CGFloat)durationSec
                      finishBlock:(void(^)(NSMutableArray *arr))finishBlock;

/**
 * 图片合成gif
 * @param imagePathArray 图片数组
 * @param gifNamed gif名称
 * @param targetSize 根据尺寸压缩
 */
- (NSString *)yxSyntheticGifByImgArr:(NSMutableArray *)imagePathArray
                            gifNamed:(NSString *)gifNamed
                          targetSize:(CGSize)targetSize;

/**
 * 分割gif
 * @param url 地址
 */
- (NSMutableArray *)yxSegmentationGifByUrl:(NSURL *)url;

/** 获取启动图 */
+ (UIImage *)yxGetLaunchImage;

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
 * 按比例缩放/压缩图片
 * @param imgValue 图片
 * @param targetSize 尺寸
 */
+ (UIImage *)yxImgCompressForSizeImg:(id)imgValue
                          targetSize:(CGSize)targetSize;

/**
 * 根据颜色创建图片
 * @param colorArr 颜色集合
 * @param imgSize 尺寸
 * @param directionType 方向
 */
+ (UIImage *)yxCreateImgByColorArr:(NSArray *)colorArr
                           imgSize:(CGSize)imgSize
                     directionType:(YXGradientDirectionType)directionType;

/**
 * 设置渐变色
 * @param context 画布上下文
 * @param rect 尺寸
 * @param startColor 起始色值
 * @param endColor 结束色值
 * @param directionType 方向
 */
+ (void)yxDrawRadialGradient:(CGContextRef)context
                        rect:(CGRect)rect
                  startColor:(UIColor *)startColor
                    endColor:(UIColor *)endColor
               directionType:(YXGradientDirectionType)directionType;

/**
 * 人脸位置检测，并裁剪包含五官的人脸（一般使用boolAccurate == NO）
 * @param img 包含人脸的图片
 * @param boolOnlyDetectionFace 是否只检测人脸
 * @param pointSize 指定面容位置
 * @param boolOnlyOriginalFace 是否返回原人像大小
 * @param boolAccurate 是否使用精确面容定位
 */
+ (void)yxDetectingAndCuttingFaceByImg:(UIImage *)img
                 boolOnlyDetectionFace:(BOOL)boolOnlyDetectionFace
                             pointSize:(CGRect)pointSize
                  boolOnlyOriginalFace:(BOOL)boolOnlyOriginalFace
                          boolAccurate:(BOOL)boolAccurate
                              finished:(void(^)(BOOL success, UIImage *img))finished;


/**
 * 动态拉伸图片（默认所表示的方位数值为图片的数值）
 * @param imgName 图片名
 * @param tensileTop 顶部数值
 * @param tensileLeft 左部数值
 * @param tensileBottom 底部数值
 * @param tensileRight 右部数值
 */
+ (UIImage *)yxGetTensileImgByImgName:(NSString *)imgName
                           tensileTop:(NSString *__nullable)tensileTop
                          tensileLeft:(NSString *__nullable)tensileLeft
                        tensileBottom:(NSString *__nullable)tensileBottom
                         tensileRight:(NSString *__nullable)tensileRight;

/** 更改照片方向 */
- (UIImage *)fixOrientation:(UIImageOrientation)orientation;

/**
 * 使用CoreImage，分离图片并与指定背景图片合成一张图片（分离图片需要纯色背景，不含黑白灰）
 * @param segmentationImg 需要分离的图片
 * @param bgImg 背景图片
 */
+ (UIImage *)yxSegmentationAndCompositionImgBySegmentationImg:(UIImage *)segmentationImg
                                                           bgImg:(UIImage *)bgImg;

/**
 * 使用Quarz 2D，移除图片纯色背景（黑/白）
 * @param colorType YES/NO 黑/白
 * @param segmentationImg 图片
 */
+ (UIImage *)yxRemoveColorByColorType:(BOOL)colorType segmentationImg:(UIImage *)segmentationImg;

/**
 * 动态填充/更改图片颜色（如需要看到原图与更改后的差别，需在底部增加一个原图显示控件）
 * @param img 需要填充/更改图片
 * @param showSize 显示范围
 * @param color 填充/更改色值
 * @param fillWidth 填充范围
 */
- (UIImage *)yxFillImgColorByImg:(UIImage *)img
                        showSize:(CGSize)showSize
                         toColor:(UIColor *)color
                       fillWidth:(CGFloat)fillWidth;

/**
 *  将本地视频转换成Gif图
 *  @param videoUrl 本地视频的url
 *  @param frameCount 一共切多少张
 *  @param delayTime 每一张几秒钟显示
 *  @param loopCount 是否循环
 *  @param boolNeedCompression 是否需要压缩
 *  @param compressionWidth 压缩尺寸 宽
 *  @param compressionHight 压缩尺寸 高
 *  @param filleName 生成gif 的文件名
 *  @param completionBlock 成功回调 会返回 gif tmp文件下本地路径
 */
+ (void)yxCreateGifByUrl:(NSURL *)videoUrl
              frameCount:(int)frameCount
               delayTime:(float)delayTime
               loopCount:(int)loopCount
     boolNeedCompression:(BOOL)boolNeedCompression
        compressionWidth:(float)compressionWidth
        compressionHight:(float)compressionHight
               filleName:(NSString *)filleName
         completionBlock:(void(^)(NSString *gifPath))completionBlock;

/**
 * 缓存图片（存入沙盒）
 * @param name 缓存命名
 * @param img 图片
 */
+ (NSString *)yxCacheImgByName:(NSString *)name
                           img:(UIImage *)img;

/**
 * 全屏截图
 * @param view 基础视图
 * @param pointRect 指定截取范围（只有大小有作用）
 * @param finishedBlock 成功结果
 */
+ (void)yxScreenShotByView:(UIView *)view
                 pointRect:(CGRect)pointRect
             finishedBlock:(void(^)(UIImage *img))finishedBlock;

/** 内容截图 */
+ (void)yxScreenShotsByScrollView:(UIScrollView *)scrollView
                    finishedBlock:(void(^)(UIImage *img))finishedBlock;

@end

NS_ASSUME_NONNULL_END
