//
//  LLAInviteView.h
//  LLama
//
//  Created by tommin on 16/3/7.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLAUser.h"

@interface LLAInviteView : UIView

@property(nonatomic, strong) NSArray <LLAUser *> *inviteUsersArray;

- (void)updateInfoWithInfoArray:(NSArray *)infoArray;

@end
