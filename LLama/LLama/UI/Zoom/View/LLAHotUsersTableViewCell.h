//
//  LLAHotUsersTableViewCell.h
//  LLama
//
//  Created by tommin on 16/2/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAHotUsersTableViewCell;
#import "LLAHotUserInfo.h"

@protocol LLAHotUsersTableViewCellDelegate <NSObject>

- (void)hotUsersTableViewCellDidSelectedAttentionButton:(LLAHotUsersTableViewCell *)hotUsersTableViewCell;

@end

@interface LLAHotUsersTableViewCell : UITableViewCell

@property(nonatomic , weak) id<LLAHotUsersTableViewCellDelegate> delegate;

- (void) updateCellWithInfo:(LLAHotUserInfo *) info tableWidth:(CGFloat) width;
@end
