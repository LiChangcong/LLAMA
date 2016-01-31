//
//  TMAlbumPickerViewController.m
//  photoPickerDemo
//
//  Created by tommin on 16/1/29.
//  Copyright © 2016年 tommin. All rights reserved.
//

#import "TMAlbumPickerViewController.h"
#import <Masonry.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZLPhotoAssets.h"
#import "ZLPhotoPickerCollectionViewCell.h"
#import "ZLPhotoPickerImageView.h"
#import "ZLPhotoPickerDatas.h"
//#import "ZLCameraViewController.h"
#import "UIBarButtonItem+TMExtension.h"

@interface TMAlbumPickerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UICollectionView *dataCollectionView;
    
}

// 保存所有的数据
@property (nonatomic , strong) NSArray *dataArray;
// 保存选中的图片
@property (nonatomic , strong) NSMutableArray *selectAssets;
// 最后保存的一次图片
@property (strong,nonatomic) NSMutableArray *lastDataArray;

// 选中的索引值，为了防止重用
@property (nonatomic , strong) NSMutableArray *selectsIndexPath;
// 记录选中的值
@property (assign,nonatomic) BOOL isRecoderSelectPicker;

@property (nonatomic , strong) ZLPhotoPickerGroup *assetsGroup;


@property (nonatomic , strong) NSArray *groups;

// 拍摄的照片
@property (strong,nonatomic) UIImage *shot;

@end

@implementation TMAlbumPickerViewController


- (NSMutableArray *)selectsIndexPath{
    if (!_selectsIndexPath) {
        _selectsIndexPath = [NSMutableArray array];
    }
    
    if (_selectsIndexPath) {
        NSSet *set = [NSSet setWithArray:_selectsIndexPath];
        _selectsIndexPath = [NSMutableArray arrayWithArray:[set allObjects]];
    }
    return _selectsIndexPath;
}


#pragma mark -setter
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
    // 需要记录选中的值的数据
    if (self.isRecoderSelectPicker){
        NSMutableArray *selectAssets = [NSMutableArray array];
        for (ZLPhotoAssets *asset in self.selectAssets) {
            for (ZLPhotoAssets *asset2 in self.dataArray) {
                
                if ([asset isKindOfClass:[UIImage class]] || [asset2 isKindOfClass:[UIImage class]]) {
                    continue;
                }
                if ([asset.asset.defaultRepresentation.url isEqual:asset2.asset.defaultRepresentation.url]) {
                    [selectAssets addObject:asset2];
                    break;
                }
            }
        }
        _selectAssets = selectAssets;
    }
    
    [dataCollectionView reloadData];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
