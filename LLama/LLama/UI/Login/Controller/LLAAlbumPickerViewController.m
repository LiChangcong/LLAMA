//
//  LLAAlbumPickerViewController.m
//  LLama
//
//  Created by tommin on 16/1/19.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAAlbumPickerViewController.h"
#import <Photos/Photos.h>
#import <Masonry.h>
#import "LLAAlbumPickerCell.h"

@interface LLAAlbumPickerViewController ()<LLAAlbumPickerCellDelegate,UICollectionViewDataSource>
{
    UICollectionView * __collectionView;
    CGSize size;
    
}
@property (strong) PHImageManager *imageManager;

// 记录选中的assets
@property (nonatomic , strong) LLAAlbumPickerCell *selectdCell;

// 保存所有的数据
@property (nonatomic , strong) NSMutableArray *dataArray;

@end

@implementation LLAAlbumPickerViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.selectdCell = nil;
    
    self.imageManager = [PHImageManager defaultManager];
    
    [self setUpNav];
    self.view.backgroundColor = [UIColor redColor];
    
    [self setUpCollectionView];

}

- (void)setUpNav
{
    self.navigationItem.title = @"相册";
    // 设置导航栏背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"] forBarMetrics:UIBarMetricsDefault];
    // 状态栏设置为白色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    // 导航栏左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" highImage:@"backH" target:self action:@selector(back)];
    // 导航栏右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"okyellow" highImage:@"okyellow" target:self action:@selector(finish)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
}
- (void)setUpCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWH = self.view.frame.size.width / 3;
    flowLayout.itemSize = CGSizeMake(itemWH, itemWH);
    size = flowLayout.itemSize;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    //    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    __collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.view addSubview:__collectionView];
    __collectionView.backgroundColor = [UIColor whiteColor];
    [__collectionView registerClass:[LLAAlbumPickerCell class] forCellWithReuseIdentifier:@"albumCell"];
    [__collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    __collectionView.dataSource = self;
    
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    PHFetchOptions *onlyOptions = [PHFetchOptions new];
    onlyOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %i", PHAssetMediaTypeImage];
    onlyOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary  options:nil];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:onlyOptions];
        if (assetsFetchResult.count > 0) {
            [assetsFetchResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
                if (asset != nil) {
                    [self.dataArray addObject:asset];
                }
            }];
        }
    }];
    
    return self.dataArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    LLAAlbumPickerCell *aCell =[collectionView dequeueReusableCellWithReuseIdentifier:@"albumCell" forIndexPath:indexPath];
    aCell.delegate = self;
    aCell.indexPath = indexPath;
    
    if(indexPath.row == 0){
        [aCell setBtnImgHidden:YES];
        UIButton * btnCamara =[UIButton buttonWithType:UIButtonTypeCustom];
        [btnCamara setBackgroundImage:[UIImage imageNamed:@"takepic"] forState:UIControlStateNormal];
        [btnCamara setBackgroundImage:[UIImage imageNamed:@"takepich"] forState:UIControlStateHighlighted];
        [btnCamara addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
        [aCell addSubview:btnCamara];
        [btnCamara mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(aCell.imageView.mas_centerX);
            make.centerY.equalTo(aCell.imageView.mas_centerY);
            make.width.equalTo(aCell.imageView.mas_width);
            make.height.equalTo(aCell.imageView.mas_height);
        }];
        
    }else{
        
        
        PHImageRequestOptions *options = [PHImageRequestOptions new];
        options.synchronous = YES;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        PHAsset *asset = _dataArray[indexPath.row - 1];
        [self.imageManager requestImageForAsset:asset
                                     targetSize:size
                                    contentMode:PHImageContentModeAspectFill
                                        options:options
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      
                                      aCell.imageView.image = result;
                                      options.resizeMode = PHImageRequestOptionsResizeModeNone;
                                      
                                  }];
        
        
    }
    return aCell;
    
    
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, -1, 0, 0);
}

#pragma mark - LLAPhotoPickerCellDelegate
- (void)selectImage:(LLAAlbumPickerCell *)albumCell indexPath:(NSIndexPath *)indexPath forSelected:(BOOL)selected
{

    if (self.selectdCell) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
    if (self.selectdCell == nil) {
        self.selectdCell = albumCell;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        return;
    }
    
    if (albumCell.indexPath != self.selectdCell.indexPath ) {
        
        [albumCell setSelected:YES];
        [self.selectdCell setSelected:NO];
        self.selectdCell = albumCell;
    }else{
        self.selectdCell = nil;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    
}

#pragma mark - 按钮事件处理
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)finish
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName: @"PICKER_TAKE_DONE" object:nil userInfo:@{@"selectAssets":self.selectdCell.imageView.image}];
    });
    NSLog(@"%@",self.selectdCell.imageView.image);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)takePhoto
{
    TMLog(@"点击了拍照");
}


@end
