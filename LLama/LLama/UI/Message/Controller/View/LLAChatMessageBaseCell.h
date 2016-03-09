//
//  LLAChatMessageBaseCell.h
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

/****
 *虚基类，绝逼不要实例化
 *
 *
 **/

#import <UIKit/UIKit.h>

@class LLAUser;

@class LLAUserHeadView;

@class LLAIMMessage;

@protocol LLAChatMessageCellDelegate <NSObject>

@optional

- (void) resentFailedMessage:(LLAIMMessage *) message;

- (void) showUserDetailWithUserInfo:(LLAUser *) userInfo;

//for text cell

//for image cell

- (void) showFullImageWithMessage:(LLAIMMessage *) message imageView:(UIImageView *) imageView;

//for voice cell

- (void) playStopVoiceWithMessage:(LLAIMMessage *) message;

@end

@interface LLAChatMessageBaseCell : UITableViewCell

@property(nonatomic , readonly) UILabel *timeLabel;

@property(nonatomic , readonly) LLAUserHeadView *headView;

@property(nonatomic , readonly) UIImageView *bubbleImageView;

@property(nonatomic , readonly) LLAIMMessage *currentMessage;

@property(nonatomic , readonly) BOOL shouldShowTime;

@property(nonatomic , readonly) CGFloat cellMaxWidth;

@property(nonatomic , weak) id<LLAChatMessageCellDelegate> delegate;

- (void) updateCellWithMessage:(LLAIMMessage *) message maxWidth:(CGFloat) maxWidth showTime:(BOOL) showTime;

+ (CGFloat) calculateHeightWithMessage:(LLAIMMessage *) message maxWidth:(CGFloat) maxWidth showTime:(BOOL) shouldShow;

+ (CGSize) calculateContentSizeWithMessage:(LLAIMMessage *) message maxWidth:(CGFloat) maxWidth;

@end
