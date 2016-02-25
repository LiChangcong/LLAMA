//
//  LLASearchResultViewController.m
//  LLama
//
//  Created by tommin on 16/2/24.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLASearchResultViewController.h"

#import "LLAZoomCollectionView.h"

// cell
#import "LLAHotUsersCell.h"
#import "LLASearchResultsVideoCell.h"

// controller
#import "TMZoomController.h"
#import "LLAHotVideosHeader.h"
#import "LLAHotUsersViewController.h"
#import "LLASearchResultViewController.h"


static const CGFloat zoomCellsHorSpace = 6;
static const CGFloat zoomCellsVerSpace = 6;


//section index
static const NSInteger hotUsersIndex = 0;
static const NSInteger hotVideosIndex = 1;

// cell registerID
static NSString *const hotUsersCellIden = @"hotUsersCellIden";
static NSString *const searchResultsVideoCellIden = @"searchResultsVideoCellIden";
static NSString *const hotVideosHeaderIden = @"hotVideosHeaderIden";


@interface LLASearchResultViewController ()<UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    UISearchBar *searchResultBar;
    
    LLAZoomCollectionView *dataCollectionView;
    
    UIButton *shadeButton;
    

}
@end

@implementation LLASearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 背景色
    self.view.backgroundColor = [UIColor colorWithHex:0x1e1d28];

    // 设置
//    [self initVariables];
    [self initSubViews];
    [self initSubConstraints];

    self.navigationItem.leftBarButtonItem = nil;
    
    
}

//- (void)initVariables
//{
//
//}

- (void)initSubViews
{
    // searchResultBar
    searchResultBar = [[UISearchBar alloc] init];
    searchResultBar.text = _searchResultText;
    searchResultBar.showsCancelButton = YES;
    searchResultBar.delegate = self;
    //    [searchResultBar becomeFirstResponder];
    self.navigationItem.titleView = searchResultBar;
    
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
    dataCollectionView.showsHorizontalScrollIndicator = NO;
    dataCollectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:dataCollectionView];
    
    
    // 注册cell
    [dataCollectionView registerClass:[LLAHotUsersCell class] forCellWithReuseIdentifier:hotUsersCellIden];
    [dataCollectionView registerClass:[LLASearchResultsVideoCell class] forCellWithReuseIdentifier:searchResultsVideoCellIden];
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
//    [self searchBarCancelButtonClicked:searchResultBar];
    [searchResultBar resignFirstResponder];
    shadeButton.hidden = YES;
}

- (void)initSubConstraints
{
    
    
    // dataCollectionView
    [dataCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - 点击了搜索bar的取消按钮

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    shadeButton.hidden = NO;
    
    [searchBar setShowsCancelButton:YES animated:NO];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{

    //
    
    searchResultBar.text = @"";
    //    searchBar.showsCancelButton = NO;
    [searchResultBar setShowsCancelButton:NO animated:YES];
    [searchResultBar resignFirstResponder];
//    _isFiltered = FALSE;
    [self.navigationController popViewControllerAnimated:YES];

}


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

    if (indexPath.section == hotUsersIndex) {
        
        LLAHotUsersCell *hotUsersCell = [dataCollectionView dequeueReusableCellWithReuseIdentifier:hotUsersCellIden forIndexPath:indexPath];
        //        hotUsers.delegate = self;
        [hotUsersCell updateInfo];
        // 设置数据
        //        [hotUsers updateCellWithInfo:scriptInfo maxWidth:collectionView.frame.size.width];
        return hotUsersCell;
        
    }else {

        
        LLASearchResultsVideoCell *searchResultsVideoCell = [dataCollectionView dequeueReusableCellWithReuseIdentifier:searchResultsVideoCellIden forIndexPath:indexPath];
        
        // 设置数据
        //        [hotVideos updateCellWithUserInfo:scriptInfo.partakeUsersArray[indexPath.row]];
        return searchResultsVideoCell;
    }
    
    
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //header footer
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if (indexPath.section == hotUsersIndex) {
            
            LLAHotVideosHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:hotVideosHeaderIden forIndexPath:indexPath];
            //            header.headerText = @"热门用户";
            [header updateHeaderText:@"相关用户"];
            return header;
        } else {
            // 热门视频header
            LLAHotVideosHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:hotVideosHeaderIden forIndexPath:indexPath];
            //            header.headerText = @"热门视频";
            [header updateHeaderText:@"相关视频"];
            return header;
        }
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        return nil;
    }else {
        return nil;
    }
}


#pragma mark - UICollectionViewFlowLayout
// item的大小
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == hotUsersIndex) {
        
        return CGSizeMake(self.view.frame.size.width, 60);
        
    }else {
        
        
        CGFloat itemWidth = collectionView.frame.size.width;
        return CGSizeMake(itemWidth, itemWidth);
        
    }
    
}
// item的内边距
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (section == hotUsersIndex) {
        
        return UIEdgeInsetsZero;
    }else{
        
        return UIEdgeInsetsZero;

    }
}

// 每个header
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == hotUsersIndex) {
        
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
        LLAHotUsersViewController *resultUsers = [[LLAHotUsersViewController alloc] init];
        resultUsers.userType = UserTypeIsResultsUsers;
        [self.navigationController pushViewController:resultUsers animated:YES];
        
    }else{
        
        NSLog(@"%d,%d",indexPath.section, indexPath.row);
        
    }
    
    
}




@end
