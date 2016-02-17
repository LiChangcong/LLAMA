//
//  LLAImagePickerCollectionCell.h
//  LLama
//
//  Created by tommin on 16/2/16.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAPickImageItemInfo;
@class LLAImagePickerCollectionCell;

@protocol  LLAImagePickerCollectionCellDelegate<NSObject>
@optional
- (void)LLAImagePickerCollectionCellDidClickSelectedButton:(LLAImagePickerCollectionCell *)imagePickerCollectionCell andIndexPath:(NSIndexPath *)indexPath andButtonIsSelected:(BOOL)isSelected;

@end

@interface LLAImagePickerCollectionCell : UICollectionViewCell

- (void) updateCellWithInfo:(LLAPickImageItemInfo *) info;

+ (CGFloat) calculateHeightWithInfo:(LLAPickImageItemInfo *) info width:(CGFloat) width;

/** 代理对象 */
@property (nonatomic, weak) id<LLAImagePickerCollectionCellDelegate> delegate;

@property (nonatomic, assign) NSIndexPath *indexPath;

@end
