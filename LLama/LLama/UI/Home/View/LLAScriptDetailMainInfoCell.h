//
//  LLAScriptDetailMainInfoCell.h
//  LLama
//
//  Created by Live on 16/1/17.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAScriptHallItemInfo;
@class LLAUserHeadView;
@class LLAUser;

@protocol LLAScriptDetailMainInfoCellDelegate <NSObject>

- (void) directorHeadViewClicked:(LLAUserHeadView *) headView userInfo:(LLAUser *) userInfo scriptInfo:(LLAScriptHallItemInfo *)scriptInfo;

- (void) flexOrShrinkScriptContentWithScriptInfo:(LLAScriptHallItemInfo *) scriptInfo;

- (void) manageScriptWithScriptInfo:(LLAScriptHallItemInfo *) scriptInfo;


@end

@interface LLAScriptDetailMainInfoCell : UICollectionViewCell

@property(nonatomic , weak) id<LLAScriptDetailMainInfoCellDelegate> delegate;

- (void) updateCellWithInfo:(LLAScriptHallItemInfo *) scriptInfo maxWidth:(CGFloat) maxWidth;

+ (CGFloat) calculateHeightWithInfo:(LLAScriptHallItemInfo *)scriptInfo maxWidth:(CGFloat) maxWidth;

@end
