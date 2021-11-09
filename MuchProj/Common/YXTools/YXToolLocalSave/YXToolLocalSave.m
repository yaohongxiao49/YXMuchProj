//
//  YXToolLocalSave.m
//  YXCategoryGroupTest
//
//  Created by ios on 2020/4/10.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXToolLocalSave.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <Photos/Photos.h>

@implementation YXToolLocalSave

+ (void)yxSaveMediaByPath:(NSString *)path mediaType:(YXToolLocalSaveMediaType)mediaType successBlock:(void(^)(void))successBlock failBlock:(void(^)(id fail))failBlock {
    
    NSURL *videoUrl = [NSURL URLWithString:path];
    PHAssetResourceType resourceType = PHAssetResourceTypePhoto;
    switch (mediaType) {
        case YXToolLocalSaveMediaTypeImg:
            resourceType = PHAssetResourceTypePhoto;
            break;
        case YXToolLocalSaveMediaTypeVideo:
            resourceType = PHAssetResourceTypeVideo;
            break;
        case YXToolLocalSaveMediaTypeAudio:
            resourceType = PHAssetResourceTypeAudio;
            break;
        default:
            break;
    }
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{

        PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
        [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:resourceType fileURL:videoUrl options:options];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (success) {
            if (successBlock) {
                successBlock();
            }
        }
        else {
            if (failBlock) {
                failBlock(error.localizedDescription);
            }
        }
    }];
}

@end
