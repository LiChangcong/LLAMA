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
#import "LLASearchResultsViewController.h"

#import "LLAHotUserInfo.h"
#import "LLAHotVideoInfo.h"

#import "LLALoadingView.h"
#import "LLAHttpUtil.h"
#import "LLAViewUtil.h"

static const CGFloat zoomCellsHorSpace = 6;
static const CGFloat zoomCellsVerSpace = 6;

static const CGFloat hotVideoCellsHorSpace = 6;



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
    
    LLALoadingView *HUD;

    //
    NSMutableArray *hotUsersArray;
    NSMutableArray *hotVideosArray;
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
    
    // 显示菊花
    [HUD show:YES];
    
    // 刷新数据
    [self loadData];

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
    dataCollectionView.showsHorizontalScrollIndicator = NO;
    dataCollectionView.showsVerticalScrollIndicator = NO;
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

    // 假数据
    hotUsersArray = [NSMutableArray array];
    LLAHotUserInfo *hotUserInfo1 = [[LLAHotUserInfo alloc] init];
    hotUserInfo1.hotUser = [[LLAUser alloc] init];
    hotUserInfo1.hotUser.userName = @"聪聪";
    hotUserInfo1.hotUser.headImageURL = @"http://pic13.nipic.com/20110415/1347158_132411659346_2.jpg";
    hotUserInfo1.hotUser.userDescription = @"我是很帅气很可爱很温柔的小哥";
    hotUserInfo1.hotUser.gender = UserGender_Male;
    hotUserInfo1.attentionType = LLAAttentionType_NotAttention;
    [hotUsersArray addObject:hotUserInfo1];
    
    LLAHotUserInfo *hotUserInfo2 = [[LLAHotUserInfo alloc] init];
    hotUserInfo2.hotUser = [[LLAUser alloc] init];
    hotUserInfo2.hotUser.userName = @"tommin";
    hotUserInfo2.hotUser.headImageURL = @"http://pic13.nipic.com/20110415/1347158_132411659346_2.jpg";
    hotUserInfo2.hotUser.userDescription = @"你猜你猜，你再猜";
    hotUserInfo2.hotUser.gender = UserGender_Female;
    hotUserInfo2.attentionType = LLAAttentionType_AllAttention;
    [hotUsersArray addObject:hotUserInfo2];

    
    LLAHotUserInfo *hotUserInfo3 = [[LLAHotUserInfo alloc] init];
    hotUserInfo3.hotUser = [[LLAUser alloc] init];
    hotUserInfo3.hotUser.userName = @"Money";
    hotUserInfo3.hotUser.headImageURL = @"http://pic13.nipic.com/20110415/1347158_132411659346_2.jpg";
    hotUserInfo3.hotUser.userDescription = @"我是良民呀";
    hotUserInfo3.hotUser.gender = UserGender_Female;
    hotUserInfo3.attentionType = LLAAttentionType_HasAttention;
    [hotUsersArray addObject:hotUserInfo3];

    
    LLAHotUserInfo *hotUserInfo4 = [[LLAHotUserInfo alloc] init];
    hotUserInfo4.hotUser = [[LLAUser alloc] init];
    hotUserInfo4.hotUser.userName = @"八戒";
    hotUserInfo4.hotUser.headImageURL = @"http://pic13.nipic.com/20110415/1347158_132411659346_2.jpg";
    hotUserInfo4.hotUser.userDescription = @"我要背媳妇";
    hotUserInfo4.attentionType = LLAAttentionType_NotAttention;
    hotUserInfo4.hotUser.gender = UserGender_Female;
    [hotUsersArray addObject:hotUserInfo4];

    
    LLAHotUserInfo *hotUserInfo5 = [[LLAHotUserInfo alloc] init];
    hotUserInfo5.hotUser = [[LLAUser alloc] init];
    hotUserInfo5.hotUser.userName = @"Jack";
    hotUserInfo5.hotUser.headImageURL = @"http://pic13.nipic.com/20110415/1347158_132411659346_2.jpg";
    hotUserInfo5.hotUser.userDescription = @"jack is black，and i am beautiful";
    hotUserInfo5.hotUser.gender = UserGender_Male;
    hotUserInfo5.attentionType = LLAAttentionType_AllAttention;
    [hotUsersArray addObject:hotUserInfo5];
    
    LLAHotUserInfo *hotUserInfo6 = [[LLAHotUserInfo alloc] init];
    hotUserInfo6.hotUser = [[LLAUser alloc] init];
    hotUserInfo6.hotUser.userName = @"Jim";
    hotUserInfo6.hotUser.headImageURL = @"http://pic13.nipic.com/20110415/1347158_132411659346_2.jpg";
    hotUserInfo6.hotUser.userDescription = @"你才是鸡母";
    hotUserInfo6.attentionType = LLAAttentionType_AllAttention;
    hotUserInfo6.hotUser.gender = UserGender_Female;
    [hotUsersArray addObject:hotUserInfo6];
    
    NSLog(@"%@",hotUsersArray);
    // 热门视频加数据
    hotVideosArray = [NSMutableArray array];
    
    LLAHotVideoInfo *hotVideoInfo1 = [[LLAHotVideoInfo alloc] init];
    hotVideoInfo1.videoCoverImageURL = @"http://pic13.nipic.com/20110415/1347158_132411659346_2.jpg";
    hotVideoInfo1.likeNum = 12;
    hotVideoInfo1.prizeNum = 11178787;
    [hotVideosArray addObject:hotVideoInfo1];
    
    LLAHotVideoInfo *hotVideoInfo2 = [[LLAHotVideoInfo alloc] init];
    hotVideoInfo2.videoCoverImageURL = @"http://pic13.nipic.com/20110415/1347158_132411659346_2.jpg";
    hotVideoInfo2.likeNum = 342;
    hotVideoInfo2.prizeNum = 288622;
    [hotVideosArray addObject:hotVideoInfo2];

    
    LLAHotVideoInfo *hotVideoInfo3 = [[LLAHotVideoInfo alloc] init];
    hotVideoInfo3.videoCoverImageURL = @"";
    hotVideoInfo3.likeNum = 5677;
    hotVideoInfo3.prizeNum = 43;
    [hotVideosArray addObject:hotVideoInfo3];

    LLAHotVideoInfo *hotVideoInfo4 = [[LLAHotVideoInfo alloc] init];
    hotVideoInfo4.videoCoverImageURL = @"http://pic13.nipic.com/20110415/1347158_132411659346_2.jpg";
    hotVideoInfo4.likeNum = 563;
    hotVideoInfo4.prizeNum = 86;
    [hotVideosArray addObject:hotVideoInfo4];

    LLAHotVideoInfo *hotVideoInfo5 = [[LLAHotVideoInfo alloc] init];
    hotVideoInfo5.videoCoverImageURL = @"http://pic13.nipic.com/20110415/1347158_132411659346_2.jpg";
    hotVideoInfo5.likeNum = 87;
    hotVideoInfo5.prizeNum = 9;
    [hotVideosArray addObject:hotVideoInfo5];

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


