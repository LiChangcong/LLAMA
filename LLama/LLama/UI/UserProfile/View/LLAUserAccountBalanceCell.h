//
//  LLAUserAccountBalanceCell.h
//  LLama
//
//  Created by Live on 16/1/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAUser;

@interface LLAUserAccountBalanceCell : UITableViewCell

- (void) updateCellWithUserInfo:(LLAUser *)userInfo tableWith:(CGFloat) tableWidth;

+ (CGFloat) calculateHeightWithUserInfo:(LLAUser *) userInfo tableWidth:(CGFloat) tableWidth;

@end