//    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied) {
//        // 判断没有权限获取用户相册的话，就提示个View
//        UIImageView *lockView = [[UIImageView alloc] init];
//        lockView.image = [UIImage imageNamed:@"lock"];
//        lockView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 200);
//        lockView.contentMode = UIViewContentModeCenter;
//        [self.view addSubview:lockView];
//        
//        UILabel *lockLbl = [[UILabel alloc] init];
//        lockLbl.text = @"123";
//        lockLbl.numberOfLines = 0;
//        lockLbl.textAlignment = NSTextAlignmentCenter;
//        lockLbl.frame = CGRectMake(20, 0, self.view.frame.size.width - 40, self.view.frame.size.height);
//        [self.view addSubview:lockLbl];
//    }else{
////        [self tableView];
////        // 获取图片
////        [self getImgs];
//    }

    
    _selectAssets = [NSMutableArray array];
    
    ZLPhotoPickerDatas *datas = [ZLPhotoPickerDatas defaultPicker];
    [datas getAllGroupWithPhotos:^(id obj) {
        
        ZLPhotoPickerGroup *gp = nil;
        for (ZLPhotoPickerGroup *group in obj) {
            NSLog(@"group的名字是%@",group.groupName);
            if ((self.status == PickerViewShowStatusCameraRoll || self.status == PickerViewShowStatusVideo) && ([group.groupName isEqualToString:@"Camera Roll"] || [group.groupName isEqualToString:@"相机胶卷"])) {
                gp = group;
                break;
            }else if (self.status == PickerViewShowStatusSavePhotos && ([group.groupName isEqualToString:@"Saved Photos"] || [group.groupName isEqualToString:@"保存相册"])){
                gp = group;
                break;
            }else if (self.status == PickerViewShowStatusPhotoStream &&  ([group.groupName isEqualToString:@"Stream"] || [group.groupName isEqualToString:@"我的照片流"])){
                gp = group;
                break;
            }
        }
        
        self.assetsGroup = gp;
        
        __block NSMutableArray *assetsM = [NSMutableArray array];
        __weak typeof(self) weakSelf = self;
        
        [[ZLPhotoPickerDatas defaultPicker] getGroupPhotosWithGroup:self.assetsGroup finished:^(NSArray *assets) {
            
            [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL *stop) {
                __block ZLPhotoAssets *zlAsset = [[ZLPhotoAssets alloc] init];
                zlAsset.asset = asset;
                [assetsM addObject:zlAsset];
            }];
            
            weakSelf.dataArray = assetsM;
            NSLog(@"%@",weakSelf.dataArray);
        }];
        
        
    }];
    

//    NSLog(@"assetsGroup %@",self.assetsGroup);
    
    
    // 设置子控件
    [self setUpSubViews];
    
    // 设置约束
    [self setUpConstraints];

//    [self layoutSubviews1];

}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//
//
//}

/*************************************************************/


// 设置子控件
- (void)setUpSubViews
{
    CGFloat itemWidthHeight = (self.view.frame.size.width - 2) / 3;
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.itemSize = CGSizeMake(itemWidthHeight, itemWidthHeight);
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 1;
//    flow.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    
    dataCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
    dataCollectionView.dataSource = self;
    dataCollectionView.delegate = self;
    dataCollectionView.backgroundColor = [UIColor blackColor];
    [dataCollectionView registerClass:[ZLPhotoPickerCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:dataCollectionView];

    
    self.navigationItem.title = @"相册";
    // 设置导航栏背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"] forBarMetrics:UIBarMetricsDefault];
    // 状态栏设置为白色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    // 导航栏左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" highImage:@"backH" target:self action:@selector(back)];
    // 导航栏右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"pickImage_Finish_Normal" highImage:@"pickImage_Finish_Highlight" target:self action:@selector(finish)];
    self.navigationItem.rightBarButtonItem.enabled = NO;

}

// 设置约束
- (void)setUpConstraints
{
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    [dataCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(padding);
    }];
}





#pragma mark - collectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"cell个数 %lu",(unsigned long)self.dataArray.count);
    return self.dataArray.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLPhotoPickerCollectionViewCell *cell = [ZLPhotoPickerCollectionViewCell cellWithCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    
    if(indexPath.item == 0 && self.topShowPhotoPicker){
        UIImageView *imageView = [[cell.contentView subviews] lastObject];
        // 判断真实类型
        if (![imageView isKindOfClass:[UIImageView class]]) {
            imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.clipsToBounds = YES;
            [cell.contentView addSubview:imageView];
        }
        imageView.tag = indexPath.item;
        imageView.image = [UIImage imageNamed:@"takepic"];
    }else{
        ZLPhotoPickerImageView *cellImgView = [[ZLPhotoPickerImageView alloc] initWithFrame:cell.bounds];
        cellImgView.maskViewFlag = YES;
        
        // 需要记录选中的值的数据
        if (self.isRecoderSelectPicker) {
            for (ZLPhotoAssets *asset in self.selectAssets) {
                if ([asset isKindOfClass:[ZLPhotoAssets class]] && [asset.asset.defaultRepresentation.url isEqual:[(ZLPhotoAssets *)self.dataArray[indexPath.item] asset].defaultRepresentation.url]) {
                    [self.selectsIndexPath addObject:@(indexPath.row)];
                }
            }
        }
        
        [cell.contentView addSubview:cellImgView];
        
        cellImgView.maskViewFlag = ([self.selectsIndexPath containsObject:@(indexPath.row)]);
        
        ZLPhotoAssets *asset = self.dataArray[self.dataArray.count - indexPath.item];
        cellImgView.isVideoType = asset.isVideoType;
        if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
            cellImgView.image = asset.aspectRatioImage;
        }
    }
    
    return cell;
}



