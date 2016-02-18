//
//  LLAUserProfileMyInfoCell.h
//  LLama
//
//  Created by Live on 16/1/21.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LLACellPlayVideoProtocol.h"

@class LLAUser;

@protocol LLAUserProfileMyInfoCellDelegate <NSObject>

- (void) headViewTapped:(LLAUser *) userInfo;

- (void) uploadVieoToggled:(LLAUser *) userInfo;

- (void) uploadVieoFinished:(LLAUser *) userInfo;

@end

@interface LLAUserProfileMyInfoCell : UITableViewCell<LLACellPlayVideoProtocol>

@property(nonatomic , weak) id<LLAUserProfileMyInfoCellDelegate,LLAVideoPlayerViewDelegate> delegate;

- (void) updateCellWithUserInfo:(LLAUser *) userInfo tableWidth:(CGFloat) tableWidth;

+ (CGFloat) calculateHeightWithUserInfo:(LLAUser *) userInfo tableWidth:(CGFloat) tableWidth;

@end
