//
//  LLAUserOrderListCell.h
//  LLama
//
//  Created by Live on 16/1/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAUser;
@class LLAScriptHallItemInfo;

@protocol LLAUserOrderListCellDelegate <NSObject>

- (void) userHeadViewTapped:(LLAUser *) userInfo scriptInfo:(LLAScriptHallItemInfo *) scriptInfo;

- (void) manageScriptWithScriptInfo:(LLAScriptHallItemInfo *) scriptInfo;

@end

@interface LLAUserOrderListCell : UICollectionViewCell

@property(nonatomic , weak) id<LLAUserOrderListCellDelegate> delegate;

- (void) updateCellWithScriptInfo:(LLAScriptHallItemInfo *)scriptInfo maxCellWidth:(CGFloat)maxCellWidth;

+ (CGFloat) calculateHeightWithScriptInfo:(LLAScriptHallItemInfo *)scriptInfo maxCellWidth:(CGFloat)maxCellWidth;

@end
