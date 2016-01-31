//
//  PickerDatas.m
//  相册Demo
//
//  Created by 张磊 on 14-11-11.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import "ZLPhotoPickerDatas.h"
#import "ZLPhotoPickerGroup.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ZLPhotoPickerDatas ()
@property (nonatomic , strong) ALAssetsLibrary *library;

@end

@implementation ZLPhotoPickerDatas

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,^
                  {
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}

- (ALAssetsLibrary *)library
{
    if (nil == _library)
    {
        _library = [self.class defaultAssetsLibrary];
    }
    
    return _library;
}

#pragma mark - getter
+ (instancetype) defaultPicker{
    return [[self alloc] init];
}

#pragma mark -获取所有组
/**
 * 获取所有组对应的图片
 */

- (void) getAllGroupWithPhotos : (callBackBlock ) callBack{
    [self getAllGroupAllPhotos:YES withResource:callBack];
}

/**
 * 获取所有组对应的视频
 */
- (void) getAllGroupWithVideos:(callBackBlock)callBack {
    [self getAllGroupAllPhotos:NO withResource:callBack];
}

/**
 * 获取所有组对应的图片与视频
 */
- (void) getAllGroupWithPhotosAndVideos : (callBackBlock ) callBack{
    NSMutableArray *groups = [NSMutableArray array];
    
    [self.library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            // 包装一个模型来赋值
            ZLPhotoPickerGroup *pickerGroup = [[ZLPhotoPickerGroup alloc] init];
            pickerGroup.group = group;
            pickerGroup.groupName = [group valueForProperty:@"ALAssetsGroupPropertyName"];
            pickerGroup.thumbImage = [UIImage imageWithCGImage:[group posterImage]];
            pickerGroup.assetsCount = [group numberOfAssets];
            [groups addObject:pickerGroup];
        }else{
            callBack(groups);
        }

    } failureBlock:nil];
}

/**
 * 获取所有组对应的图片或者视频
 */
- (void) getAllGroupAllPhotos:(BOOL)allPhotos withResource : (callBackBlock ) callBack{
    NSMutableArray *groups = [NSMutableArray array];
    
    [self.library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            
            // 包装一个模型来赋值
            ZLPhotoPickerGroup *pickerGroup = [[ZLPhotoPickerGroup alloc] init];
            if (allPhotos){
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            }else{
                pickerGroup.isVideo = YES;
                [group setAssetsFilter:[ALAssetsFilter allVideos]];
            }
            pickerGroup.group = group;
            pickerGroup.groupName = [group valueForProperty:@"ALAssetsGroupPropertyName"];
            pickerGroup.thumbImage = [UIImage imageWithCGImage:[group posterImage]];
            pickerGroup.assetsCount = [group numberOfAssets];
            [groups addObject:pickerGroup];
        }else{
            callBack(groups);
        }

    } failureBlock:nil];
}


#pragma mark -传入一个组获取组里面的Asset
- (void) getGroupPhotosWithGroup : (ZLPhotoPickerGroup *) pickerGroup finished : (callBackBlock ) callBack{
    
    NSMutableArray *assets = [NSMutableArray array];
    
    [pickerGroup.group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [assets addObject:result];
        }else{
            callBack(assets);
        }

    }];
    
}

#pragma mark -传入一个AssetsURL来获取UIImage
- (void) getAssetsPhotoWithURLs:(NSURL *) url callBack:(callBackBlock ) callBack{
    [self.library assetForURL:url resultBlock:^(ALAsset *asset) {
        dispatch_async(dispatch_get_main_queue(), ^{
            callBack([UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]);
        });
    } failureBlock:nil];
}

@end
