//
//  LLAChatInputEmojiFlowLayout.h
//  LLama
//
//  Created by Live on 16/2/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLAChatInputEmojiFlowLayoutDelegate <NSObject>

- (CGSize) collectionView:(nonnull UICollectionView *) collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;

- (CGSize) collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath;

@end


@interface LLAChatInputEmojiFlowLayout : UICollectionViewLayout

@property(nonatomic , assign) CGFloat minCellHorSpace;

@property(nonatomic , assign) CGFloat minCellVerSpace;

@property(nonatomic , assign) UIEdgeInsets sectionInsets;

@property(nonatomic , assign) _Nullable id <LLAChatInputEmojiFlowLayoutDelegate> delegate;


@end
