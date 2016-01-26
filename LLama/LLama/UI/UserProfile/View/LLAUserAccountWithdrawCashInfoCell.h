//
//  LLAUserAccountWithdrawCachInfoCell.h
//  LLama
//
//  Created by Live on 16/1/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAUser;

@interface LLAUserAccountWithdrawCashInfoCell : UITableViewCell

- (void) updateCellWithUserInfo:(CGFloat)withdrawCashAmount tableWith:(CGFloat) tableWidth;

+ (CGFloat) calculateHeightWithUserInfo:(CGFloat) withdrawCashAmount tableWidth:(CGFloat) tableWidth;

@end
