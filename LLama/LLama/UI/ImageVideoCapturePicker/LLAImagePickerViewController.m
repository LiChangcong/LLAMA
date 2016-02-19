//
//  LLAImagePickerViewController.m
//  LLama
//
//  Created by Live on 16/1/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

//controller

#import "LLAImagePickerViewController.h"

//view
#import "LLACollectionView.h"
#import "LLALoadingView.h"
#import "LLAImagePickerTopToolBar.h"
#import "LLAImagePickerCollectionCell.h"
#import "LLACameraCell.h"
//model
#import "LLAPickImageItemInfo.h"

//uitl
#import "LLAViewUtil.h"


#import "TMPostScriptViewController.h"
#import "LLABaseNavigationController.h"

static const CGFloat topBarHeight = 70;
static const CGFloat cellToHorBorder = 10;
static const CGFloat cellToVerBorder = 17;
static const CGFloat cellsVerSpace = 6;
static const CGFloat cellsHorSpace = 6;

static NSString *cellIdentifier = @"cellIdentifier";
static NSString *cameraIdentifier = @"cameraIdentifier";

@interface LLAImagePickerViewController()<LLAImagePickerTopToolBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LLAImagePickerCollectionCellDelegate, LLACameraCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    LLAImagePickerTopToolBar *topBar;

    LLACollectionView *dataCollectionView;
    
    LLALoadingView *HUD;
    
    NSMutableArray *dataArray;
}

@property (nonatomic, strong) LLAPickImageItemInfo *currentPickImgItemInfo;


@end

@implementation LLAImagePickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initVariables];
    [self initTopViews];
    [self initSubViews];
    [self initSubConstraints];
    
    [HUD show:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadImagesData];
    });

}

#pragma mark - InitVariables

- (void) initVariables {
    dataArray = [NSMutableArray array];
}

- (void) initTopViews {

    topBar = [[LLAImagePickerTopToolBar alloc] init];
    topBar.translatesAutoresizingMaskIntoConstraints = NO;
    topBar.delegate = self;
//    topBar.determineButton.enabled = NO;
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
    
    [dataCollectionView registerClass:[LLAImagePickerCollectionCell class] forCellWithReuseIdentifier:cellIdentifier];
    [dataCollectionView registerClass:[LLACameraCell class] forCellWithReuseIdentifier:cameraIdentifier];

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

#pragma mark - Load Image Data

- (void) loadImagesData {
    
    if (NSClassFromString(@"PHPhotoLibrary")) {
        //ios 8 and later
        
        if ([PHPhotoLibrary authorizationStatus] ==  PHAuthorizationStatusDenied) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"没有相机权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
            
        }
        
        PHFetchOptions *onlyOptions = [PHFetchOptions new];
        onlyOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %i", PHAssetMediaTypeImage];
        onlyOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];

        
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary  options:nil];
        [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
            
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:onlyOptions];
            if (assetsFetchResult.count > 0) {
                
                [assetsFetchResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
                    if (asset != nil) {
                        
                        PHImageRequestOptions *options = [PHImageRequestOptions new];
                        options.synchronous = YES;
                        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                        options.resizeMode = PHImageRequestOptionsResizeModeNone;
                        if (asset.pixelHeight > 4000 || asset.pixelWidth > 4000) {
                            options.resizeMode = PHImageRequestOptionsResizeModeFast;
                        }
                        
                        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
                        
                        [imageManager requestImageForAsset:asset
                                                    targetSize:CGSizeMake(321/3, 321/3)//targetSize:CGSizeMake(321/3, 321/3)
                                                    contentMode:PHImageContentModeAspectFill
                                                        options:options
                                                  resultHandler:^(UIImage *result, NSDictionary *info) {

                                                      UIImage *img = result;
                                                      
                                                      LLAPickImageItemInfo *itemInfo = [LLAPickImageItemInfo new];
                                                      itemInfo.thumbImage = img;
                                                      
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [dataArray addObject:itemInfo];
                                                          [dataCollectionView reloadData];
                                                          [HUD hide:YES];
                                                      });


                                                  }];
                        

                    }
                }];

                *stop = YES;
            }
        }];

        
        
    }else {
        
        //ios 7
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *groupStop) {
                
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    //photo
                    
                    LLAPickImageItemInfo *itemInfo = [LLAPickImageItemInfo new];
                    
                    itemInfo.thumbImage = [UIImage imageWithCGImage:result.aspectRatioThumbnail];
                    
                    [dataArray addObject:itemInfo];
                    
                    if (groupStop && stop) {
                        
                        [HUD hide:YES];
                        [dataCollectionView reloadData];
                    }
                    
                }else {
                    //video
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
    
    
//    if (self.status == PickerImgOrHeadStatusImg) {
//        
//
//        [self dismissViewControllerAnimated:YES completion:^{
//            
//            TMPostScriptViewController *postS = [[TMPostScriptViewController alloc] init];
//            
//            postS.scriptType = LLAPublishScriptType_Image;
//            
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[LLABaseNavigationController alloc] initWithRootViewController:postS] animated:YES completion:nil];
//            //        [self presentViewController:postS animated:YES completion:nil];
//            
//
//        }];
//        
//
//    } else {
    
        [self dismissViewControllerAnimated:YES completion:nil];
//    }
}


