//
//  LLAHallVideoInfoCell.h
//  LLama
//
//  Created by Live on 16/1/14.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLACellPlayVideoProtocol.h"

@class LLAHallVideoItemInfo;
@class LLAUser;
@class LLAHallVideoCommentItem;

@protocol LLAHallVideoInfoCellDelegate <NSObject>

- (void) userHeadViewClickedWithUserInfo:(LLAUser *) userInfo itemInfo:(LLAHallVideoItemInfo *) videoItemInfo;

- (void) loveVideoWithVideoItemInfo:(LLAHallVideoItemInfo *) videoItemInfo loveButton:(UIButton *)loveButton;

- (void) commentVideoWithVideoItemInfo:(LLAHallVideoItemInfo *) videoItemInfo;

- (void) shareVideoWithVideoItemInfo:(LLAHallVideoItemInfo *)videoItemInfo ;

- (void) commentVideoChooseWithCommentInfo:(LLAHallVideoCommentItem *) commentInfo videoItemInfo:(LLAHallVideoItemInfo *) vieoItemInfo;

- (void) chooseUserFromComment:(LLAHallVideoCommentItem *) commentInfo userInfo:(LLAUser *)userInfo videoInfo:(LLAHallVideoItemInfo *) videoItemInfo;

@end

@interface LLAHallVideoInfoCell : UITableViewCell<LLACellPlayVideoProtocol>

@property(nonatomic , weak) id<LLAHallVideoInfoCellDelegate> delegate;

- (void) updateCellWithVideoInfo:(LLAHallVideoItemInfo *) videoInfo tableWidth:(CGFloat) tableWidth;

+ (CGFloat) calculateHeightWithVideoInfo:(LLAHallVideoItemInfo *) videoInfo tableWidth:(CGFloat) tableWith;

@end
