//
//  LLAInviteToActInfo.h
//  LLama
//
//  Created by tommin on 16/3/7.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLAUser.h"

@interface LLAInviteToActInfo : NSObject

@property(nonatomic, strong) LLAUser *inviteUser;

/*
    额外属性
 */
@property(nonatomic, assign) BOOL selected;

@end
