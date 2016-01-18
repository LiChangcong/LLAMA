//
//  LLAScriptDetailMainInfoCell.h
//  LLama
//
//  Created by Live on 16/1/17.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAScriptHallItemInfo;

@protocol LLAScriptDetailMainInfoCellDelegate <NSObject>

@end

@interface LLAScriptDetailMainInfoCell : UICollectionViewCell

@property(nonatomic , weak) id<LLAScriptDetailMainInfoCellDelegate> delegate;

- (void) updateCellWithInfo:(LLAScriptHallItemInfo *) scriptInfo maxWidth:(CGFloat) maxWidth;

+ (CGFloat) calculateHeightWithInfo:(LLAScriptHallItemInfo *)scriptInfo maxWidth:(CGFloat) maxWidth;

@end
