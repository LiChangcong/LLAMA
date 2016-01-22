//
//  LLAUserProfileOtherInfoCell.h
//  LLama
//
//  Created by Live on 16/1/22.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LLACellPlayVideoProtocol.h"

@class LLAUser;

@protocol LLAUserProfileOtherInfoCellDelegate <NSObject>

- (void) headViewTapped:(LLAUser *) userInfo;

- (void) uploadVieoToggled:(LLAUser *) userInfo;

@end

@interface LLAUserProfileOtherInfoCell : UITableViewCell<LLACellPlayVideoProtocol>

@property(nonatomic , weak) id<LLAUserProfileOtherInfoCellDelegate> delegate;

- (void) updateCellWithUserInfo:(LLAUser *) userInfo tableWidth:(CGFloat) tableWidth;

+ (CGFloat) calculateHeightWithUserInfo:(LLAUser *) userInfo tableWidth:(CGFloat) tableWidth;


@end
