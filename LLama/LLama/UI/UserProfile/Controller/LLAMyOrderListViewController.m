//
//  LLAMyOrderListViewController.m
//  LLama
//
//  Created by Live on 16/1/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

//controller
#import "LLAMyOrderListViewController.h"
#import "LLAScriptDetailViewController.h"
#import "LLAUserProfileViewController.h"
#import "LLAVideoDetailViewController.h"

//view
#import "LLACollectionView.h"
#import "LLALoadingView.h"
#import "LLAUserOrderListCell.h"

//category
#import "SVPullToRefresh.h"

//model
#import "LLAScriptHallMainInfo.h"

//util
#import "LLAViewUtil.h"
#import "LLAHttpUtil.h"

static NSString *const orderListCellIdentifier = @"orderListCellIdentifier";

static const CGFloat cellsVerticalSpace = 15;

static const CGFloat cellsToHorBorder = 10;
static const CGFloat cellToTopSpace = 6;

typedef NS_ENUM(NSInteger,MyOrderListType) {
    MyOrderListType_AsActor = 0,
    MyOrderListType_AsDirector = 1,
};

@interface LLAMyOrderListViewController()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,LLAUserOrderListCellDelegate>

{
    UIButton *asActorButton;
    UIButton *asDirctorButton;
    
    MyOrderListType orderListType;
    
    LLAScriptHallMainInfo *mainInfo;
    
    LLACollectionView *dataCollectionView;
    
    LLALoadingView *HUD;
}

@end

@implementation LLAMyOrderListViewController

#pragma mark - Life Cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self initVariables];
    [self initNavigationItems];
    [self initSubViews];
    
    asActorButton.selected = YES;
    
    [self loadData];
    
    [HUD show:YES];
}

#pragma mark - Init

- (void) initNavigationItems {
    asActorButton = [[UIButton alloc] init];
    asActorButton.titleLabel.font = [UIFont llaFontOfSize:17];
    
    [asActorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [asActorButton setTitleColor:[UIColor themeColor] forState:UIControlStateHighlighted];
    [asActorButton setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
    
    [asActorButton setTitle:@"演员订单" forState:UIControlStateNormal];
    
    [asActorButton addTarget:self action:@selector(asActorButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [asActorButton sizeToFit];
    
    //
    asDirctorButton = [UIButton new];
    asDirctorButton.titleLabel.font = [UIFont llaFontOfSize:17];
    [asDirctorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [asDirctorButton setTitleColor:[UIColor themeColor] forState:UIControlStateHighlighted];
    [asDirctorButton setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
    
    [asDirctorButton setTitle:@"导演订单" forState:UIControlStateNormal];
    [asDirctorButton addTarget:self action:@selector(asDirectorButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [asDirctorButton sizeToFit];
    
    //
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, asDirctorButton.frame.size.width+asActorButton.frame.size.width+40, MAX(asDirctorButton.frame.size.height,asActorButton.frame.size.height))];
                                                                                                                                    
    backView.backgroundColor = [UIColor clearColor];
    
    asDirctorButton.frame = CGRectMake(backView.frame.size.width-asDirctorButton.frame.size.width, 0, asDirctorButton.frame.size.width, asDirctorButton.frame.size.height);
    
    [backView addSubview:asActorButton];
    [backView addSubview:asDirctorButton];
    
    self.navigationItem.titleView = backView;
}

- (void) initVariables {
    
}

- (void) initSubViews {
    
    // collectionView布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = cellsVerticalSpace;
    
    // collectionView
    dataCollectionView = [[LLACollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    dataCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    dataCollectionView.delegate = self;
    dataCollectionView.dataSource = self;
    dataCollectionView.bounces = YES;
    dataCollectionView.alwaysBounceVertical = YES;
    dataCollectionView.backgroundColor = [UIColor colorWithHex:0xeaeaea];
    [self.view addSubview:dataCollectionView];
    
    // 注册cell
    [dataCollectionView registerClass:[LLAUserOrderListCell class] forCellWithReuseIdentifier:orderListCellIdentifier];
    //
    
    __weak typeof(self) weakSelf = self;
    
    [dataCollectionView addPullToRefreshWithActionHandler:^{
        [weakSelf loadData];
    }];
    
    [dataCollectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreData];
    }];
    
    //constraints
    
    
    // 约束
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[dataCollectionView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataCollectionView)]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[dataCollectionView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataCollectionView)]];
    
    // 菊花控件
    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];

}

#pragma mark - Button Clicked

- (void) asActorButtonClicked:(UIButton *) button {
    if (button.isSelected) {
        return;
    }
    
    button.selected = YES;
    asDirctorButton.selected = NO;
    
    orderListType = MyOrderListType_AsActor;
    
    //
    
    [UIView animateWithDuration:0.2 animations:^{
        [dataCollectionView setContentOffset:CGPointMake(0, 0) animated:NO];
    } completion:^(BOOL finished) {
        [dataCollectionView triggerPullToRefresh];
    }];
    
    
    
}

- (void) asDirectorButtonClicked:(UIButton *) button {
    if (button.isSelected) {
        return;
    }
    
    button.selected = YES;
    asActorButton.selected = NO;
    
    orderListType = MyOrderListType_AsDirector;
    
    [UIView animateWithDuration:0.2 animations:^{
        [dataCollectionView setContentOffset:CGPointMake(0, 0) animated:NO];
    } completion:^(BOOL finished) {
        [dataCollectionView triggerPullToRefresh];
    }];
    
}

#pragma mark - Load Data

- (void) loadData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@(0) forKey:@"pageNumber"];
    [params setValue:@(LLA_LOAD_DATA_DEFAULT_NUMBERS) forKey:@"pageSize"];
    
    if (orderListType == MyOrderListType_AsActor) {
        [params setValue:@"ACTOR" forKey:@"type"];
    }else {
        [params setValue:@"DIRECTOR" forKey:@"type"];
    }
    
    [LLAHttpUtil httpPostWithUrl:@"/play/getMyOrders" param:params responseBlock:^(id responseObject) {
        
        [dataCollectionView.pullToRefreshView stopAnimating];
        [HUD hide:YES];
        [dataCollectionView.infiniteScrollingView resetInfiniteScroll];

        
        LLAScriptHallMainInfo *tempInfo = [LLAScriptHallMainInfo parseJsonWithDic:responseObject];
        if (tempInfo){
            mainInfo = tempInfo;
            [dataCollectionView reloadData];
        }
        
        dataCollectionView.showsInfiniteScrolling = mainInfo.dataList.count > 0;

        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [dataCollectionView.pullToRefreshView stopAnimating];
        [HUD hide:YES];
        
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
        [dataCollectionView.pullToRefreshView stopAnimating];
        [HUD hide:YES];
        
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
    }];
    
}

