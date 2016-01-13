//
//  LLAUserHeadView.h
//  LLama
//
//  Created by Live on 16/1/13.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAUser;
@class LLAUserHeadView;

@protocol LLAUserHeadViewDelegate <NSObject>

- (void) headView:(LLAUserHeadView *) headView clickedWithUserInfo:(LLAUser *) user;

@end

@interface LLAUserHeadView : UIView

@property(nonatomic , readonly) UIImageView *userHeadImageView;

@property(nonatomic , readonly) UIImageView *userRoleImageView;

@property(nonatomic , readonly)LLAUser *currentUser;

@property(nonatomic , weak) id<LLAUserHeadViewDelegate> delegate;

- (void) updateHeadViewWithUser:(LLAUser *)userInfo;

@end
