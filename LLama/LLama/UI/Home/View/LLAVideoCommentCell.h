//
//  LLAVideoCommentCell.h
//  LLama
//
//  Created by Live on 16/2/1.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAHallVideoCommentItem;
@class LLAUser;

@protocol LLAVideoCommentCellDelegate <NSObject>

- (void) toggleUser:(LLAUser *) userInfo commentInfo:(LLAHallVideoCommentItem *) commentInfo;

@end

@interface LLAVideoCommentCell : UITableViewCell

@property(nonatomic , weak) id<LLAVideoCommentCellDelegate> delegate;

- (void) updateCellWithCommentItem:(LLAHallVideoCommentItem *) commentInfo maxWidth:(CGFloat) maxWidth;

+ (CGFloat) calculateHeightWithCommentItem:(LLAHallVideoCommentItem *) commentInfo maxWidth:(CGFloat) maxWidth;

@end
