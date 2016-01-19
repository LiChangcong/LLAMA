//
//  LLAAlbumPickerCell.h
//  LLama
//
//  Created by tommin on 16/1/19.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAAlbumPickerCell;

@protocol LLAAlbumPickerCellDelegate <NSObject>
@optional
- (void)selectImage:(LLAAlbumPickerCell *)albumCell indexPath:(NSIndexPath *)indexPath forSelected:(BOOL)selected;
@end

@interface LLAAlbumPickerCell : UICollectionViewCell


// 设置每张图片右边的选中按钮隐藏与否
- (void)setBtnImgHidden:(BOOL)hidden;
- (void)setSelected:(BOOL)selected;

// 显示的图片
@property (nonatomic,strong)UIImageView * imageView;
@property (nonatomic,strong)NSIndexPath * indexPath;

// 代理
@property (nonatomic,weak)id<LLAAlbumPickerCellDelegate>delegate;

@end
