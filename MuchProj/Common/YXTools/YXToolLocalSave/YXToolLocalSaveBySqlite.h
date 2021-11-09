//
//  YXToolLocalSaveBySqlite.h
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/10.
//  Copyright © 2020 August. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "YXToolLocalSaveByKeychain.h"

#define kYXToolSqliteFileDefaultHandle [NSFileManager defaultManager]
#define kYXToolSqliteUserDefaultHandle [NSUserDefaults standardUserDefaults]

NS_ASSUME_NONNULL_BEGIN

@interface YXToolLocalSaveBySqlite : NSObject

+ (instancetype)instanceManager;

/**
 * 开启数据持久化（NSUserdefaults）
 * @param value 储存的内容
 * @param key 字典中的键值对
 */
+ (void)yxSaveUserDefaultsByValue:(id)value
                              Key:(NSString *)key;

/**
 * 读取数据持久化（NSUserdefaults）
 * @param key 字典中的键值对
 */
+ (id)yxReadUserDefaultsByKey:(NSString *)key;

/**
 * 储存字符串到keychain（keychain）
 * @param saveValue 需要储存的数据
 * @param dicKey 数据Key
 * @param keychainKey keychain的key
 */
+ (void)yxSaveKeychainsByValue:(id)saveValue
                        dicKey:(NSString *)dicKey
                   keychainKey:(NSString *)keychainKey;

/**
 * 读取keychain（keychain）
 * dictionaryKey 数据Key
 * keychainKey keychain的key
 */
+ (NSString *)yxReadKeychainsByKey:(NSString *)dicKey
                       keychainKey:(NSString *)keychainKey;

/**
 * 删除keychain（keychain）
 * @param keychainKey keychain的key
 */
+ (void)yxDeleteKeyChainsByKey:(NSString *)keychainKey;

/**
 * 储存数据（归档）
 * @param dic 储存的内容
 * @param key 命名
 */
+ (void)yxSaveArchiveByDic:(NSDictionary *)dic
                       key:(NSString *)key;

/**
 * 解档
 * @param key 命名
 */
+ (id)yxUnarchiveByKey:(NSString *)key;

/**
 * 移除文件
 * @param path 地址
 */
+ (void)yxRemoveFileByPath:(NSString *)path;


/**
 * 储存数据（plist）
 * @param mutableArr 储存的数据
 * @param key 字典的键值对
 * @param path 储存的地址
 */
+ (void)yxSavePlistByArr:(NSMutableArray *)mutableArr
                     key:(NSString *)key
                    path:(NSString *)path;

/**
 * 读取数据（plist）
 * @param key 字典的键值对
 * @param path 读取的地址
 */
+ (NSMutableArray *)yxReadPlistByKey:(NSString *)key
                                path:(NSString *)path;

/**
 * 删除数据（plist）
 * @param key 字典中的键值对
 * @param path 删除的地址
 */
+ (void)yxRemovePlistByKey:(NSString *)key
                      path:(NSString *)path;


#pragma mark - sqlite数据库
/**
 * 创建或打开数据库
 * @param DBName 数据库名
 */
+ (void)yxCreateOrOpenSqliteDataBaseByDBName:(NSString *)DBName;

/**
 * 创建数据表的语句
 * @param dataBase 数据库操作语句
 */
+ (void)yxCreateSqlTableByDataBase:(NSString *)dataBase;

/**
 * 插入数据
 * @param dataBase 数据库操作语句
 */
+ (void)yxInsertSqlOperationByDataBase:(NSString *)dataBase;

/**
 * 删除数据
 * @param dataBase 数据库操作语句
 */
+ (void)yxDeleteSqlOperationByDataBase:(NSString *)dataBase;

/**
 * 更新修改数据
 * @param dataBase 数据库操作语句
 */
+ (void)yxUpdateSqlOperationByDataBase:(NSString *)dataBase;

/**
 * 查询数据
 * @param dataBase 数据库操作语句
 * @param success 结果回调
 */
+ (void)yxQuerySqlOperationByDataBase:(NSString *)dataBase
                              success:(void(^)(id result))success;

@end

NS_ASSUME_NONNULL_END
