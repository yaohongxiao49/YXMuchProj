//
//  YXNetworkRequest.m
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#import "YXNetworkRequest.h"
#import "YXSharedHTTPManager.h"

@implementation YXNetworkRequest

#pragma mark - GET请求
+ (void)getWithURL:(NSString *)url params:(id)params showText:(NSString *)text showSuccess:(BOOL)isShowSuccess showError:(BOOL)isShowError block:(YXRequestFinishBlock)block {
    
    if (text.length > 0) {
        [SVProgressHUD showWithStatus:text];
    }
    
    [self getRequest:url params:params forHTTPHeaderField:nil success:^(id responseObj) {
        
        if (text.length > 0) {
            [SVProgressHUD dismiss];
        }
        
        NSMutableDictionary *dic = responseObj;
        NSInteger code = [[dic yxObjForKey:@"code"] integerValue];
        NSString *msg = [dic yxObjForKey:@"msg"];
        if (code == kRequestSuccessCode) {
            if (isShowSuccess) {
                [SVProgressHUD showSuccessWithStatus:msg];
            }
            if (block) {
                block(dic, YES);
            }
        }
        else {
            if (isShowError) {
                [SVProgressHUD showErrorWithStatus:msg];
            }
            if (block) {
                block(dic, NO);
            }
        }
    } failure:^(NSError *error) {
        
        if (isShowError) {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }
        else {
            if (text.length > 0) {
                [SVProgressHUD dismiss];
            }
        }
        if (block) {
            block(nil, NO);
        }
    } netWork:^(id  _Nonnull networkObj) {
        
    }];
}

#pragma mark - POST请求
+ (void)postWithURL:(NSString *)url params:(id)params showText:(NSString *)text showSuccess:(BOOL)isShowSuccess showError:(BOOL)isShowError block:(YXRequestFinishBlock)block {
    
    if (text.length > 0) {
        [SVProgressHUD showWithStatus:text];
    }
    
    [self postRequest:url params:params forHTTPHeaderField:nil success:^(id responseObj) {
        
        if (text.length > 0) {
            [SVProgressHUD dismiss];
        }
        
        NSMutableDictionary *dic = responseObj;
        NSInteger code = [[dic yxObjForKey:@"code"] integerValue];
        NSString *msg = [dic yxObjForKey:@"msg"];
        if (code == kRequestSuccessCode) {
            if (isShowSuccess) {
                [SVProgressHUD showSuccessWithStatus:msg];
            }
            if (block) {
                block(dic, YES);
            }
        }
        else {
            if (isShowError) {
                [SVProgressHUD showErrorWithStatus:msg];
            }
            if (block) {
                block(dic, NO);
            }
        }
    } failure:^(NSError *error) {
        
        if (isShowError) {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }
        else {
            if (text.length > 0) {
                [SVProgressHUD dismiss];
            }
        }
        if (block) {
            block(nil, NO);
        }
    } netWork:^(id  _Nonnull networkObj) {
        
    }];
}

+ (void)getRequest:(NSString *)url params:(NSDictionary *)params forHTTPHeaderField:(id)headerField success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler netWork:(requestNetworkUseBlock)netWorkHandler {
    
    if (kServerDebug == 1) {
        NSLog(@"接口请求:%@ \n params:%@ \n headerField:%@", url, params, headerField);
    }
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%^{}\"[]|\\<> "].invertedSet];
    
    AFHTTPSessionManager *manager = [self httpSessionManagerWithHeaderField:headerField];
    
    [manager GET:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self parseErrorInfo:responseObject errorType:1 errorUrl:url successHandler:successHandler failureHandler:failureHandler];
    }
    failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self parseErrorInfo:error errorType:2 errorUrl:url successHandler:successHandler failureHandler:failureHandler];
    }];
}

+ (void)postRequest:(NSString *)url params:(NSDictionary *)params forHTTPHeaderField:(id)headerField success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler netWork:(requestNetworkUseBlock)netWorkHandler {
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%^{}\"[]|\\<> "].invertedSet];
    
    AFHTTPSessionManager *manager = [self httpSessionManagerWithHeaderField:headerField];
    [manager POST:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self parseErrorInfo:responseObject errorType:1 errorUrl:url successHandler:successHandler failureHandler:failureHandler];
    }
    failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self parseErrorInfo:error errorType:2 errorUrl:url successHandler:successHandler failureHandler:failureHandler];
    }];
}

#pragma mark - 单张上传图片请求
+ (void)uploadImagesUrl:(NSString *)url paramDic:(NSDictionary *)paramDic image:(UIImage *)image name:(NSString *)name forHTTPHeaderField:(id)headerField success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler netWork:(requestNetworkUseBlock)netWorkHandler {
    
    AFHTTPSessionManager *manager = [self httpSessionManagerWithHeaderField:headerField];
    
    [manager POST:url parameters:paramDic headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if (image) {
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [self createFileName]];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpg"];
        }
    }
    progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self parseErrorInfo:responseObject errorType:1 errorUrl:url successHandler:successHandler failureHandler:failureHandler];
    }
    failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self parseErrorInfo:error errorType:2 errorUrl:url successHandler:successHandler failureHandler:failureHandler];
    }];
}

