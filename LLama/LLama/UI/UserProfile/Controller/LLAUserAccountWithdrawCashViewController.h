//
//  LLAUserAccountWithdrawCashViewController.h
//  LLama
//
//  Created by Live on 16/1/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLACommonViewController.h"

@protocol LLAUserAccountWithdrawCashViewControllerDelegate <NSObject>

- (void) drawCacheSuccess;

@end

@interface LLAUserAccountWithdrawCashViewController : LLACommonViewController

@property(nonatomic , assign) id<LLAUserAccountWithdrawCashViewControllerDelegate> delegate;

- (instancetype) initWithCashAmount:(CGFloat) cashAmount;

@end
