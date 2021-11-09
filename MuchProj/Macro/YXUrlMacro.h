//
//  YXUrlMacro.h
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#ifndef YXUrlMacro_h
#define YXUrlMacro_h

/** 发布改为0，调试改为1 */
#define kServerDebug 1
/** Realm数据库版本控制，每升级一次版本加1 */
#define kRealmVersion 1

/** 服务器地址 */
#if kServerDebug
/** 测试 */
#define kHostUrl "http://ruli-app-myapi.meiawang.com/v6_0_2"
#define kHostUrlH5 "http://ruli-app-h5.meiawang.com/v6.0.2"
#else
/** 正式 */
#define kHostUrl "https://api-beauty.ruli.com/v6_0_1"
#define kHostUrlH5 "https://h5-beauty.ruli.com/v6.0.1"
#endif

#endif /* YXUrlMacro_h */
