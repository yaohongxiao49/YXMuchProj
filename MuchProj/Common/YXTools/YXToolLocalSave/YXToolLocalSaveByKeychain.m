//
//  YXToolLocalSaveByKeychain.m
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/10.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXToolLocalSaveByKeychain.h"

@implementation YXToolLocalSaveByKeychain

+ (void)yxSaveKeychainBySaveValue:(id)saveValue dicKey:(NSString *)dicKey keychainKey:(NSString *)keychainKey {
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [tempDic setObject:saveValue forKey:dicKey];
    [self save:keychainKey data:tempDic];
}

+ (NSString *)yxReadKeychainByDicKey:(NSString *)dicKey keychainKey:(NSString *)keychainKey {
    
    NSMutableDictionary *tempDic = (NSMutableDictionary *)[self load:keychainKey];
    
    return [tempDic objectForKey:dicKey];
}

+ (void)yxDeleteKeychainByKeychainKey:(NSString *)keychainKey {
    
    [self delete:keychainKey];
}

#pragma mark - keychain
#pragma mark - 储存数据
+ (void)save:(NSString *)service data:(id)data {
    
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (NSMutableDictionary *)getKeyChainQuery:(NSString *)service {
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:(id)kSecClassGenericPassword,(id)kSecClass, service, (id)kSecAttrService, service, (id)kSecAttrAccount, (id)kSecAttrAccessibleAfterFirstUnlock, (id)kSecAttrAccessible, nil];
}

+ (id)load:(NSString *)service {
    
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
            
        }
    }
    if (keyData) {
        CFRelease(keyData);
    }
    return ret;
}

+ (void)delete:(NSString *)service {
    
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

@end
