//
//  LLAVideoPickerViewController.m
//  LLama
//
//  Created by Live on 16/1/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>

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
#import "LLAPickImageManager.h"

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
    
    [self.view bringSubviewToFront:topBar];
    
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
    
    if (NSClassFromString(@"PHPhotoLibrary")) {
        //ios 8 and later
        
        if ([PHPhotoLibrary authorizationStatus] ==  PHAuthorizationStatusDenied) {
            
            [HUD hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"没有相机权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;


        }
        
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",PHAssetMediaTypeVideo];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];

        //
            for (int i=0; i<assetsFetchResults.count;i++) {
            //
            PHAsset *asset = assetsFetchResults[i];
            
            if (asset.mediaType != PHAssetMediaTypeVideo) {
                continue;
            }
            
            LLAPickVideoItemInfo *itemInfo = [LLAPickVideoItemInfo new];
            itemInfo.videoDuration = asset.duration;
            itemInfo.asset = asset;
            [dataArray addObject:itemInfo];
            
//            [imageManager requestAVAssetForVideo:asset options:PHVideoRequestOptionsDeliveryModeAutomatic resultHandler:^(AVAsset * _Nullable videoAsset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
//                
////                if (i== assetsFetchResults.count-1) {
////                    dispatch_async(dispatch_get_main_queue(), ^{
////                        [HUD hide:YES];
////
////                    });
////                }
//                
//                if (videoAsset && [videoAsset isKindOfClass:[AVURLAsset class]]) {
//                    
//                        AVURLAsset *urlAsset = (AVURLAsset *) videoAsset;
//                    
//                        AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:videoAsset];
//                        imageGenerator.appliesPreferredTrackTransform = YES;
//                        
//                        CMTime time = kCMTimeZero;
//                        CMTime actualTime;
//                        
//                        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:nil];
//                        UIImage *thumbImage = [UIImage imageWithCGImage:imageRef];
//                        
//                        itemInfo.videoURL = urlAsset.URL;
//                        itemInfo.thumbImage = thumbImage;
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [dataCollectionView reloadData];
//                    });
//
//                    
//                }else {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        [dataArray removeObject:itemInfo];
//                        [dataCollectionView reloadData];
//                    });
//
//                }
//                
//                
//            }];
            
            
            
            
            //
            
            
        }
        [dataCollectionView reloadData];
        [HUD hide:YES];
        
        
    }else {
        
        //ios 7
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *groupStop) {
                
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
                    //video
                    
                    LLAPickVideoItemInfo *itemInfo = [LLAPickVideoItemInfo new];
                    
                    //itemInfo.thumbImage = [UIImage imageWithCGImage:result.aspectRatioThumbnail];
                    itemInfo.videoDuration =[[result valueForProperty:ALAssetPropertyDuration] floatValue];
                    //itemInfo.videoURL = [result valueForProperty:ALAssetPropertyAssetURL];
                    itemInfo.asset = result;
                    
                    [dataArray insertObject:itemInfo atIndex:0];
                    
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"没有相机权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];

            });
            
        }];

    }

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
    
    //
    if (itemInfo.videoDuration < 5) {
        [LLAViewUtil showAlter:self.view withText:@"你选的片太短了"];
        return;
    }
    
    //read asset from info
    
    [HUD show:NO];
    
    [[LLAPickImageManager shareManager] avAssetFromaAsset:itemInfo.asset completion:^(AVAsset *avAsset, NSDictionary *info) {
        [HUD hide:NO];
        
        if (!avAsset) {
            
            [LLAViewUtil showAlter:self.view withText:@"无效的视频"];
            return;
        }
        
        LLAEditVideoViewController *editVideo = [[LLAEditVideoViewController alloc] initWithAVAsset:avAsset];
        
        [self.navigationController pushViewController:editVideo animated:YES];
        
    }];
    
    
    
    
}

@end
