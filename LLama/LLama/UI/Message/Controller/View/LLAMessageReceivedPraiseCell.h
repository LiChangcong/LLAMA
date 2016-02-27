//
//  LLAMessageReceivedPraiseCell.h
//  LLama
//
//  Created by Live on 16/2/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAMessageReceivedPraiseItemInfo;

@interface LLAMessageReceivedPraiseCell : UITableViewCell

- (void) updateCellWithInfo:(LLAMessageReceivedPraiseItemInfo *) info tableWidth:(CGFloat) width;

+ (CGFloat) calculateHeightWithInfo:(LLAMessageReceivedPraiseItemInfo *) info tableWidth:(CGFloat) width;

@end