- (void)setTopShowPhotoPicker:(BOOL)topShowPhotoPicker{
    _topShowPhotoPicker = topShowPhotoPicker;
    
    if (self.topShowPhotoPicker == YES) {
        NSMutableArray *reSortArray= [[NSMutableArray alloc] init];
        for (id obj in [self.dataArray reverseObjectEnumerator]) {
            [reSortArray addObject:obj];
        }
        
        ZLPhotoAssets *zlAsset = [[ZLPhotoAssets alloc] init];
        [reSortArray insertObject:zlAsset atIndex:0];
        
//        self.collectionView.topShowPhotoPicker = topShowPhotoPicker;
        self.dataArray = reSortArray;
        [dataCollectionView reloadData];
    }
}


//- (void)setAssetsGroup:(ZLPhotoPickerGroup *)assetsGroup{
//    if (!assetsGroup.groupName.length) return ;
//    
//    _assetsGroup = assetsGroup;
//    
//    
//    self.title = assetsGroup.groupName;
//    
//    // 获取Assets
//    [self setupAssets];
//}
//
//
//- (void) setupAssets{
//    
//    __block NSMutableArray *assetsM = [NSMutableArray array];
//    __weak typeof(self) weakSelf = self;
//    
//    [[ZLPhotoPickerDatas defaultPicker] getGroupPhotosWithGroup:self.assetsGroup finished:^(NSArray *assets) {
//        
//        [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL *stop) {
//            __block ZLPhotoAssets *zlAsset = [[ZLPhotoAssets alloc] init];
//            zlAsset.asset = asset;
//            [assetsM addObject:zlAsset];
//        }];
//        
//        weakSelf.dataArray = assetsM;
//    }];
//    
//}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.topShowPhotoPicker && indexPath.item == 0) {
        NSUInteger maxCount = (self.maxCount < 0) ? 9 :  self.maxCount;
        if (![self validatePhotoCount:maxCount]){
            return ;
        }
        [self camera];
        return ;
    }
    
    if (!self.lastDataArray) {
        self.lastDataArray = [NSMutableArray array];
    }
    
    ZLPhotoPickerCollectionViewCell *cell = (ZLPhotoPickerCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    
    ZLPhotoAssets *asset = self.dataArray[self.dataArray.count - indexPath.row];
    ZLPhotoPickerImageView *pickerImageView = [cell.contentView.subviews lastObject];
    // 如果没有就添加到数组里面，存在就移除
    if (pickerImageView.isMaskViewFlag) {
        [self.selectsIndexPath removeObject:@(indexPath.row)];
        [self.selectAssets removeObject:asset];
        [self.lastDataArray removeObject:asset];
        


    }else{
        // 1 判断图片数超过最大数或者小于0
        NSUInteger maxCount = (self.maxCount < 0) ? 9 :  self.maxCount;
        if (![self validatePhotoCount:maxCount]){
            return ;
        }
        
        [self.selectsIndexPath addObject:@(indexPath.row)];
        [self.selectAssets addObject:asset];
        [self.lastDataArray addObject:asset];
        
    
    }
    
//    NSLog(@"%d",self.selectAssets.count);
    
    if (self.selectAssets.count) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }

        // 告诉代理现在被点击了!
