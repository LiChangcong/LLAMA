//
//  LLAHotUsersTableViewCell.h
//  LLama
//
//  Created by tommin on 16/2/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAHotUsersTableViewCell;
//#import "LLAHotUserInfo.h"
#import "LLAUser.h"

@protocol LLAHotUsersTableViewCellDelegate <NSObject>

//- (void)hotUsersTableViewCellDidSelectedAttentionButton:(LLAHotUsersTableViewCell *)hotUsersTableViewCell;
- (void)hotUsersTableViewCellDidSelectedAttentionButton:(LLAHotUsersTableViewCell *)hotUsersTableViewCell withIndexPathRow:(NSInteger)indexPathRow;

- (void) userHeadViewTapped:(LLAUser *) userInfo;

@end

@interface LLAHotUsersTableViewCell : UITableViewCell

@property(nonatomic , assign)  NSInteger indexPathRow;

@property(nonatomic , weak) id<LLAHotUsersTableViewCellDelegate> delegate;

- (void) updateCellWithInfo:(LLAUser *) info tableWidth:(CGFloat) width;
@end
