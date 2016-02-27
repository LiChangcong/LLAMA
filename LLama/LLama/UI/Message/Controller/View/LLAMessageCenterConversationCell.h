//
//  LLAMessageCenterConversationCell.h
//  LLama
//
//  Created by Live on 16/2/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAMessageCenterRoomInfo;

@interface LLAMessageCenterConversationCell : UITableViewCell

- (void) updateCellWithRoomInfo:(LLAMessageCenterRoomInfo *) info tableWidth:(CGFloat) width;

+ (CGFloat) calculateCellHeight:(LLAMessageCenterRoomInfo *) info tableWidth:(CGFloat) width;

@end
