//
//  LLASoicalSharePlatformCell.h
//  LLama
//
//  Created by Live on 16/2/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLASocialSharePlatformItem;

@protocol LLASoicalSharePlatformCellDelegate <NSObject>

- (void) shareWithPlatformInfo:(LLASocialSharePlatformItem *) platformInfo;

@end

@interface LLASoicalSharePlatformCell : UICollectionViewCell

@property(nonatomic , weak) id<LLASoicalSharePlatformCellDelegate> delegate;

- (void) updateCellWithPlatformInfo:(LLASocialSharePlatformItem *) platformInfo;

+ (CGFloat) calculateHeightWithPlatformInfo:(LLASocialSharePlatformItem *) platformInfo maxWidth:(CGFloat) maxWidth;

@end
