//
//  LLAMessageCenterSystemMessageCell.h
//  LLama
//
//  Created by Live on 16/2/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAMessageCenterSystemMsgInfo;

@interface LLAMessageCenterSystemMessageCell : UITableViewCell

- (void) updateCellWithMsgInfo:(LLAMessageCenterSystemMsgInfo *) info tableWidth:(CGFloat) tableWidth;

+ (CGFloat) calculateCellWithMsgInfo:(LLAMessageCenterSystemMsgInfo *) info tableWidth:(CGFloat) tableWidth;

@end
