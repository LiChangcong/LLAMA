//
//  LLAChooseActorCell.h
//  LLama
//
//  Created by Live on 16/1/18.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAUser;

@protocol LLAChooseActorCellDelegate <NSObject>

- (void) viewUserDetailWithUserInfo:(LLAUser *) userInfo;

@end

@interface LLAChooseActorCell : UICollectionViewCell

@property(nonatomic , weak) id<LLAChooseActorCellDelegate> delegate;

- (void) updateCellWithUserInfo:(LLAUser *) userInfo;

+ (CGFloat) calculateHeightWitthUserInfo:(LLAUser *) userInfo maxWidth:(CGFloat) maxWidth;

@end
