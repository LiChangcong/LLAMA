//
//  LLAPickImageManager.m
//  LLama
//
//  Created by Live on 16/2/22.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAPickImageManager.h"



@interface LLAPickImageManager()
{
    //PHCachingImageManager *cachingImageManager;
}

@end

@implementation LLAPickImageManager

+ (instancetype) shareManager {
    
    static LLAPickImageManager *shareManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareManager = [[[self class] alloc] init];
    });
    
    return shareManager;
}

- (instancetype) init {
    
    self = [super init];
    if (self) {
        //cachingImageManager = [[PHCachingImageManager alloc] init];
    }
    
    return self;
}

#pragma mark - 

- (void) photoFromAsset:(id)asset completion:(void (^)(UIImage * resultImage, NSDictionary * info, BOOL isDegraded))completion {
    
    if ([asset isKindOfClass:[PHAsset class]]) {

        PHAsset *pAsset = (PHAsset *) asset;
        
//        [[PHImageManager defaultManager] requestImageDataForAsset:pAsset options:nil     resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//            
//            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
//            
//            if (downloadFinined && imageData) {
//                if (completion) completion([UIImage imageWithData:imageData],info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
//            }
//            
//            //image from iCloud
//            
//            if ([info objectForKey:PHImageResultIsInCloudKey] && !imageData) {
//                PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
//                option.networkAccessAllowed = YES;
//                [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {\
//                    UIImage *resultImage = [UIImage imageWithData:imageData scale:1.0];
//                    if (resultImage) {
//                        if (completion) completion(resultImage,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
//                    }
//                }];
//
//            }
//            
//        }];
        
        CGFloat aspectRatio = pAsset.pixelWidth / (CGFloat)pAsset.pixelHeight;
        CGFloat multiple = [UIScreen mainScreen].scale;
        CGFloat pixelWidth = [UIScreen mainScreen].bounds.size.width * multiple;
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined && result) {
                if (completion) completion(result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            }
            
            // Download image from iCloud / 从iCloud下载图片
            if ([info objectForKey:PHImageResultIsInCloudKey] && !result) {
                PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
                option.networkAccessAllowed = YES;
                [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
                
                    if (resultImage) {
                        if (completion) completion(resultImage,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                    }
                }];
            }
        }];
        
        
    }else if ([asset isKindOfClass:[ALAsset class]]) {
        
        ALAsset *aAsset = (ALAsset *) asset;
        
        UIImage *image = [UIImage imageWithCGImage:aAsset.aspectRatioThumbnail];
        
        
        if (completion)
            completion(image,nil,YES);
    }else {
    
        if (completion)
            completion(nil,nil,NO);
    }
}

//
- (void) photoFromAsset:(id) asset picWidth:(CGFloat) width completion:(void (^)(UIImage *resultImage,NSDictionary *info,BOOL isDegraded)) completion {
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        
        PHAsset *pAsset = (PHAsset *) asset;
        
        CGFloat aspectRatio = pAsset.pixelWidth / (CGFloat)pAsset.pixelHeight;
        CGFloat multiple = [UIScreen mainScreen].scale;
        CGFloat pixelWidth = width * multiple;
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined && result) {
                if (completion) completion(result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            }
            
            // Download image from iCloud / 从iCloud下载图片
            if ([info objectForKey:PHImageResultIsInCloudKey] && !result) {
                PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
                option.networkAccessAllowed = YES;
                [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
                    
                    if (resultImage) {
                        if (completion) completion(resultImage,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                    }
                }];
            }
        }];
        
        
    }else if ([asset isKindOfClass:[ALAsset class]]) {
        
        ALAsset *aAsset = (ALAsset *) asset;
        
        UIImage *image = [UIImage imageWithCGImage:aAsset.aspectRatioThumbnail];
        
        
        if (completion)
            completion(image,nil,YES);
    }else {
        
        if (completion)
            completion(nil,nil,NO);
    }

    
}

- (void) avAssetFromaAsset:(id)asset completion:(void (^)(AVAsset *, NSDictionary *))completion {
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *pAsset = (PHAsset *) asset;
        
        PHImageManager *imageManager = [PHImageManager defaultManager];
        
        [imageManager requestAVAssetForVideo:asset options:PHVideoRequestOptionsDeliveryModeAutomatic resultHandler:^(AVAsset * _Nullable avAsset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion)
                    completion(avAsset,info);
            });
            
            
        }];
        
        
    }else if ([asset isKindOfClass:[ALAsset class]]) {
        if (completion) {
            AVAsset *as = [AVAsset assetWithURL:[asset valueForProperty:ALAssetPropertyAssetURL]];
            completion(as,nil);
        }
    }else {
        if (completion)
            completion(nil,nil);
    }
}

@end
