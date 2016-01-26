//
//  LLAUserAccountWithdrawCacheCell.h
//  LLama
//
//  Created by Live on 16/1/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLAUserAccountWithdrawCashCellDelegate <NSObject>

- (void) withDrawcache;

@end

@interface LLAUserAccountWithdrawCashCell : UITableViewCell

@property(nonatomic , readonly) UITextField *cashTextField;

@property(nonatomic , assign) id<LLAUserAccountWithdrawCashCellDelegate> delegate;

- (void) updateCellWithDrawCash:(NSInteger) cashNum;

+ (CGFloat) calculateCellHeight;

@end
