//
//  LLAPostScriptViewController.h
//  LLama
//
//  Created by tommin on 16/3/7.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LLACommonViewController.h"

#import "LLAPickImageItemInfo.h"

typedef NS_ENUM(NSInteger,LLAPublishScriptTypeNew){
    LLAPublishScriptTypeNew_Text,
    LLAPublishScriptTypeNew_Image,
} ;


@interface LLAPostScriptViewController : LLACommonViewController

@property(nonatomic , assign) LLAPublishScriptTypeNew scriptType;

@property(nonatomic, strong) LLAPickImageItemInfo *pickImgInfo;


@end