- (void) loadMoreData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@(mainInfo.currentPage + 1) forKey:@"pageNumber"];
    [params setValue:@(LLA_LOAD_DATA_DEFAULT_NUMBERS) forKey:@"pageSize"];
    
    if (orderListType == MyOrderListType_AsActor) {
        [params setValue:@"ACTOR" forKey:@"type"];
    }else {
        [params setValue:@"DIRECTOR" forKey:@"type"];
    }
    
    [LLAHttpUtil httpPostWithUrl:@"/play/getMyOrders" param:params responseBlock:^(id responseObject) {
        
        [dataCollectionView.infiniteScrollingView stopAnimating];
        
        LLAScriptHallMainInfo *tempInfo = [LLAScriptHallMainInfo parseJsonWithDic:responseObject];
        if (tempInfo.dataList.count > 0){
            
            [mainInfo.dataList addObjectsFromArray:tempInfo.dataList];
            
            mainInfo.currentPage = tempInfo.currentPage;
            mainInfo.pageSize = tempInfo.pageSize;
            mainInfo.isFirstPage = tempInfo.isFirstPage;
            mainInfo.isLastPage = tempInfo.isLastPage;
            mainInfo.totalPageNumbers = tempInfo.totalPageNumbers;
            mainInfo.totalDataNumbers = tempInfo.totalDataNumbers;
            
            [dataCollectionView reloadData];
        }else {
            //[LLAViewUtil showAlter:self.view withText:LLA_LOAD_DATA_NO_MORE_TIPS];
            [dataCollectionView.infiniteScrollingView setInfiniteNoMoreLoading];
        }
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [dataCollectionView.infiniteScrollingView stopAnimating];
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        [dataCollectionView.infiniteScrollingView stopAnimating];
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
    }];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return mainInfo.dataList.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LLAUserOrderListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:orderListCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    [cell updateCellWithScriptInfo:mainInfo.dataList[indexPath.row] maxCellWidth:collectionView.frame.size.width-cellsToHorBorder*2];
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LLAScriptHallItemInfo *itemInfo = [mainInfo.dataList objectAtIndex:indexPath.row];
    
    if (itemInfo.status == LLAScriptStatus_VideoUploaded) {
        LLAVideoDetailViewController *videoDetail = [[LLAVideoDetailViewController alloc] initWithVideoId:itemInfo.scriptIdString];
        [self.navigationController pushViewController:videoDetail animated:YES];
        
    }else {
    
        LLAScriptDetailViewController *scriptDetail = [[LLAScriptDetailViewController alloc] initWithScriptIdString:itemInfo.scriptIdString];
    
        [self.navigationController pushViewController:scriptDetail animated:YES];
    }
}


#pragma mark - UICollectionViewFlowLayout

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat maxWidth = collectionView.frame.size.width - 2*cellsToHorBorder;
    
    CGFloat cellHeight = [LLAUserOrderListCell calculateHeightWithScriptInfo:mainInfo.dataList[indexPath.row] maxCellWidth:maxWidth];
    
    return CGSizeMake(maxWidth, cellHeight);
    
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(cellToTopSpace, cellsToHorBorder, 0, cellsToHorBorder);
}

#pragma mark - LLAUserOrderListCellDelegate

- (void) manageScriptWithScriptInfo:(LLAScriptHallItemInfo *)scriptInfo {
    
    if (scriptInfo.status == LLAScriptStatus_VideoUploaded) {
        LLAVideoDetailViewController *videoDetail = [[LLAVideoDetailViewController alloc] initWithVideoId:scriptInfo.scriptIdString];
        [self.navigationController pushViewController:videoDetail animated:YES];
        
    }else {
        
        LLAScriptDetailViewController *scriptDetail = [[LLAScriptDetailViewController alloc] initWithScriptIdString:scriptInfo.scriptIdString];
        
        [self.navigationController pushViewController:scriptDetail animated:YES];
    }

}

- (void) userHeadViewTapped:(LLAUser *)userInfo scriptInfo:(LLAScriptHallItemInfo *)scriptInfo {
    
    LLAUserProfileViewController *userProfile = [[LLAUserProfileViewController alloc] initWithUserIdString:userInfo.userIdString];
    
    [self.navigationController pushViewController:userProfile animated:YES];
}

@end
