//
//  LLAUserProfileMyFunctionCell.h
//  LLama
//
//  Created by Live on 16/1/21.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAUser;

@protocol LLAUserProfileMyFunctionCellDelegate <NSObject>

- (void) showPersonalPropertyWithUserInfo:(LLAUser *) userInfo;

- (void) showPersonalOrderListWithUserInfo:(LLAUser *) userInfo;

@end

@interface LLAUserProfileMyFunctionCell : UITableViewCell

@property(nonatomic , weak) id<LLAUserProfileMyFunctionCellDelegate> delegate;

- (void) updateCellWithUserInfo:(LLAUser *) userInfo tableWidth:(CGFloat) tableWidth;

+ (CGFloat) calculateHeightWithUserInfo:(LLAUser *) userInfo tableWidth:(CGFloat) tableWidth;

@end
