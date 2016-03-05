//
//  LLAHotUsersCell.h
//  LLama
//
//  Created by tommin on 16/2/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LLAHotUsersCell;
@class LLAUser;

@protocol LLAHotUsersCellDelegate <NSObject>

- (void) userHeadViewTapped:(LLAUser *) userInfo;

@end

@interface LLAHotUsersCell : UICollectionViewCell

@property(nonatomic , weak) id<LLAHotUsersCellDelegate> delegate;

- (void) updateCellWithInfo:(NSMutableArray *)info tableWidth:(CGFloat)width;
@end
