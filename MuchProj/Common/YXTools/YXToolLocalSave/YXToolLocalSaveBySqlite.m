//
//  YXToolLocalSaveBySqlite.m
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/10.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXToolLocalSaveBySqlite.h"

#define kYXToolLocalSaveDocDirectoryPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

@interface YXToolLocalSaveBySqlite ()
{
    sqlite3 *db;
}

@end

static YXToolLocalSaveBySqlite *sqlites = nil;

@implementation YXToolLocalSaveBySqlite

+ (YXToolLocalSaveBySqlite *)instanceManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sqlites = [YXToolLocalSaveBySqlite new];
    });
    
    return sqlites;
}

#pragma mark - NSUserdefaults
#pragma mark - 开启数据持久化
+ (void)yxSaveUserDefaultsByValue:(id)value Key:(NSString *)key {
    
    NSUserDefaults *userDefaults = kYXToolSqliteUserDefaultHandle;
    [userDefaults setObject:value forKey:key];
}

#pragma mark - 读取数据持久化
+ (id)yxReadUserDefaultsByKey:(NSString *)key {
    
    NSUserDefaults *defaults = kYXToolSqliteUserDefaultHandle;
    
    return [defaults objectForKey:key];
}

#pragma mark - KeyChain
#pragma mark - 储存数据
+ (void)yxSaveKeychainsByValue:(id)saveValue dicKey:(NSString *)dicKey keychainKey:(NSString *)keychainKey {
    
    [YXToolLocalSaveByKeychain yxSaveKeychainBySaveValue:saveValue dicKey:dicKey keychainKey:keychainKey];
}

#pragma mark - 读取数据
+ (NSString *)yxReadKeychainsByKey:(NSString *)dicKey keychainKey:(NSString *)keychainKey {
    
    return [YXToolLocalSaveByKeychain yxReadKeychainByDicKey:dicKey keychainKey:keychainKey];
}

#pragma mark - 删除数据
+ (void)yxDeleteKeyChainsByKey:(NSString *)keychainKey {

    [YXToolLocalSaveByKeychain yxDeleteKeychainByKeychainKey:keychainKey];
}

#pragma mark - acrchive
#pragma mark - 归档
+ (void)yxSaveArchiveByDic:(NSDictionary *)dic key:(NSString *)key {
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", kYXToolLocalSaveDocDirectoryPath, key];
    [NSKeyedArchiver archiveRootObject:dic toFile:path];
}

#pragma mark - 解档
+ (id)yxUnarchiveByKey:(NSString *)key {
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", kYXToolLocalSaveDocDirectoryPath, key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:path]];
}

#pragma mark - 移除文件
+ (void)yxRemoveFileByPath:(NSString *)path {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

#pragma mark - plist
#pragma mark - 储存数据
+ (void)yxSavePlistByArr:(NSMutableArray *)mutableArr key:(NSString *)key path:(NSString *)path {
    
    //创建文件管理者
    NSFileManager *fileManager = kYXToolSqliteFileDefaultHandle;
    //文件在沙盒中的路径
    NSString *fileSandBoxPath = [kYXToolLocalSaveDocDirectoryPath stringByAppendingString:path];
    //文件在bundle中的路径
    NSString *fileBundlePath = [[NSBundle mainBundle] pathForAuxiliaryExecutable:path];
    
    //判断，沙盒中有就从沙盒中读取，沙盒中没有，就从bundle中读取
    NSMutableDictionary *dictionary = nil;
    if ([fileManager fileExistsAtPath:fileSandBoxPath]) {
        dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:fileSandBoxPath];
    }
    else {
        dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:fileBundlePath];
    }
    [dictionary setObject:mutableArr forKey:key];
    //存进沙盒中
    [dictionary writeToFile:fileSandBoxPath atomically:YES];
}

