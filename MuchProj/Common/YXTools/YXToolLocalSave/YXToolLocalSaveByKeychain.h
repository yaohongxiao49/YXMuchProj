//
//  YXToolLocalSaveBykeychain.h
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/10.
//  Copyright © 2020 August. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXToolLocalSaveByKeychain : NSObject

/**
 * 储存字符串到keychain
 * @param saveValue 需要储存的数据
 * @param dicKey 数据Key
 * @param keychainKey keychain的key
 */
+ (void)yxSaveKeychainBySaveValue:(id)saveValue
                           dicKey:(NSString *)dicKey
                      keychainKey:(NSString *)keychainKey;

/**
 * 读取keychain
 * @param dicKey 数据Key
 * @param keychainKey keychain的key
 */
+ (NSString *)yxReadKeychainByDicKey:(NSString *)dicKey
                         keychainKey:(NSString *)keychainKey;

/**
 * 删除keychain
 * @param keychainKey keychain的key
 */
+ (void)yxDeleteKeychainByKeychainKey:(NSString *)keychainKey;

@end

NS_ASSUME_NONNULL_END
