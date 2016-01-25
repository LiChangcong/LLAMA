//
//  LLAUserAccountDetailInfoCell.h
//  LLama
//
//  Created by Live on 16/1/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAUserAccountDetailItemInfo;

@interface LLAUserAccountDetailInfoCell : UITableViewCell

- (void) updateCellWithItemInfo:(LLAUserAccountDetailItemInfo *)info tableWidth:(CGFloat) tableWidth;

+ (CGFloat) calculateHeightWithItemInfo:(LLAUserAccountDetailItemInfo *)info tableWidth:(CGFloat) tableWidth;

@end
