//
//  LLAHotUsersViewController.h
//  LLama
//
//  Created by tommin on 16/2/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLACommonViewController.h"

typedef enum : NSUInteger {
    UserTypeIsHotUsers,
    UserTypeIsResultsUsers,
} UserType;

@interface LLAHotUsersViewController : LLACommonViewController

@property(nonatomic , assign) UserType userType;
@end
