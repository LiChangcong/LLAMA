//
//  LLARewardMoneyView.h
//  LLama
//
//  Created by Live on 16/1/14.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat videoRewardMoneyViewWidth;
extern CGFloat videoRewardMoneyViewHeight;

@interface LLARewardMoneyView : UIImageView

@property(nonatomic , readonly) NSInteger showingMoney;

- (void) updateViewWithRewardMoney:(NSInteger) money;

@end
