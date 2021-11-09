//
//  YXColorMacro.h
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#ifndef YXColorMacro_h
#define YXColorMacro_h

#pragma mark - 色值
/** 主题色 */
#define kYXThemeColor [UIColor yxColorByHexString:@"#000000" alpha:1]
/** 普通标题色 */
#define kYXTitleNormalColor [UIColor yxColorByHexString:@"#000000" alpha:1]
/** 选中标题色 */
#define kYXTitleSelectedColor [UIColor yxColorByHexString:@"#333333" alpha:1]
/** 分割线颜色 */
#define kYXDividerLineColor [UIColor yxColorByHexString:@"#F5F5F5" alpha:1]

#pragma mark - 字体
/** 正常字体 */
#define kYXFontSystem(font) [UIFont systemFontOfSize:font]
/** 加粗字体 */
#define kYXFontBold(font) [UIFont boldSystemFontOfSize:font]

#pragma mark - 图片
#define kYXImage(imageName) [UIImage imageNamed:imageName]

#endif /* YXColorMacro_h */
