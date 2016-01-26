//
//  LLAUserAccountWithdrawCacheCell.h
//  LLama
//
//  Created by Live on 16/1/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLAUserAccountWithdrawCacheCell : UITableViewCell

@property(nonatomic , readonly) UITextField *cashTextField;

- (void) updateCellWithDrawCash:(NSInteger) cashNum;

+ (CGFloat) calculateCellHeight;

@end
