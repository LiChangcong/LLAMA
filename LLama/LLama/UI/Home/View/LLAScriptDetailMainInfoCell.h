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
/**
 *  选中导演头像
 */
- (void) directorHeadViewClicked:(LLAUserHeadView *) headView userInfo:(LLAUser *) userInfo scriptInfo:(LLAScriptHallItemInfo *)scriptInfo;
/**
 *  点击更多信息后收起或者展开基本详情
 */
- (void) flexOrShrinkScriptContentWithScriptInfo:(LLAScriptHallItemInfo *) scriptInfo;
/**
 *  点击功能按钮（报名什么的那个按钮）
 */
- (void) manageScriptWithScriptInfo:(LLAScriptHallItemInfo *) scriptInfo;


@end

@interface LLAScriptDetailMainInfoCell : UICollectionViewCell

@property(nonatomic , weak) id<LLAScriptDetailMainInfoCellDelegate> delegate;

- (void) updateCellWithInfo:(LLAScriptHallItemInfo *) scriptInfo maxWidth:(CGFloat) maxWidth;

+ (CGFloat) calculateHeightWithInfo:(LLAScriptHallItemInfo *)scriptInfo maxWidth:(CGFloat) maxWidth;

@end
