//
//  LLAUserProfileVideoHeaderView.h
//  LLama
//
//  Created by Live on 16/1/22.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LLAUserProfileMainInfo.h"


@protocol LLAUserProfileVideoHeaderViewDelegate <NSObject>

- (void) showVideosWithType:(UserProfileHeadVideoType ) type;

@end

@interface LLAUserProfileVideoHeaderView : UITableViewHeaderFooterView

@property(nonatomic , weak) id<LLAUserProfileVideoHeaderViewDelegate> delegate;

- (void) updateHeaderWithUserInfo:(LLAUserProfileMainInfo *) mainInfo tableWidth:(CGFloat) tableWidth;

+ (CGFloat) calculateHeightWithUserInfo:(LLAUserProfileMainInfo *) mainInfo tableWidth:(CGFloat) tableWidth;

@end
