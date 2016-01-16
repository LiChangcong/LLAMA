//
//  LLAScriptHallInfoCell.h
//  LLama
//
//  Created by Live on 16/1/16.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAScriptHallItemInfo;
@class LLAUser;

@protocol LLAScriptHallInfoCellDelegate <NSObject>

- (void) userHeadViewTapped:(LLAUser *) userInfo scriptInfo:(LLAScriptHallItemInfo *) scriptInfo;

@end

@interface LLAScriptHallInfoCell : UITableViewCell

@property(nonatomic , weak) id<LLAScriptHallInfoCellDelegate> delegate;

- (void) updateCellWithScriptInfo:(LLAScriptHallItemInfo *) scriptInfo tableWidth:(CGFloat) tableWidth;

+ (CGFloat) calculateHeightWithScriptInfo:(LLAScriptHallItemInfo *) scriptInfo tableWidth:(CGFloat) tableWidth;

@end
