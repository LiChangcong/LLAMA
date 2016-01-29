//
//  LLAPayUserPayTypeItem.h
//  LLama
//
//  Created by Live on 16/1/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"

typedef NS_ENUM(NSInteger,LLAPayUserType){
    LLAPayUserType_AccountBalance = 0,
    LLAPayUserType_Alipay = 1,
    LLAPayUserType_WeChat = 2,
};

@interface LLAPayUserPayTypeItem : MTLModel

@property(nonatomic ,assign) LLAPayUserType payType;

@property(nonatomic ,copy) NSString *payTypeDesc;

@property(nonatomic ,strong) UIImage *payTypeNormalImage;

@property(nonatomic ,strong) UIImage *payTypeHighlightImage;

@property(nonatomic , strong) UIColor *backColor;

@end
