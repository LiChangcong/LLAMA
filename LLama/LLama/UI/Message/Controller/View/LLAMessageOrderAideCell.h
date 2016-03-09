//
//  LLAMessageOrderAideCell.h
//  LLama
//
//  Created by Live on 16/2/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAMessageReceivedOrderItemInfo;
@class LLAUser;

@protocol LLAMessageOrderAideCellDelegate <NSObject>

- (void) headViewClickWithUserInfo:(LLAUser *) userInfo;

@end

@interface LLAMessageOrderAideCell : UITableViewCell

@property(nonatomic , weak) id<LLAMessageOrderAideCellDelegate> delegate;

- (void) updateCellWithInfo:(LLAMessageReceivedOrderItemInfo *) info tableWidth:(CGFloat) width;

+ (CGFloat) calculateHeightWithInfo:(LLAMessageReceivedOrderItemInfo *) info tableWidth:(CGFloat) width;

@end
