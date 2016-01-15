//
//  LLAVideoCommentView.h
//  LLama
//
//  Created by Live on 16/1/14.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAHallVideoCommentItem;
@class TYAttributedLabel;
@class LLAVideoCommentView;
@class LLAUser;

@protocol LLAVideoCommentViewDelegate <NSObject>

- (void) commentView:(LLAVideoCommentView *) commentView userNameClicked:(LLAUser *) userInfo;

- (void) singleTappedWithCommentView:(LLAVideoCommentView *) commentView;

@end

@interface LLAVideoCommentView : UIView

@property(nonatomic , weak) id<LLAVideoCommentViewDelegate> delegate;

@property(nonatomic , readonly) TYAttributedLabel *attrLabel;

@property(nonatomic , readonly) LLAHallVideoCommentItem *currentCommentInfo;

- (void) updateCommentWithInfo:(LLAHallVideoCommentItem *) commentInfo maxWidth:(CGFloat) maxWidth;

+ (CGFloat) calculateHeightWihtInfo:(LLAHallVideoCommentItem *) commentInfo maxWidth:(CGFloat) maxWidth;

@end
