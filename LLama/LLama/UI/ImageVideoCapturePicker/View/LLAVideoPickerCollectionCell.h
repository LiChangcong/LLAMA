//
//  LLAVideoPickerCollectionCell.h
//  LLama
//
//  Created by Live on 16/1/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAPickVideoItemInfo;

@interface LLAVideoPickerCollectionCell : UICollectionViewCell

- (void) updateCellWithInfo:(LLAPickVideoItemInfo *) info;

+ (CGFloat) calculateHeightWithInfo:(LLAPickVideoItemInfo *) info width:(CGFloat) width;

@end
