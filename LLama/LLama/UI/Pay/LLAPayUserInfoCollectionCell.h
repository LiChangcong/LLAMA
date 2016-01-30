//
//  LLAPayUserInfoCollectionCell.h
//  LLama
//
//  Created by Live on 16/1/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAPayUserPayInfo;

@interface LLAPayUserInfoCollectionCell : UICollectionViewCell

- (void) updateCellWithPayInfo:(LLAPayUserPayInfo *) payInfo;

+ (CGFloat) calculateHeightWithPayInfo:(LLAPayUserPayInfo *)payInfo tableWidth:(CGFloat) tableWidth;

@end
