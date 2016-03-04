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

@class LLAUserHeadView;

@class LLAIMMessage;

@interface LLAChatMessageBaseCell : UITableViewCell

@property(nonatomic , readonly) UILabel *timeLabel;

@property(nonatomic , readonly) LLAUserHeadView *headView;

@property(nonatomic , readonly) UIImageView *bubbleImageView;

@property(nonatomic , readonly) LLAIMMessage *currentMessage;

@property(nonatomic , readonly) CGFloat cellMaxWidth;

- (void) updateCellWithMessage:(LLAIMMessage *) message maxWidth:(CGFloat) maxWidth showTime:(BOOL) showTime;

+ (CGFloat) calculateHeightWithMessage:(LLAIMMessage *) message maxWidth:(CGFloat) maxWidth showTime:(BOOL) shouldShow;

+ (CGSize) calculateContentSizeWithMessage:(LLAIMMessage *) message maxWidth:(CGFloat) maxWidth;

@end
