//
//  LLAUserProfileLogoutCell.h
//  LLama
//
//  Created by Live on 16/1/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLAUserProfileLogoutCellDelegate <NSObject>

- (void) logoutCurrentUser;

@end

@interface LLAUserProfileLogoutCell : UITableViewCell

@property(nonatomic , weak) id<LLAUserProfileLogoutCellDelegate> delegate;

+ (CGFloat) calculateHeight;

@end
