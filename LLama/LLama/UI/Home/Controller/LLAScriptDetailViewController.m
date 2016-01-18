//
//  LLAScriptDetailViewController.m
//  LLama
//
//  Created by Live on 16/1/17.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAScriptDetailViewController.h"

//view

#import "LLACollectionView.h"

@interface LLAScriptDetailViewController()<UICollectionViewDataSource,UICollectionViewDelegate>

{
    LLACollectionView *dataCollectionView;
}

@end

@implementation LLAScriptDetailViewController

#pragma mark - Life Cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Init

- (void) initNavigationItems {
    
}

- (void) initSubView {
    
    
}


#pragma mark - Load Data

- (void) loadData {
    
}

- (void) loadMoreData {
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else {
        return 0;
    }
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