//    if ([self.collectionViewDelegate respondsToSelector:@selector(pickerCollectionViewDidSelected: deleteAsset:)]) {
//        if (pickerImageView.isMaskViewFlag) {
//            // 删除的情况下
//            [self.collectionViewDelegate pickerCollectionViewDidSelected:self deleteAsset:asset];
//        }else{
//            [self.collectionViewDelegate pickerCollectionViewDidSelected:self deleteAsset:nil];
//        }
//    }
    
    pickerImageView.maskViewFlag = ([pickerImageView isKindOfClass:[ZLPhotoPickerImageView class]]) && !pickerImageView.isMaskViewFlag;
    
}

- (void)camera
{
//    NSLog(@"点击了拍照");
//    ZLCameraViewController *cameraVc = [[ZLCameraViewController alloc] init];
//    __weak typeof(self)weakSelf = self;
//    __weak typeof(cameraVc)weakCameraVc = cameraVc;
//    cameraVc.callback = ^(NSArray *camera){
//        [weakSelf.selectAssets addObjectsFromArray:camera];
////        [weakSelf.toolBarThumbCollectionView reloadData];
////        [weakSelf.takePhotoImages addObjectsFromArray:camera];
//        weakSelf.selectAssets = weakSelf.selectAssets;
//        
//        NSInteger count = self.selectAssets.count;
////        weakSelf.makeView.hidden = !count;
////        weakSelf.makeView.text = [NSString stringWithFormat:@"%ld",(NSInteger)count];
////        weakSelf.doneBtn.enabled = (count > 0);
//        [weakCameraVc dismissViewControllerAnimated:YES completion:nil];
//    };
//    [cameraVc presentViewController:cameraVc animated:YES completion:nil];
    //打开相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        controller.allowsEditing=NO;
//        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
//        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
//        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        controller.videoQuality=UIImagePickerControllerQualityTypeLow;
        
        [self.navigationController presentViewController:controller animated:YES completion:^{
            
        }];
    }else {
    
        NSLog(@"没有摄像头");
    }


}

- (BOOL)validatePhotoCount:(NSInteger)maxCount{
    if (self.selectAssets.count >= maxCount) {
        NSString *format = [NSString stringWithFormat:@"最多只能选择%zd张图片",maxCount];
        if (maxCount == 0) {
            format = [NSString stringWithFormat:@"您已经选满了图片了."];
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:format delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alertView show];
        return NO;
    }
    return YES;
}


#pragma mark -- 相机拍照回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        //保存图片
//        [SVProgressHUD showWithStatus:@"处理中..." maskType:SVProgressHUDMaskTypeClear];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage * image =[info objectForKey:UIImagePickerControllerOriginalImage];
            
//            [self.dataArray ];
            NSLog(@"点击了选择");
            self.shot = image;
            self.callBack1(_shot);
            [self dismissViewControllerAnimated:YES completion:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"点击了取消");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)finish
{
    self.callBack(_lastDataArray);
    [self dismissViewControllerAnimated:YES completion:nil];

}

//- (void)layoutSubviews1{
//    
////    [super layoutSubviews];
//    
//    // 时间置顶的话
////    if (self.status == ZLPickerCollectionViewShowOrderStatusTimeDesc) {
////        if (!self.firstLoadding && self.contentSize.height > [[UIScreen mainScreen] bounds].size.height) {
//            // 滚动到最底部（最新的）
//            [dataCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.dataArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
//            [dataCollectionView reloadData];
//            // 展示图片数
////            self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y + 100);
////            self.firstLoadding = YES;
////        }
////    }else if (self.status == ZLPickerCollectionViewShowOrderStatusTimeAsc){
////        // 滚动到最底部（最新的）
////        if (!self.firstLoadding && self.contentSize.height > [[UIScreen mainScreen] bounds].size.height) {
////            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
////            // 展示图片数
////            self.contentOffset = CGPointMake(self.contentOffset.x, -self.contentInset.top);
////            self.firstLoadding = YES;
////        }
////    }
//}



@end
