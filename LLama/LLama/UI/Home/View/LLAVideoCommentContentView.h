//
//  LLAVideoCommentContentView.h
//  LLama
//
//  Created by Live on 16/1/14.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAHallVideoCommentItem;
@class LLAUser;

@protocol LLAVideoCommentContentViewDelegate <NSObject>

- (void) commentViewClickedWithCommentInfo:(LLAHallVideoCommentItem *) commentInfo;

- (void) commentViewUserNameClickedWithUserInfo:(LLAUser *) userInfo commentInfo:(LLAHallVideoCommentItem *) commentInfo;

@end

@interface LLAVideoCommentContentView : UIView

@property(nonatomic , weak) id<LLAVideoCommentContentViewDelegate> delegate;

- (void) updateCommentContentViewWithInfo:(NSArray <LLAHallVideoCommentItem*> *) comments maxWidth:(CGFloat) maxWidth;

+ (CGFloat) calculateHeightWithCommentsInfo:(NSArray<LLAHallVideoCommentItem*> *) comments maxWidth:(CGFloat) maxWidth;

@end
