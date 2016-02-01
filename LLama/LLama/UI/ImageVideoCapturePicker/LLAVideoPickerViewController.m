//
//  LLAVideoPickerViewController.m
//  LLama
//
//  Created by Live on 16/1/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

//controller
#import "LLAVideoPickerViewController.h"
#import "LLAEditVideoViewController.h"

//view
#import "LLACollectionView.h"
#import "LLAVideoPickerTopToolBar.h"
#import "LLALoadingView.h"
#import "LLAVideoPickerCollectionCell.h"
//model
#import "LLAPickVideoItemInfo.h"

//uitl
#import "LLAViewUtil.h"

static const CGFloat topBarHeight = 70;

static const CGFloat cellToHorBorder = 10;
static const CGFloat cellToVerBorder = 17;

static const CGFloat cellsVerSpace = 6;
static const CGFloat cellsHorSpace = 6;

static NSString *cellIdentifier = @"cellIdentifier";

@interface LLAVideoPickerViewController()<LLAVideoPickerTopToolBarDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    LLAVideoPickerTopToolBar *topBar;
    
    LLACollectionView *dataCollectionView;
    
    LLALoadingView *HUD;
    
    NSMutableArray *dataArray;
    
}

@end

@implementation LLAVideoPickerViewController

#pragma mark - Life Cycle

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    [self initVariables];
    [self initTopViews];
    [self initSubViews];
    [self initSubConstraints];
    
    [HUD show:YES];
    [self loadVideoData];
}

#pragma mark - InitVariables

- (void) initVariables {
    dataArray = [NSMutableArray array];
}

- (void) initTopViews {
    topBar = [[LLAVideoPickerTopToolBar alloc] init];
    topBar.translatesAutoresizingMaskIntoConstraints = NO;
    topBar.delegate = self;
    
    [self.view addSubview:topBar];
}

- (void) initSubViews {
    
    // collectionView布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = cellsHorSpace;
    flowLayout.minimumLineSpacing = cellsVerSpace;
    
    // collectionView
    dataCollectionView = [[LLACollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    dataCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    dataCollectionView.delegate = self;
    dataCollectionView.dataSource = self;
    dataCollectionView.bounces = YES;
    dataCollectionView.alwaysBounceVertical = YES;
    dataCollectionView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:dataCollectionView];
    
    [dataCollectionView registerClass:[LLAVideoPickerCollectionCell class] forCellWithReuseIdentifier:cellIdentifier];
    
    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];
    
}

- (void) initSubConstraints {
    
    //
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[topBar(height)]-(0)-[dataCollectionView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"height":@(topBarHeight)}
      views:NSDictionaryOfVariableBindings(topBar,dataCollectionView)]];
    
    //horizonal
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[topBar]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(topBar)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[dataCollectionView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataCollectionView)]];
    
    [self.view addConstraints:constrArray];
    
}

#pragma mark - Load Video Data

- (void) loadVideoData {
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *groupStop) {
            
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
                //video
                
                LLAPickVideoItemInfo *itemInfo = [LLAPickVideoItemInfo new];
                
                itemInfo.thumbImage = [UIImage imageWithCGImage:result.aspectRatioThumbnail];
                itemInfo.videoDuration =[[result valueForProperty:ALAssetPropertyDuration] floatValue];
                itemInfo.videoURL = [result valueForProperty:ALAssetPropertyAssetURL];
                
                [dataArray addObject:itemInfo];
                
                if (groupStop && stop) {
                    
                    [HUD hide:YES];
                    [dataCollectionView reloadData];
                }
                
            }else {
                //photo
                if (stop)
                    [HUD hide:YES];
            }
            
        }];

        
    } failureBlock:^(NSError *error) {
       //failed,has no right to access album
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"没有相机权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    
}

#pragma mark - Status Bar
- (BOOL) prefersStatusBarHidden {
    return YES;
}


#pragma mark - LLAVideoPickerTopToolBarDelegate

- (void) backToPre {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LLAVideoPickerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell updateCellWithInfo:dataArray[indexPath.row]];
    
    return cell;
    
}

#pragma mark - UICollectionViewFlowLayout

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (collectionView.bounds.size.width-2*(cellToHorBorder+cellsHorSpace))/3;
    CGFloat height = [LLAVideoPickerCollectionCell calculateHeightWithInfo:dataArray[indexPath.row] width:width];
    return CGSizeMake(width, height);
    
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(cellToVerBorder, cellToHorBorder, cellToVerBorder, cellToHorBorder);
}

#pragma mark - UICollectionViewDelegate

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //did selected
    
    LLAPickVideoItemInfo *itemInfo = dataArray[indexPath.row];
    
    AVAsset *asset = [AVAsset assetWithURL:itemInfo.videoURL];
    
    LLAEditVideoViewController *editVideo = [[LLAEditVideoViewController alloc] initWithAVAsset:asset];
    
    [self.navigationController pushViewController:editVideo animated:YES];
    
}

@end
