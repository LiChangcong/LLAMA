//
//  TMAlbumPickerViewController.h
//  photoPickerDemo
//
//  Created by tommin on 16/1/29.
//  Copyright © 2016年 tommin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLPhotoPickerGroup.h"


typedef void(^callBackBlock)(id obj);
typedef void(^callBackBlock1)(id obj);


typedef NS_ENUM(NSInteger , PickerViewShowStatus) {
    PickerViewShowStatusGroup = 0, // default groups .
    PickerViewShowStatusCameraRoll ,
    PickerViewShowStatusSavePhotos ,
    PickerViewShowStatusPhotoStream ,
    PickerViewShowStatusVideo,
};


@interface TMAlbumPickerViewController : UIViewController

// scrollView滚动的升序降序
//@property (nonatomic , assign) ZLPickerCollectionViewShowOrderStatus status;
// delegate
//@property (nonatomic , weak) id <ZLPhotoPickerCollectionViewDelegate> collectionViewDelegate;
// 限制最大数
@property (nonatomic , assign) NSInteger maxCount;
// 置顶展示图片
@property (assign,nonatomic) BOOL topShowPhotoPicker;

@property (nonatomic , assign) PickerViewShowStatus status;


@property (nonatomic , copy) callBackBlock callBack;

@property (nonatomic , copy) callBackBlock1 callBack1;


@end
