//
//  LLAHotUserInfo.h
//  LLama
//
//  Created by tommin on 16/2/29.
//  Copyright © 2016年 heihei. All rights reserved.
//


#import "MTLModel.h"

#import "LLAUser.h"

typedef NS_ENUM(NSInteger,LLAAttentionType){
    LLAAttentionType_NotAttention = 0,
    LLAAttentionType_HasAttention = 1,
    LLAAttentionType_AllAttention = 2,
};



@interface LLAHotUserInfo : MTLModel

@property(nonatomic, copy) LLAUser *hotUser;

@property(nonatomic, assign) LLAAttentionType attentionType;

@end