#pragma mark - UICollectionViewDataSource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return dataArray.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        LLACameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cameraIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        return cell;

    }else {
//        if (indexPath.row >= 1) {
            LLAImagePickerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.delegate = self;
            cell.indexPath = indexPath;
            [cell updateCellWithInfo:dataArray[indexPath.row - 1]];

//        }
        return cell;

    }
    
//    return cell;
    
}

#pragma mark - UICollectionViewFlowLayout

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (collectionView.bounds.size.width-2*(cellToHorBorder+cellsHorSpace))/3;
    CGFloat height = [LLAImagePickerCollectionCell calculateHeightWithInfo:dataArray[indexPath.row] width:width];
    return CGSizeMake(width, height);
    
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(cellToVerBorder, cellToHorBorder, cellToVerBorder, cellToHorBorder);
}

#pragma mark - LLAImagePickerCollectionCellDelegate

- (void)LLAImagePickerCollectionCellDidClickSelectedButton:(LLAImagePickerCollectionCell *)imagePickerCollectionCell andIndexPath:(NSIndexPath *)indexPath andButtonIsSelected:(BOOL)isSelected
{

    LLAPickImageItemInfo *iteminfo = dataArray[indexPath.row - 1];
    iteminfo.IsSelected = !iteminfo.IsSelected;
    
    NSLog(@"%d",indexPath.row);
    
    if (iteminfo.IsSelected) { // 选中状态
        // 之前保存选中状态的模型变成非选中状态
        _currentPickImgItemInfo.IsSelected = NO;
        // 把新的为选中状态的图片存到选中模型
        _currentPickImgItemInfo = iteminfo;
        [dataCollectionView reloadData];
    }else {
        _currentPickImgItemInfo = nil;
        [dataCollectionView reloadData];

    }
    
    if (_currentPickImgItemInfo) {

        topBar.determineButtonFaceToPublich.enabled = YES;
    }else {

        topBar.determineButtonFaceToPublich.enabled = NO;

    }

}

#pragma mark - LLACameraCellDelegate
- (void)LLACameraCellDidClickCameraCell:(LLACameraCell *)cameraCell
{

    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        controller.allowsEditing=NO;
        controller.delegate = self;
        controller.videoQuality=UIImagePickerControllerQualityTypeLow;
        
        [HUD show:YES];

        [self presentViewController:controller animated:YES completion:^{
            [HUD hide:YES];

        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage * image =[info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        LLAPickImageItemInfo *itemInfo = [[LLAPickImageItemInfo alloc] init];
        itemInfo.thumbImage = image;
        _currentPickImgItemInfo = itemInfo;

        
        if (self.status == PickerImgOrHeadStatusImg) {

    //        self.callBack(_currentPickImgItemInfo);
            if (self.PickerTimesStatus == PickerTimesStatusOne) {
                [self dismissViewControllerAnimated:YES completion:nil];

                TMPostScriptViewController *postS = [[TMPostScriptViewController alloc] init];
                postS.scriptType = LLAPublishScriptType_Image;
                postS.pickImgInfo = _currentPickImgItemInfo;
                
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[LLABaseNavigationController alloc] initWithRootViewController:postS] animated:YES completion:nil];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
                self.callBack(_currentPickImgItemInfo);

        }
        }else {
            [self dismissViewControllerAnimated:YES completion:nil];
            self.callBack(_currentPickImgItemInfo);

        }
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            //保存图片到相册
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            } completionHandler:^(BOOL success, NSError *error) {
                
                if (success) {
                    // 保存照片成功
                }
                
            }];

        });

        [self dismissViewControllerAnimated:YES completion:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];

    }];

        

}

/*
#pragma mark - UICollectionViewDelegate

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //did selected
    
    LLAPickImageItemInfo *itemInfo = dataArray[indexPath.row];
    
    AVAsset *asset = [AVAsset assetWithURL:itemInfo.videoURL];
    
    LLAEditVideoViewController *editVideo = [[LLAEditVideoViewController alloc] initWithAVAsset:asset];
    
    [self.navigationController pushViewController:editVideo animated:YES];
    
}
*/

#pragma mark - 点击确定按钮

- (void)LLAImagePickerTopToolBarDidClickDetermineButton:(LLAImagePickerTopToolBar *)imagePickerTopToolBar
{
    
    if (self.status == PickerImgOrHeadStatusImg) {
        
        
        if (self.PickerTimesStatus == PickerTimesStatusOne) {

            
            [self dismissViewControllerAnimated:YES completion:nil];
                
            TMPostScriptViewController *postS = [[TMPostScriptViewController alloc] init];
            
            postS.scriptType = LLAPublishScriptType_Image;
            
            
            postS.pickImgInfo = _currentPickImgItemInfo;
            
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[LLABaseNavigationController alloc] initWithRootViewController:postS] animated:YES completion:nil];
            //        [self presentViewController:postS animated:YES completion:nil];
            
            
            //            self.callBack(_currentPickImgItemInfo);
                
                
        

        }else if(self.PickerTimesStatus == PickerTimesStatusTwo){
            [self dismissViewControllerAnimated:YES completion:nil];
            self.callBack(_currentPickImgItemInfo);
            
            
        }

        
        
    } else {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        self.callBack(_currentPickImgItemInfo);
    }

}

@end