#pragma mark - 多张上传图片请求
+ (void)uploadImages:(NSString *)url params:(NSDictionary *)params imageArr:(NSArray *)imageArr name:(NSString *)name forHTTPHeaderField:(id)headerField success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler netWork:(requestNetworkUseBlock)netWorkHandler {
    
    AFHTTPSessionManager *manager = [self httpSessionManagerWithHeaderField:headerField];
    
    [manager POST:url parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if (imageArr.count > 0) {
            for (UIImage *image in imageArr) {
                NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [self createFileName]];
                NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpg"];
            }
        }
    }
    progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self parseErrorInfo:responseObject errorType:1 errorUrl:url successHandler:successHandler failureHandler:failureHandler];
    }
    failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self parseErrorInfo:error errorType:2 errorUrl:url successHandler:successHandler failureHandler:failureHandler];
    }];
}

#pragma mark - 上传录音请求
+ (void)uploadMusicUrl:(NSString *)url paramDic:(NSDictionary *)paramDic file:(NSURL *)fileUrl name:(NSString *)name forHTTPHeaderField:(id)headerField success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler netWork:(requestNetworkUseBlock)netWorkHandler {
    
    AFHTTPSessionManager *manager = [self httpSessionManagerWithHeaderField:headerField];
    
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSString *fileName = [NSString stringWithFormat:@"%@.mp3", [self createFileName]];
        [formData appendPartWithFileURL:fileUrl name:name fileName:fileName mimeType:@"audio/mp3" error:nil];
    }
    progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self parseErrorInfo:responseObject errorType:1 errorUrl:url successHandler:successHandler failureHandler:failureHandler];
    }
    failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self parseErrorInfo:error errorType:2 errorUrl:url successHandler:successHandler failureHandler:failureHandler];
    }];
}

#pragma mark - 上传视频请求
+ (void)uploadVideoUrl:(NSString *)url paramDic:(NSDictionary *)paramDic file:(NSURL *)fileUrl name:(NSString *)name forHTTPHeaderField:(id)headerField success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler netWork:(requestNetworkUseBlock)netWorkHandler {
    
    AFHTTPSessionManager *manager = [self httpSessionManagerWithHeaderField:headerField];
    
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSString *fileName = [NSString stringWithFormat:@"%@.mp4", [self createFileName]];
        [formData appendPartWithFileURL:fileUrl name:name fileName:fileName mimeType:@"video/mp4" error:nil];
    }
    progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self parseErrorInfo:responseObject errorType:1 errorUrl:url successHandler:successHandler failureHandler:failureHandler];
    }
    failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self parseErrorInfo:error errorType:2 errorUrl:url successHandler:successHandler failureHandler:failureHandler];
    }];
}

#pragma mark - HTTP头字段
+ (AFHTTPSessionManager *)httpSessionManagerWithHeaderField:(id)headerField {
    
    AFHTTPSessionManager *manager = [YXSharedHTTPManager shareManager];
    [manager.requestSerializer setValue:headerField[@"platform-id"] forHTTPHeaderField:@"platform-id"];
    [manager.requestSerializer setValue:headerField[@"device-type"] forHTTPHeaderField:@"device-type"];
    [manager.requestSerializer setValue:headerField[@"device-name"] forHTTPHeaderField:@"device-name"];
    [manager.requestSerializer setValue:headerField[@"device-info"] forHTTPHeaderField:@"device-info"];
    [manager.requestSerializer setValue:headerField[@"version"] forHTTPHeaderField:@"version"];
    [manager.requestSerializer setValue:headerField[@"system-version"] forHTTPHeaderField:@"system-version"];
    [manager.requestSerializer setValue:headerField[@"nonce-str"] forHTTPHeaderField:@"nonce-str"];
    [manager.requestSerializer setValue:headerField[@"timestamp"] forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:headerField[@"user-token"] forHTTPHeaderField:@"user-token"];
    [manager.requestSerializer setValue:headerField[@"user-id"] forHTTPHeaderField:@"user-id"];
    [manager.requestSerializer setValue:headerField[@"area"] forHTTPHeaderField:@"area"];
    [manager.requestSerializer setValue:headerField[@"sign"] forHTTPHeaderField:@"sign"];
    
    return manager;
}

#pragma mark - 解析错误信息
/**
 *  解析错误信息封装处理
 *  @param errorInfo 错误的信息
 *  @param errorType 错误的类型: 1数据错误 2请求错误
 *  @param errorUrl 错误的Url
 *  @param successHandler 接口请求成功的回调
 *  @param failureHandler 接口请求失败的回调
 */
+ (void)parseErrorInfo:(id)errorInfo errorType:(NSInteger)errorType errorUrl:(NSString *)errorUrl successHandler:(requestSuccessBlock)successHandler failureHandler:(requestFailureBlock)failureHandler {
    
    if (errorType == 1) {
        if (![errorInfo isKindOfClass:[NSData class]]) {
            return;
        }
        
        id object = [NSJSONSerialization JSONObjectWithData:errorInfo options:NSJSONReadingMutableContainers error:nil];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:object];
        successHandler(dic);
    }
    else if (errorType == 2) {
        NSError *error = errorInfo;
        failureHandler(error);
    }
}

#pragma mark - 创建文件名称
+ (NSString *)createFileName {
    
    NSInteger currentTime = (NSInteger)([[NSDate date] timeIntervalSince1970] * 1000000);
    NSString *fileName = [NSString stringWithFormat:@"dx_%@_%@", @"", @(currentTime)];
    return fileName;
}

@end
