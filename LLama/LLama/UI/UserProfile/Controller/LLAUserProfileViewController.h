//
//  LLAUserProfileViewController.h
//  LLama
//
//  Created by Live on 16/1/12.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLACustomNavigationBarViewController.h"

typedef NS_ENUM(NSInteger,UserProfileControllerType){
    
    UserProfileControllerType_NotLogin = 0,
    UserProfileControllerType_CurrentUser = 1,
    UserProfileControllerType_OtherUser = 2,
};

@interface LLAUserProfileViewController : LLACustomNavigationBarViewController

- (instancetype) initWithUserIdString:(NSString *) userIdString;

@property(nonatomic , readonly) NSString *uIdString;

@property(nonatomic , readonly) UserProfileControllerType type;

@end
