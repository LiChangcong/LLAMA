//
//  LLAZoomViewController.m
//  LLama
//
//  Created by tommin on 16/2/22.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAZoomViewController.h"

// view
#import "LLASearchBar.h"
#import "LLAZoomCollectionView.h"

// cell
#import "LLAHotUsersCell.h"
#import "LLAHotVideosCell.h"

// controller
#import "TMZoomController.h"
#import "LLAHotVideosHeader.h"
#import "LLAHotUsersViewController.h"
#import "LLASearchResultViewController.h"

static const CGFloat zoomCellsHorSpace = 6;
static const CGFloat zoomCellsVerSpace = 6;

static const CGFloat hotVideoCellsHorSpace = 6;
static const CGFloat hotVideoCellsVerSpace = 6;



//section index
static const NSInteger hotUsersIndex = 0;
static const NSInteger hotVideosIndex = 1;

// cell registerID
static NSString *const hotUsersCellIden = @"hotUsersCellIden";
static NSString *const hotVideosCellIden = @"hotVideosCellIden";
static NSString *const hotVideosHeaderIden = @"hotVideosHeaderIden";


@interface LLAZoomViewController () <UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    LLASearchBar *headSearchBar;
    
    LLAZoomCollectionView *dataCollectionView;

    UISearchDisplayController *searchController;
    
    // 点击搜索时候产生一个遮盖
    UIButton *shadeButton;
}

@property (nonatomic, assign) bool isFiltered;


@end

@implementation LLAZoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHex:0x1e1d28];
    
    // 设置变量
    [self initVariables];
    // 设置子控件
    [self initSubViews];
    // 设置约束
    [self initSubConstraints];

}

// 设置变量
- (void)initVariables
{

    
}

// 设置子控件
- (void)initSubViews
{
    // headSearchBar
    headSearchBar = [[LLASearchBar alloc] init];
    headSearchBar.placeholder = @"搜索";
    headSearchBar.delegate = self;
    self.navigationItem.titleView = headSearchBar;

    
    // dataCollectionView布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = zoomCellsHorSpace;
    flowLayout.minimumLineSpacing = zoomCellsVerSpace;
    
    // dataCollectionView
    dataCollectionView = [[LLAZoomCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    dataCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    dataCollectionView.dataSource = self;
    dataCollectionView.delegate = self;
    dataCollectionView.bounces = YES;
    dataCollectionView.backgroundColor = [UIColor colorWithHex:0x1e1d28];
    [self.view addSubview:dataCollectionView];
    
    // 注册cell
    [dataCollectionView registerClass:[LLAHotUsersCell class] forCellWithReuseIdentifier:hotUsersCellIden];
    [dataCollectionView registerClass:[LLAHotVideosCell class] forCellWithReuseIdentifier:hotVideosCellIden];
//    [dataCollectionView registerClass:[LLAHotVideosHeader class] forCellWithReuseIdentifier:hotVideosHeaderIden];
    [dataCollectionView registerClass:[LLAHotVideosHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:hotVideosHeaderIden];


    // 使用button生成一个遮盖
    shadeButton = [[UIButton alloc] init];
    shadeButton.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    shadeButton.backgroundColor = [UIColor lightGrayColor];
    shadeButton.alpha = 0.1;
    [shadeButton addTarget:self action:@selector(shadeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    shadeButton.hidden = YES;
    [self.view addSubview:shadeButton];


}

- (void)shadeButtonClicked
{
    [self searchBarCancelButtonClicked:headSearchBar];
}

// 设置约束
- (void)initSubConstraints
{
    [dataCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}


#pragma mark - UISearchBarDelegate


#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == hotUsersIndex) {
        
        return 1;
        
    }else if(section == hotVideosIndex){
    
        return 5;
        
    }else {
        
        return 0;
    }
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 第一组显示基本详情，第二组显示报名演员
    if (indexPath.section == hotUsersIndex) {
        
        LLAHotUsersCell *hotUsersCell = [dataCollectionView dequeueReusableCellWithReuseIdentifier:hotUsersCellIden forIndexPath:indexPath];
//        hotUsers.delegate = self;
        [hotUsersCell updateInfo];
        // 设置数据
//        [hotUsers updateCellWithInfo:scriptInfo maxWidth:collectionView.frame.size.width];
        return hotUsersCell;
        
    }else {
        LLAHotVideosCell *hotVideosCell = [dataCollectionView dequeueReusableCellWithReuseIdentifier:hotVideosCellIden forIndexPath:indexPath];
//        hotVideos.delegate = self;
        
        // 设置数据
//        [hotVideos updateCellWithUserInfo:scriptInfo.partakeUsersArray[indexPath.row]];
        return hotVideosCell;
    }

    
}


- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //header footer
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if (indexPath.section == hotUsersIndex) {
            
            LLAHotVideosHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:hotVideosHeaderIden forIndexPath:indexPath];
//            header.headerText = @"热门用户";
            [header updateHeaderText:@"热门用户"];
            return header;
        } else {
            // 热门视频header
            LLAHotVideosHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:hotVideosHeaderIden forIndexPath:indexPath];
//            header.headerText = @"热门视频";
            [header updateHeaderText:@"热门视频"];
            return header;
        }
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        return nil;
    }else {
        return nil;
    }
}
#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    shadeButton.hidden = NO;
    
    [searchBar setShowsCancelButton:YES animated:NO];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{

    //
    shadeButton.hidden = YES;

    searchBar.text = @"";
//    searchBar.showsCancelButton = NO;
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    _isFiltered = FALSE;

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{


        LLASearchResultViewController *searchResult = [[LLASearchResultViewController alloc] init];
        searchResult.searchResultText = headSearchBar.text;
        [self.navigationController pushViewController:searchResult animated:YES];

    shadeButton.hidden = YES;
    headSearchBar.text = @"";
    [headSearchBar resignFirstResponder];

    
}

#pragma mark - UICollectionViewFlowLayout
// item的大小
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == hotUsersIndex) {
//
        return CGSizeMake(self.view.frame.size.width, 60);
//
    }else {
    
        CGFloat itemWidth = (collectionView.frame.size.width - 3*hotVideoCellsHorSpace)/2;
        
        CGFloat itemHeight = [LLAHotVideosCell calculateHeightWitthUserInfo:nil maxWidth:itemWidth];
        return CGSizeMake(itemWidth, itemHeight);

    }
    
}
// item的内边距
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (section == hotUsersIndex) {
        // 如果是上面这一句就会有警告
//        return UIEdgeInsetsMake(0, hotVideoCellsHorSpace, 6, hotVideoCellsHorSpace);
        return UIEdgeInsetsZero;
        
    }else{
        
        return UIEdgeInsetsMake(0, hotVideoCellsHorSpace, 6, hotVideoCellsHorSpace);
    }
}

// 每个header
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == hotUsersIndex) {
        
//        return CGSizeZero;
        return CGSizeMake(collectionView.frame.size.width, 31);

    }else {
        
        return CGSizeMake(collectionView.frame.size.width, 31);
    }
}

#pragma mark - collectionViewDelegate

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 选演员
    if (indexPath.section == hotUsersIndex) {
        
        // 热门用户
        LLAHotUsersViewController *hotUsers = [[LLAHotUsersViewController alloc] init];
        [self.navigationController pushViewController:hotUsers animated:YES];
        
    }else{
    
    }
    
    
}

@end