#pragma mark - Load Data

- (void) loadData {
    
    NSDictionary *params = [NSDictionary dictionary];
    // 发送请求
    [LLAHttpUtil httpPostWithUrl:@"/discover/hotInfo" param:params responseBlock:^(id responseObject) {
        
        [HUD hide:NO];
        
        NSLog(@"%@",responseObject);
        
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:NO];
        
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
        [HUD hide:NO];
        
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
        
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
//        [hotUsersCell updateInfo];
        [hotUsersCell updateCellWithInfo:hotUsersArray tableWidth:collectionView.bounds.size.width];
        // 设置数据
//        [hotUsers updateCellWithInfo:scriptInfo maxWidth:collectionView.frame.size.width];
        return hotUsersCell;
        
    }else {
        LLAHotVideosCell *hotVideosCell = [dataCollectionView dequeueReusableCellWithReuseIdentifier:hotVideosCellIden forIndexPath:indexPath];
//        hotVideos.delegate = self;
        [hotVideosCell updateCellWithInfo:hotVideosArray[indexPath.row] tableWidth:collectionView.bounds.size.width];
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


//    LLASearchResultViewController *searchResult = [[LLASearchResultViewController alloc] init];
//    searchResult.searchResultText = headSearchBar.text;
//    [self.navigationController pushViewController:searchResult animated:YES];
    
    LLASearchResultsViewController *searchResults = [[LLASearchResultsViewController alloc] init];
    searchResults.searchResultText = headSearchBar.text;
    [self.navigationController pushViewController:searchResults animated:YES];
    
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
        hotUsers.userType = UserTypeIsHotUsers;
        hotUsers.hotUsersArray = hotUsersArray;
        [self.navigationController pushViewController:hotUsers animated:YES];
        
    }else{
    
        NSLog(@"%d,%d",indexPath.section, indexPath.row);

    }
    
    
}

@end
