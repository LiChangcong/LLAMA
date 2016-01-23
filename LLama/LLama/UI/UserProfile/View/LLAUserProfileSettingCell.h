//
//  LLAUserProfileSettingCell.h
//  LLama
//
//  Created by Live on 16/1/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAUserProfileSettingItemInfo;

@interface LLAUserProfileSettingCell : UITableViewCell

- (void) updateCellWithItemInfo:(LLAUserProfileSettingItemInfo *) info shouldHideSepLine:(BOOL) hide;

+ (CGFloat) calculateHeightWihtItemInfo:(LLAUserProfileSettingItemInfo *) info;

@end
