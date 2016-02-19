//
//  TMPostScriptViewController.h
//  LLama
//
//  Created by tommin on 15/12/15.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LLACommonViewController.h"

@class LLAPickImageItemInfo;

typedef NS_ENUM(NSInteger,LLAPublishScriptType){
    LLAPublishScriptType_Text,
    LLAPublishScriptType_Image,
} ;

@interface TMPostScriptViewController : LLACommonViewController

@property(nonatomic , assign) LLAPublishScriptType scriptType;

@property(nonatomic, strong) LLAPickImageItemInfo *pickImgInfo;

@end
