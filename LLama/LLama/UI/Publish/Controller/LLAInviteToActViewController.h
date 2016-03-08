//
//  LLAInviteToActViewController.h
//  LLama
//
//  Created by tommin on 16/3/7.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LLACommonViewController.h"


typedef void(^inviteCallBackBlock)(NSArray *hasSelectedUserArray);

@interface LLAInviteToActViewController : LLACommonViewController

@property (nonatomic , copy) inviteCallBackBlock callBack;



@end
