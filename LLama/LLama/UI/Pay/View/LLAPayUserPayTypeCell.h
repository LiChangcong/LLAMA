//
//  LLAPayUserPayTypeCell.h
//  LLama
//
//  Created by Live on 16/1/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAPayUserPayTypeItem;

@interface LLAPayUserPayTypeCell : UICollectionViewCell

- (void) updateCellWithPayTypeInfo:(LLAPayUserPayTypeItem *) payTypeInfo;

+ (CGFloat) calculateHeightPayTypeInfo:(LLAPayUserPayTypeItem *) payTypeInfo width:(CGFloat) width;

@end
