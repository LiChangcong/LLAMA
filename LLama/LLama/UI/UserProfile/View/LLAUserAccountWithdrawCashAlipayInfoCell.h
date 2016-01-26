//
//  LLAUserAccountWithdrawCacheAlipayInfoCell.h
//  LLama
//
//  Created by Live on 16/1/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAUser;

@interface LLAUserAccountWithdrawCashAlipayInfoCell : UITableViewCell

- (void) updateCellWithUserInfo:(LLAUser *) userInfo;

+ (CGFloat) calculateHeightWithUserInfo:(LLAUser *) userInfo tableWidth:(CGFloat) tableWidth;

@end
