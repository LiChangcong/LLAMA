//
//  LLAImagePickerViewController.h
//  LLama
//
//  Created by Live on 16/1/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLACustomNavigationBarViewController.h"

typedef void(^callBackBlock)(id obj);

typedef NS_ENUM(NSInteger , PickerImgOrHeadStatus) {
    PickerImgOrHeadStatusImg = 0, 
    PickerImgOrHeadStatusHead ,
};

typedef NS_ENUM(NSInteger , PickerTimesStatus) {
    PickerTimesStatusOne = 0,
    PickerTimesStatusTwo ,
};

@interface LLAImagePickerViewController : LLACustomNavigationBarViewController

// 使用block传递图片
@property (nonatomic , copy) callBackBlock callBack;

@property (nonatomic , assign) PickerImgOrHeadStatus status;

@property (nonatomic , assign) PickerTimesStatus PickerTimesStatus;

@end
