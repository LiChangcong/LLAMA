//
//  LLASocialShareHorPageLayout.h
//  LLama
//
//  Created by Live on 16/2/26.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLASocialShareHorPageLayoutDelegate <NSObject>

- (CGSize) collectionView:(nonnull UICollectionView *) collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

- (CGSize) collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath;

@end

@interface LLASocialShareHorPageLayout : UICollectionViewLayout

@property(nonatomic , assign) CGFloat minCellHorSpace;

@property(nonatomic , assign) CGFloat minCellVerSpace;

@property(nonatomic , assign) UIEdgeInsets sectionInsets;

@property(nonatomic , assign) _Nullable id <LLASocialShareHorPageLayoutDelegate> delegate;

@end
