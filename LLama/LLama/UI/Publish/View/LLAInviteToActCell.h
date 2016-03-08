//
//  LLAInviteToActCell.h
//  LLama
//
//  Created by tommin on 16/3/7.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAInviteToActCell;
#import "LLAInviteToActInfo.h"
#import "LLAUser.h"

@protocol LLAInviteToActCellDelegate <NSObject>

- (void)inviteToActCellDidSelectedSelectButton:(LLAInviteToActCell *) inviteToActCell withIndexPath:(NSInteger) indexPath;

- (void) userHeadViewTapped:(LLAUser *) userInfo;


@end

@interface LLAInviteToActCell : UITableViewCell

@property (nonatomic, weak) id<LLAInviteToActCellDelegate> delegate;

@property (nonatomic, assign) NSInteger indexPath;


- (void) updateCellWithInfo:(LLAInviteToActInfo *) info tableWidth:(CGFloat) width;

@end
