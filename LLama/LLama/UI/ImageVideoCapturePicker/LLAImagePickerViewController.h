//
//  LLAImagePickerViewController.h
//  LLama
//
//  Created by Live on 16/1/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLACustomNavigationBarViewController.h"

typedef void(^callBackBlock)(id obj);


@interface LLAImagePickerViewController : LLACustomNavigationBarViewController

// 使用block传递图片
@property (nonatomic , copy) callBackBlock callBack;

@end
