//
//  TMTopicCell.h
//  LLama
//
//  Created by tommin on 15/12/8.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMTopicCell;

@protocol TMTopicCellDelegate <NSObject>
@optional
- (void)topicCellDidClickLikeButton:(TMTopicCell *)topicCell;
- (void)topicCellDidClickMoreButton:(TMTopicCell *)topicCell;

@end

@interface TMTopicCell : UITableViewCell

/** 代理对象 */
@property (nonatomic, weak) id<TMTopicCellDelegate> delegate;

@end