#pragma mark - 读取数据
+ (NSMutableArray *)yxReadPlistByKey:(NSString *)key path:(NSString *)path {
    
    //创建文件管理者
    NSFileManager *fileManager = kYXToolSqliteFileDefaultHandle;
    //文件在沙盒中的路径
    NSString *fileSandBoxPath = [kYXToolLocalSaveDocDirectoryPath stringByAppendingString:path];
    //文件在bundle中的路径
    NSString *fileBundlePath = [[NSBundle mainBundle] pathForAuxiliaryExecutable:path];
    
    //判断，沙盒中有就从沙盒中读取，沙盒中没有，就从bundle中读取
    NSMutableDictionary *dictionary = nil;
    if ([fileManager fileExistsAtPath:fileSandBoxPath]) {
        dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:fileSandBoxPath];
    }
    else {
        dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:fileBundlePath];
    }
    
    return [dictionary objectForKey:key];
}

#pragma mark - 删除数据
+ (void)yxRemovePlistByKey:(NSString *)key path:(NSString *)path {

    //创建文件管理者
    NSFileManager *fileManager = kYXToolSqliteFileDefaultHandle;
    //文件在沙盒中的路径
    NSString *fileSandBoxPath = [kYXToolLocalSaveDocDirectoryPath stringByAppendingString:path];
    //文件在bundle中的路径
    NSString *fileBundlePath = [[NSBundle mainBundle] pathForAuxiliaryExecutable:path];
    
    //判断，沙盒中有就从沙盒中读取，沙盒中没有，就从bundle中读取
    NSMutableDictionary *dictionary = nil;
    if ([fileManager fileExistsAtPath:fileSandBoxPath]) {
        dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:fileSandBoxPath];
    }
    else {
        dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:fileBundlePath];
    }
    [dictionary removeObjectForKey:key];
    //存进沙盒中
    [dictionary writeToFile:fileSandBoxPath atomically:YES];
}

#pragma mark - sqlite
#pragma mark - 创建或打开数据库
+ (void)yxCreateOrOpenSqliteDataBaseByDBName:(NSString *)DBName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *databasePath = [documents stringByAppendingPathComponent:DBName];

    if (sqlite3_open([databasePath UTF8String], &sqlites->db) != SQLITE_OK) {
        sqlite3_close(sqlites->db);
        NSLog(@"数据库打开失败！");
    }
}

#pragma mark - 创建数据表的语句
+ (void)yxCreateSqlTableByDataBase:(NSString *)dataBase {
    
//    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, address TEXT)";
    [sqlites execSql:dataBase];
}

#pragma mark - intsertSqlOperation（插入数据）
+ (void)yxInsertSqlOperationByDataBase:(NSString *)dataBase {
    
    //插入数据
//    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')", TABLENAME, NAME, AGE, ADDRESS, @"张三", @"23", @"东城区"];
    [sqlites execSql:dataBase];
}

#pragma mark - deleteSqlOperation（删除数据）
+ (void)yxDeleteSqlOperationByDataBase:(NSString *)dataBase {
    
//    NSString *deleteSql = [NSString stringWithFormat:@"%@", @"DELETE FROM PERSONINFO WHERE name ='中神通'"];
    [sqlites execSql:dataBase];
}

#pragma mark - updateSqlOperation（更新数据）
+ (void)yxUpdateSqlOperationByDataBase:(NSString *)dataBase {
    
//    NSString *updateSql = [NSString stringWithFormat:@"%@", @"UPDATE PERSONINFO SET name = '中神通' WHERE name = '张三'"];
    [sqlites execSql:dataBase];
}

#pragma mark - querySqlOperation（查询数据）
+ (void)yxQuerySqlOperationByDataBase:(NSString *)dataBase success:(void(^)(id result))success {
    
//    NSString *sqlQuery = [NSString stringWithFormat:@"%@", @"SELECT *FROM PERSONINFO"];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(sqlites->db, [dataBase UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *name = (char *)sqlite3_column_text(statement, 1);
            NSString *nsNameStr = [[NSString alloc] initWithUTF8String:name];
            NSDictionary *mutableDic = [[NSDictionary alloc] initWithObjectsAndKeys:nsNameStr, @"searchHistoryListSearchName", nil];

            if (success) {
                success(mutableDic);
            }
        }
    }
    sqlite3_close(sqlites->db);
}

#pragma mark - 创建数据表及数据操作
- (void)execSql:(NSString *)sql {
    
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库操作失败！");
    }
}

@end
