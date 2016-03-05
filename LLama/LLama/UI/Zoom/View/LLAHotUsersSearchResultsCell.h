//
//  LLAHotUsersSearchResultsCell.h
//  LLama
//
//  Created by tommin on 16/2/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LLAUser.h"
@class LLAHotUsersCell;

@protocol LLAHotUsersSearchResultsCellDelegate <NSObject>

- (void) userHeadViewTapped:(LLAUser *) userInfo;

@end

@interface LLAHotUsersSearchResultsCell : UITableViewCell


@property(nonatomic , weak) id<LLAHotUsersSearchResultsCellDelegate> delegate;

- (void) updateCellWithInfo:(NSMutableArray <LLAUser *> *)info tableWidth:(CGFloat)width;


@end
