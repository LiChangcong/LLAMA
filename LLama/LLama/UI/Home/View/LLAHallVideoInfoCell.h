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

@optional

/**
 *  点击了头像
 */
- (void) userHeadViewClickedWithUserInfo:(LLAUser *) userInfo itemInfo:(LLAHallVideoItemInfo *) videoItemInfo;
/**
 *  点赞按钮点击
 */
- (void) loveVideoWithVideoItemInfo:(LLAHallVideoItemInfo *) videoItemInfo loveButton:(UIButton *)loveButton;
/**
 *  评论按钮点击
 */
- (void) commentVideoWithVideoItemInfo:(LLAHallVideoItemInfo *) videoItemInfo;
/**
 *  分享按钮点击
 */
- (void) shareVideoWithVideoItemInfo:(LLAHallVideoItemInfo *)videoItemInfo ;
/**
 *  评论中用户名按钮点击
 */
- (void) commentVideoChooseWithCommentInfo:(LLAHallVideoCommentItem *) commentInfo videoItemInfo:(LLAHallVideoItemInfo *) vieoItemInfo;

- (void) chooseUserFromComment:(LLAHallVideoCommentItem *) commentInfo userInfo:(LLAUser *)userInfo videoInfo:(LLAHallVideoItemInfo *) videoItemInfo;

@end

@interface LLAHallVideoInfoCell : UITableViewCell<LLACellPlayVideoProtocol>

@property(nonatomic , weak) id<LLAHallVideoInfoCellDelegate,LLAVideoPlayerViewDelegate> delegate;

- (void) updateCellWithVideoInfo:(LLAHallVideoItemInfo *) videoInfo tableWidth:(CGFloat) tableWidth;

+ (CGFloat) calculateHeightWithVideoInfo:(LLAHallVideoItemInfo *) videoInfo tableWidth:(CGFloat) tableWith;

@end
