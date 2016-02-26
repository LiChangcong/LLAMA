//
//  LLASocialShareHorPageLayout.m
//  LLama
//
//  Created by Live on 16/2/26.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLASocialShareHorPageLayout.h"

@interface LLASocialShareHorPageLayout()
{
    CGFloat maxHeightForLayout;
    
    //
    NSArray *layoutData;
    CGSize layoutContentSize;
}

@end

@implementation LLASocialShareHorPageLayout

@synthesize delegate;

@synthesize minCellHorSpace;
@synthesize minCellVerSpace;
@synthesize sectionInsets;

- (void) prepareLayout {
    
    [super prepareLayout];
    
    CGFloat currentX;
    CGFloat currentY;
    NSUInteger numberOfSections;
    NSUInteger numberOfItems;
    NSMutableArray *sectionData;
    
    NSUInteger pages = 0;
    
    currentX = sectionInsets.left;
    currentY = sectionInsets.top;
    
    //
    maxHeightForLayout = self.collectionView.bounds.size.height - sectionInsets.top - sectionInsets.bottom;
    
    //
    //NSMutableArray *curretnColumn = [NSMutableArray array];
    
    numberOfSections = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    
    sectionData = [NSMutableArray arrayWithCapacity:numberOfSections];
    
    
    //in each section
    for (int sectionIndex = 0; sectionIndex < numberOfSections; sectionIndex++) {
        
        currentY = sectionInsets.top;
        
        numberOfItems = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:sectionIndex];
        
        NSMutableArray *itemsData = [NSMutableArray arrayWithCapacity:numberOfItems];
        
        //head attr
        if ([delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            
            CGRect frame;
            CGSize headSize = [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:sectionIndex];
            
            if (headSize.height > 0 && headSize.width > 0) {
                frame = CGRectMake(currentX, 0, headSize.width, headSize.height);
                UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathWithIndex:sectionIndex]];
                attr.frame = frame;
                currentX += frame.size.width;
                currentX += sectionInsets.left;
                [itemsData addObject:attr];
            }
            
        }
        
        //item in section
        
        CGFloat offesetX = 0;
        
        pages ++;
        
        for (int itemIndex = 0; itemIndex < numberOfItems; itemIndex++) {
            
            CGSize itemSize = [delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:itemIndex inSection:sectionIndex]];
        
            UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:itemIndex inSection:sectionIndex]];
            CGRect itemFrame = CGRectMake(currentX, currentY, itemSize.width, itemSize.height);
            attr.frame = itemFrame;

            //x
            if (offesetX + minCellHorSpace + itemSize.width > self.collectionView.bounds.size.width) {
                //new line
                offesetX = 0;
                currentY += itemSize.height;
                currentY += minCellVerSpace;
                //
                itemFrame.origin.y = currentY;
                
                offesetX += itemSize.width;
                
            }else {
                offesetX += minCellHorSpace;
                //
                itemFrame.origin.x = offesetX+currentX;
                //
                offesetX += itemSize.width;
                
            }
            //y
            if (currentY + itemSize.height > maxHeightForLayout) {
                //new page
                pages ++;
                
                currentX += self.collectionView.bounds.size.width;
                currentY = sectionInsets.top;
                
                itemFrame.origin.x = currentX;
                itemFrame.origin.y = currentY;
                
                //
                offesetX = 0;
                offesetX += itemSize.width;
                
                
            }else {
                //currentX += minCellHorSpace;
            }
            
            //set frame
            attr.frame = itemFrame;
    
            [itemsData addObject:attr];
            
        }
        
        [sectionData addObject:itemsData];
        
    }
    
    layoutData = sectionData;
    
    layoutContentSize = CGSizeMake(pages*self.collectionView.bounds.size.width , self.collectionView.bounds.size.height);
    
}

- (CGSize) collectionViewContentSize {
    return layoutContentSize;
}

- (NSArray *) layoutAttributesForElementsInRect:(CGRect) rect {
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (int sectionIndex = 0;sectionIndex < layoutData.count; sectionIndex++) {
        
        NSArray *itemArray = layoutData[sectionIndex];
        
        for (int itemIndex = 0; itemIndex < itemArray.count; itemIndex++) {
            
            UICollectionViewLayoutAttributes *attr = itemArray[itemIndex];
            CGRect intersect = CGRectIntersection(rect, attr.frame);
            
            if (!CGRectIsEmpty(intersect)) {
                [result addObject:attr];
            }
            
        }
        
    }
    
    return result;
    
}

@end
