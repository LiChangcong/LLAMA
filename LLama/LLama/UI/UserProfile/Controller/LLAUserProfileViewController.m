//
//  LLAUserProfileViewController.m
//  LLama
//
//  Created by Live on 16/1/12.
//  Copyright © 2016年 heihei. All rights reserved.
//

//controller
#import "LLAUserProfileViewController.h"
#import "LLAUserProfileSettingController.h"
#import "LLAMyOrderListViewController.h"
#import "LLAUserProfileEditUserInfoController.h"
#import "LLAUserAccountDetailViewController.h"
#import "LLACaptureVideoViewController.h"
#import "LLAVideoCommentViewController.h"

#import "LLAPickVideoNavigationController.h"

#import "MWPhotoBrowser.h"

//view
#import "LLATableView.h"

#import "LLALoadingView.h"
#import "LLAUserProfileNavigationBar.h"
#import "LLAUserProfileMyInfoCell.h"
#import "LLAUserProfileOtherInfoCell.h"
#import "LLAUserProfileMyFunctionCell.h"
#import "LLAUserProfileVideoHeaderView.h"
#import "LLAHallVideoInfoCell.h"

#import "LLAUserHeadView.h"

//category
#import "SVPullToRefresh.h"

//model
#import "LLAUser.h"
#import "LLAUserProfileMainInfo.h"
#import "LLAHallMainInfo.h"

//util
#import "LLAViewUtil.h"
#import "LLAHttpUtil.h"
#import "LLAUploadVideoShareManager.h"

// 点赞
#import "LLALoveViewController.h"
//
static const NSInteger userInfoSectionIndex = 0;
static const NSInteger userFunctionSectionIndex = 1;
static const NSInteger videoInfosectionIndex = 2;

//
static const CGFloat navigationBarHeight = 64;

@interface LLAUserProfileViewController()<UITableViewDelegate,UITableViewDataSource,LLAUserProfileMyInfoCellDelegate,LLAUserProfileOtherInfoCellDelegate,LLAUserProfileMyFunctionCellDelegate,LLAUserProfileVideoHeaderViewDelegate,LLAHallVideoInfoCellDelegate,LLAPickVideoNavigationControllerDelegate,LLAVideoPlayerViewDelegate,LLAVideoCommentViewControllerDelegate,MWPhotoBrowserDelegate>
{
    
    LLAUserProfileNavigationBar *customNaviBar;
    
    LLATableView *dataTableView;
    
    LLAUserProfileMainInfo *mainInfo;
    
    LLALoadingView *HUD;
    
    //for MWPhotoBrower
    NSMutableArray *photoArray;
}

@property(nonatomic , readwrite , strong) NSString *uIdString;

@property(nonatomic , readwrite , assign) UserProfileControllerType type;

@end

@implementation LLAUserProfileViewController

@synthesize uIdString;
@synthesize type;

#pragma mark - Life Cycle

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype) initWithUserIdString:(NSString *)userIdString {
    self = [super init];
    if (self) {
        uIdString = userIdString;
        
        if (uIdString) {
            if ([uIdString isEqualToString:[LLAUser me].userIdString]) {
                type = UserProfileControllerType_CurrentUser;
            }else {
                type = UserProfileControllerType_OtherUser;
            }
            
        }else {
            type = UserProfileControllerType_NotLogin;
        }
        
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserInfoChanged:) name:LLA_USER_LOGIN_STATE_CHANGED_NOTIFICATION object:nil];
    
    [self initNavigationItems];
    [self initSubViews];
    
    [self loadData];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //play
    [self startPlayVideo];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self stopAllVideo];
}


#pragma mark - Init

- (void) initNavigationItems {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout  = UIRectEdgeNone;
    
    mainInfo = [LLAUserProfileMainInfo new];
    
    [self updateNavigationItem];
}

- (void) initSubViews {
    customNaviBar = [[LLAUserProfileNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, navigationBarHeight)];
    customNaviBar.translatesAutoresizingMaskIntoConstraints = NO;
    customNaviBar.clipsToBounds = YES;
    customNaviBar.layer.masksToBounds = YES;

    [customNaviBar makeBackgroundClear:YES];
    [self.view addSubview:customNaviBar];
    
    [customNaviBar layoutIfNeeded];
    [customNaviBar setNeedsLayout];
    //
    dataTableView = [[LLATableView alloc] init];
    dataTableView.translatesAutoresizingMaskIntoConstraints = NO;
    dataTableView.dataSource = self;
    dataTableView.delegate = self;
    dataTableView.showsVerticalScrollIndicator = NO;
    dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    dataTableView.backgroundColor = [UIColor colorWithHex:0xededed];
    
    [self.view addSubview:dataTableView];
    
   __weak typeof(self) weakSelf = self;
//    
    [dataTableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadData];
    }];
    
    [dataTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreData];
    }];
    
    //constraints
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[customNaviBar(naviHeight)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(navigationBarHeight),@"naviHeight", nil]
      views:NSDictionaryOfVariableBindings(customNaviBar)]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[dataTableView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataTableView)]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[dataTableView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataTableView)]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[customNaviBar]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(customNaviBar)]];

    
    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];
    
    [self.view bringSubviewToFront:customNaviBar];
    
    [HUD show:YES];

}

#pragma mark - Load Data

- (void) loadData {
    
    //first,load user data,then load video data
    
    NSMutableDictionary *userParams = [NSMutableDictionary dictionary];
    
    NSString *urlString = @"/user/getUserInfoByUid";
    
    if (type == UserProfileControllerType_CurrentUser) {
        urlString = @"/user/getUserInfo";
    }else {
        urlString = @"/user/getUserInfoByUid";
        [userParams setValue:uIdString forKey:@"id"];
    }
    
    
    [LLAHttpUtil httpPostWithUrl:urlString param:userParams responseBlock:^(id responseObject) {
        
        [HUD hide:NO];
        if (type == UserProfileControllerType_CurrentUser) {
            mainInfo.userInfo = [LLAUser parseJsonWidthDic:[responseObject valueForKey:@"user"]];
            [LLAUser updateUserInfo:mainInfo.userInfo];
            
        }else {
        
            mainInfo.userInfo = [LLAUser parseJsonWidthDic:responseObject];
        }
        
        [dataTableView reloadData];
        
        [self updateNavigationItem];
        
        //get video data
        
        NSMutableDictionary *videoParams = [NSMutableDictionary dictionary];
        
        [videoParams setValue:uIdString forKey:@"userId"];
        [videoParams setValue:@(0) forKey:@"pageNumber"];
        [videoParams setValue:@(LLA_LOAD_DATA_DEFAULT_NUMBERS) forKey:@"pageSize"];
        
        if (mainInfo.showingVideoType == UserProfileHeadVideoType_Director) {
            [videoParams setValue:@"DIRECTOR" forKey:@"type"];
        }else {
            [videoParams setValue:@"ACTOR" forKey:@"type"];
        }
        
        [LLAHttpUtil httpPostWithUrl:@"/play/getPlayByUser" param:videoParams responseBlock:^(id responseObject) {
            
            [HUD hide:YES];
            //
            [dataTableView.pullToRefreshView stopAnimating];
            [dataTableView.infiniteScrollingView resetInfiniteScroll];
            //
            LLAHallMainInfo *info = [LLAHallMainInfo parseJsonWithDic:responseObject];
            
            if (mainInfo.showingVideoType == UserProfileHeadVideoType_Director) {
                [mainInfo.directorVideoArray removeAllObjects];
                [mainInfo.directorVideoArray addObjectsFromArray:info.dataList];
                
                dataTableView.showsInfiniteScrolling = mainInfo.directorVideoArray.count > 0;
                
            }else {
                [mainInfo.actorVideoArray removeAllObjects];
                [mainInfo.actorVideoArray addObjectsFromArray:info.dataList];
                
                dataTableView.showsInfiniteScrolling = mainInfo.actorVideoArray.count > 0;
            }
            
            [dataTableView reloadData];
            
            //play
            [self startPlayVideo];
            
        } exception:^(NSInteger code, NSString *errorMessage) {
            
            [HUD hide:YES];
            [dataTableView.pullToRefreshView stopAnimating];
            [LLAViewUtil showAlter:self.view withText:errorMessage];
            
        } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
            
            [HUD hide:YES];
            [dataTableView.pullToRefreshView stopAnimating];
            [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
        }];
        
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:NO];
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        [dataTableView.pullToRefreshView stopAnimating];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
        [HUD hide:NO];
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
        [dataTableView.pullToRefreshView stopAnimating];
        
    }];
    
}

- (void) loadMoreData {
    
    //load more video data
    
    NSMutableDictionary *videoParams = [NSMutableDictionary dictionary];
    
    [videoParams setValue:uIdString forKey:@"userId"];
    [videoParams setValue:@(0) forKey:@"pageNumber"];
    [videoParams setValue:@(LLA_LOAD_DATA_DEFAULT_NUMBERS) forKey:@"pageSize"];
    
    if (mainInfo.showingVideoType == UserProfileHeadVideoType_Director) {
        [videoParams setValue:@"DIRECTOR" forKey:@"type"];
        [videoParams setValue:@(mainInfo.directorVideoArray.count > 0 ? mainInfo.directorVideoArray.count / LLA_LOAD_DATA_DEFAULT_NUMBERS + 1 : 0) forKey:@"pageNumber"];
    }else {
        [videoParams setValue:@"ACTOR" forKey:@"type"];
        
        [videoParams setValue:@(mainInfo.actorVideoArray.count > 0 ? mainInfo.actorVideoArray.count / LLA_LOAD_DATA_DEFAULT_NUMBERS + 1 : 0) forKey:@"pageNumber"];
    }
    
    
    [LLAHttpUtil httpPostWithUrl:@"/play/getPlayByUser" param:videoParams responseBlock:^(id responseObject) {
        
        [HUD hide:YES];
        [dataTableView.infiniteScrollingView stopAnimating];
        
        LLAHallMainInfo *info = [LLAHallMainInfo parseJsonWithDic:responseObject];
        
        if (mainInfo.showingVideoType == UserProfileHeadVideoType_Director) {
            [mainInfo.directorVideoArray addObjectsFromArray:info.dataList];
        }else {
            
            [mainInfo.actorVideoArray addObjectsFromArray:info.dataList];
        }
        
        if (info.dataList.count < 1) {
            //[LLAViewUtil showAlter:self.view withText:LLA_LOAD_DATA_NO_MORE_TIPS];
            [dataTableView.infiniteScrollingView setInfiniteNoMoreLoading];
        }
        
        [dataTableView reloadData];
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [dataTableView.infiniteScrollingView stopAnimating];
        [HUD hide:YES];
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
        [dataTableView.infiniteScrollingView stopAnimating];
        [HUD hide:YES];
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
    }];
    
    
}

#pragma mark - UserInfoChange Notification

- (void) handleUserInfoChanged:(NSNotification *) noti {
    //update UserInfo
    if (mainInfo.userInfo) {
        
        mainInfo.userInfo = [LLAUser me];
        [dataTableView reloadData];
        
        customNaviBar.title = mainInfo.userInfo.userName;
    }
    
}

#pragma mark - updateNavigationItem

- (void) updateNavigationItem {
    
    if (type == UserProfileControllerType_CurrentUser) {
        
        customNaviBar.title = mainInfo.userInfo.userName;
        
        //left
        
        NSMutableArray *leftItems = [NSMutableArray array];
        
        if (self.navigationController.viewControllers.count > 1) {
            [leftItems addObject:[self backBarItem]];
        }
        
        [leftItems addObject:[self settingBarItem]];
        
        if (mainInfo.userInfo.userVideo) {
            [leftItems addObject:[self changeUserVideoItem]];
        }
        
        customNaviBar.leftBarButtonItems = leftItems;
        
        //right
        NSMutableArray *rightItems = [NSMutableArray array];
        
        if (mainInfo.userInfo.userVideo) {
            [rightItems addObject:[self praiseNumItemWithUserHead]];
        }else {
            [rightItems addObject:[self praiseNumItem]];
        }
        
        customNaviBar.rightBarButtonItems = rightItems;
        
    }else if (type == UserProfileControllerType_OtherUser) {
        
        customNaviBar.title = mainInfo.userInfo.userName;
        
        //left
        
        NSMutableArray *leftItems = [NSMutableArray array];
        
        [leftItems addObject:[self backBarItem]];
        
        customNaviBar.leftBarButtonItems = leftItems;
        
        //right
        NSMutableArray *rightItems = [NSMutableArray array];
        
        if (mainInfo.userInfo.userVideo) {
            [rightItems addObject:[self praiseNumItemWithUserHead]];
        }else {
            [rightItems addObject:[self praiseNumItem]];
        }
        
        customNaviBar.rightBarButtonItems = rightItems;

        
    }else {
        customNaviBar.leftBarButtonItem = [self backBarItem];
    }
}

- (UIBarButtonItem *) backBarItem {
    UIBarButtonItem *backItem = [UIBarButtonItem barItemWithImage:[UIImage llaImageWithName:@"back"] highlightedImage:nil target:self action:@selector(backToPre)];
    return backItem;
}

- (UIBarButtonItem *) settingBarItem {
    UIBarButtonItem *settingBarItem = [UIBarButtonItem barItemWithImage:[UIImage llaImageWithName:@"set"] highlightedImage:[UIImage llaImageWithName:@"seth"] target:self action:@selector(showSetting)];
    
    return settingBarItem;
}

- (UIBarButtonItem *) changeUserVideoItem {
    UIBarButtonItem *videoItem = [UIBarButtonItem barItemWithImage:[UIImage llaImageWithName:@"UserProfile_Change_Video_Normal"] highlightedImage:[UIImage llaImageWithName:@"UserProfile_Change_Video_Highlight"] target:self action:@selector(changeUserVideo)];
    
    return videoItem;
}

- (UIBarButtonItem *) praiseNumItem {
    
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = [UIFont llaFontOfSize:12];
    
    [button setImage:[UIImage llaImageWithName:@"like"] forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button setTitle:[NSString stringWithFormat:@" %ld",(long)mainInfo.userInfo.bePraisedNumber] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(praiseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [button sizeToFit];
    
    UIBarButtonItem *praiseItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return praiseItem;
    
}

- (UIBarButtonItem *) praiseNumItemWithUserHead {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [UIColor clearColor];
    
    LLAUserHeadView *headView = [[LLAUserHeadView alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
    headView.userHeadImageView.layer.borderWidth = 1;
    headView.userHeadImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    headView.userInteractionEnabled = NO;
    [headView updateHeadViewWithUser:mainInfo.userInfo];
    [backView addSubview:headView];
    
    UIButton *button = [[UIButton alloc] init];
    button.userInteractionEnabled = NO;
    button.titleLabel.font = [UIFont llaFontOfSize:12];
    
    [button setImage:[UIImage llaImageWithName:@"like"] forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button setTitle:[NSString stringWithFormat:@" %ld",(long)mainInfo.userInfo.bePraisedNumber] forState:UIControlStateNormal];
    
    [button sizeToFit];
    
    [backView addSubview:button];
    
    //recalculate frame
    CGRect backViewFame = backView.frame;
    backViewFame.size.width = MAX(backViewFame.size.width, button.size.width);
    backView.frame = backViewFame;
    
    headView.center = CGPointMake(backView.frame.size.width/2, headView.center.y);
    
    //button
    button.center = CGPointMake(backView.frame.size.width/2, backView.frame.size.height-button.frame.size.height/2);
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(praiseWithHeadClicked:)];
    
    [backView addGestureRecognizer:tapGes];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backView];
    
    return item;
    
}


- (void) backToPre {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) showSetting {
    //go setting
    LLAUserProfileSettingController *setting = [[LLAUserProfileSettingController alloc] init];
    
    [self.navigationController pushViewController:setting animated:YES];
}

- (void) changeUserVideo {
    //change userVideo
    
    [self uploadVieoToggled:mainInfo.userInfo];
    
}

- (void) praiseButtonClick {
    //praise user
    
    LLALoveViewController *love = [[LLALoveViewController alloc] init];
    [self.navigationController pushViewController:love animated:YES];
}

- (void) praiseWithHeadClicked:(UITapGestureRecognizer *) tag {
    //praise user with head
    
    if (type == UserProfileControllerType_CurrentUser) {
        
        
        LLAUserProfileEditUserInfoController *editUserInfo = [[LLAUserProfileEditUserInfoController alloc] init];
        
        [self.navigationController pushViewController:editUserInfo animated:YES];
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!mainInfo.userInfo) {
        return 0;
    }
    
    if (section == userInfoSectionIndex) {
        return 1;
    }else if (section == userFunctionSectionIndex) {
        if (UserProfileControllerType_CurrentUser == type) {
            return 1;
        }else {
            return 0;
        }
    }else {
        if (mainInfo.showingVideoType == UserProfileHeadVideoType_Director) {
            return mainInfo.directorVideoArray.count;
        }else{
            return mainInfo.actorVideoArray.count;
        }
    }
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == userInfoSectionIndex) {
        if (type == UserProfileControllerType_CurrentUser) {
            //
            static NSString *myInfoCellIden = @"myInfoCellInden";
            
            LLAUserProfileMyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:myInfoCellIden];
            if (!cell) {
                cell = [[LLAUserProfileMyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myInfoCellIden];
                cell.delegate = self;
            }
            
            [cell updateCellWithUserInfo:mainInfo.userInfo tableWidth:tableView.frame.size.width];
            
            return cell;
            
        }else {
            //other info
            
            static NSString *otherInfoCellIden = @"otherInfoCellIden";
            
            LLAUserProfileOtherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:otherInfoCellIden];
            if (!cell) {
                cell = [[LLAUserProfileOtherInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherInfoCellIden];
                cell.delegate = self;
            }
            
            [cell updateCellWithUserInfo:mainInfo.userInfo tableWidth:tableView.frame.size.width];
            
            return cell;
            
        }

    
    } else if (indexPath.section == userFunctionSectionIndex) {
        
        static NSString *functionCellIden = @"functionCellIden";
        
        LLAUserProfileMyFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:functionCellIden];
        
        if (!cell) {
            cell = [[LLAUserProfileMyFunctionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:functionCellIden];
            cell.delegate = self;
        }
        
        [cell updateCellWithUserInfo:mainInfo.userInfo tableWidth:tableView.frame.size.width];
        
        return cell;
        
    }else {
        static NSString *videCellIden = @"videCellIden";
        
        LLAHallVideoInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:videCellIden];
        if (!cell) {
            cell = [[LLAHallVideoInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videCellIden];
            cell.delegate = self;
        }
        
        if (mainInfo.showingVideoType == UserProfileHeadVideoType_Director) {
            [cell updateCellWithVideoInfo:mainInfo.directorVideoArray[indexPath.row] tableWidth:tableView.frame.size.width];
        }else {
            [cell updateCellWithVideoInfo:mainInfo.actorVideoArray[indexPath.row] tableWidth:tableView.frame.size.width];
        }
        
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == userInfoSectionIndex) {
        if (type == UserProfileControllerType_CurrentUser) {
            return [LLAUserProfileMyInfoCell calculateHeightWithUserInfo:mainInfo.userInfo tableWidth:tableView.frame.size.width];
        }else {
            return [LLAUserProfileOtherInfoCell calculateHeightWithUserInfo:mainInfo.userInfo tableWidth:tableView.frame.size.width];
        }
    }else if (indexPath.section == userFunctionSectionIndex) {
        if (UserProfileControllerType_CurrentUser == type) {
            return [LLAUserProfileMyFunctionCell calculateHeightWithUserInfo:mainInfo.userInfo tableWidth:tableView.frame.size.width];
        }else {
            return 0;
        }
    }else {
        if (mainInfo.showingVideoType == UserProfileHeadVideoType_Director) {
            
            return [LLAHallVideoInfoCell calculateHeightWithVideoInfo:mainInfo.directorVideoArray[indexPath.row] tableWidth:tableView.frame.size.width];
            
        }else{
            return [LLAHallVideoInfoCell calculateHeightWithVideoInfo:mainInfo.actorVideoArray[indexPath.row] tableWidth:tableView.frame.size.width];
        }
    }
    
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (!mainInfo.userInfo) {
        return nil;
    }
    
    if (section == videoInfosectionIndex) {
        
        static NSString *headerIden = @"headerIden";
        
        LLAUserProfileVideoHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIden];
        if (!header) {
            header = [[LLAUserProfileVideoHeaderView alloc] initWithReuseIdentifier:headerIden];
            header.delegate = self;
        }
        
        [header updateHeaderWithUserInfo:mainInfo tableWidth:tableView.frame.size.width];
        
        return header;
        
    }else {
        return nil;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section    {
    
    if (!mainInfo.userInfo) {
        return 0;
    }
    
    if (section == videoInfosectionIndex) {
        
       return  [LLAUserProfileVideoHeaderView calculateHeightWithUserInfo:mainInfo tableWidth:tableView.frame.size.width];
    }else {
        return 0;
    }
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y >  navigationBarHeight) {
        [customNaviBar makeBackgroundClear:NO];
        
    }else {
        [customNaviBar makeBackgroundClear:YES];
        
    }
    //stop those which is out of screen
    NSArray *visibleCells = [dataTableView visibleCells];
    
    for (UITableViewCell* tempCell in visibleCells) {
        if ([[tempCell class] conformsToProtocol:@protocol(LLACellPlayVideoProtocol)]) {
            
            UITableViewCell<LLACellPlayVideoProtocol> *tc = (UITableViewCell<LLACellPlayVideoProtocol> *)tempCell;
            
            CGRect playerFrame = tc.videoPlayerView.bounds;
            
            CGRect subViewFrame = [tc convertRect:playerFrame toView:scrollView];
            if (subViewFrame.origin.y >= scrollView.contentOffset.y+scrollView.bounds.size.height || scrollView.contentOffset.y>subViewFrame.origin.y+subViewFrame.size.height) {
                
                [tc.videoPlayerView stopVideo];
            }
            
        }
    }

    
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //get the index
    
    
    id <LLACellPlayVideoProtocol> playCell = nil;
    
    NSArray *visibleCells = [dataTableView visibleCells];
    
    CGFloat maxHeight = 0;
    
    for (UITableViewCell* tempCell in visibleCells) {
        if ([[tempCell class] conformsToProtocol:@protocol(LLACellPlayVideoProtocol)]) {
            
            UITableViewCell<LLACellPlayVideoProtocol> *tc = (UITableViewCell<LLACellPlayVideoProtocol> *)tempCell;
            
            CGRect playerFrame = tc.videoPlayerView.bounds;
            
            CGRect subViewFrame = [tc convertRect:playerFrame toView:scrollView];
            
            CGFloat heightInWindow =  0;
            
            if (subViewFrame.origin.y < scrollView.contentOffset.y) {
                heightInWindow = subViewFrame.origin.y+subViewFrame.size.height-scrollView.contentOffset.y;
            }else if(subViewFrame.origin.y+subViewFrame.size.height > scrollView.contentOffset.y+scrollView.bounds.size.height) {
                heightInWindow = scrollView.contentOffset.y+scrollView.bounds.size.height-subViewFrame.origin.y;
                
            }else {
                heightInWindow = subViewFrame.size.height;
            }
            
            
            if (heightInWindow >= maxHeight) {
                maxHeight = heightInWindow;
                playCell = tc;
            }
        }
    }
    
    //
    for (UITableViewCell* tempCell in visibleCells) {
        if ([[tempCell class] conformsToProtocol:@protocol(LLACellPlayVideoProtocol)]) {
            
            UITableViewCell<LLACellPlayVideoProtocol> *tc = (UITableViewCell<LLACellPlayVideoProtocol> *)tempCell;
            
            if (tc == playCell) {
                playCell.videoPlayerView.playingVideoInfo = playCell.shouldPlayVideoInfo;
                [playCell.videoPlayerView playVideo];
            }else {
                [tc.videoPlayerView stopVideo];
            }
            
        }
    }
    
}


#pragma mark - LLAUserProfileMyInfoCellDelegate,LLAUserProfileOtherInfoCellDelegate,

- (void) headViewTapped:(LLAUser *) userInfo {
    
    if ([userInfo isEqual:[LLAUser me]]) {
        
        LLAUserProfileEditUserInfoController *editUserInfo = [[LLAUserProfileEditUserInfoController alloc] init];
        
        [self.navigationController pushViewController:editUserInfo animated:YES];
    }else {
        //
        
        if (!photoArray) {
            photoArray = [NSMutableArray array];
        }
        [photoArray removeAllObjects];
        [photoArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:userInfo.headImageURL]]];
        
        MWPhotoBrowser *photoBrower = [[MWPhotoBrowser alloc] initWithDelegate:self];
        [photoBrower showToolBar:NO];
        LLABaseNavigationController *photoNavi = [[LLABaseNavigationController alloc] initWithRootViewController:photoBrower];
        
        photoNavi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:photoNavi animated:YES completion:nil];
        
    }
}

- (void) uploadVieoToggled:(LLAUser *) userInfo {
    if ([userInfo isEqual:[LLAUser me]]) {

        //actor,should upload video
        
        LLACaptureVideoViewController *videoCaptrue = [[LLACaptureVideoViewController alloc] init];
        
        LLAPickVideoNavigationController *baseNavi = [[LLAPickVideoNavigationController alloc] initWithRootViewController:videoCaptrue];
        baseNavi.videoPickerDelegate = self;
        
        [self.navigationController presentViewController:baseNavi animated:YES completion:NULL];
    }
}

- (void) uploadVieoFinished:(LLAUser *)userInfo {
    
    //[dataTableView triggerPullToRefresh];
    [self loadData];
}

#pragma mark - LLAUserProfileMyFunctionCellDelegate

- (void) showPersonalPropertyWithUserInfo:(LLAUser *) userInfo {
    
    LLAUserAccountDetailViewController *property = [[LLAUserAccountDetailViewController alloc] init];
    [self.navigationController pushViewController:property animated:YES];
}

- (void) showPersonalOrderListWithUserInfo:(LLAUser *) userInfo {
    
    LLAMyOrderListViewController *orderList = [[LLAMyOrderListViewController alloc] init];
    
    [self.navigationController pushViewController:orderList animated:YES];
}

#pragma mark - LLAUserProfileVideoHeaderViewDelegate

- (void) showVideosWithType:(UserProfileHeadVideoType ) videoType {
    mainInfo.showingVideoType = videoType;
    //[dataTableView reloadData];
    
    //[HUD show:YES];
    
    //[self loadData];
    
    NSMutableDictionary *videoParams = [NSMutableDictionary dictionary];
    
    [videoParams setValue:uIdString forKey:@"userId"];
    [videoParams setValue:@(0) forKey:@"pageNumber"];
    [videoParams setValue:@(LLA_LOAD_DATA_DEFAULT_NUMBERS) forKey:@"pageSize"];
    
    if (mainInfo.showingVideoType == UserProfileHeadVideoType_Director) {
        [videoParams setValue:@"DIRECTOR" forKey:@"type"];
    }else {
        [videoParams setValue:@"ACTOR" forKey:@"type"];
    }
    
    [LLAHttpUtil httpPostWithUrl:@"/play/getPlayByUser" param:videoParams responseBlock:^(id responseObject) {
        
        [HUD hide:YES];
        //
        //[dataTableView.pullToRefreshView stopAnimating];
        [dataTableView.infiniteScrollingView resetInfiniteScroll];
        //
        LLAHallMainInfo *info = [LLAHallMainInfo parseJsonWithDic:responseObject];
        
        if (mainInfo.showingVideoType == UserProfileHeadVideoType_Director) {
            [mainInfo.directorVideoArray removeAllObjects];
            [mainInfo.directorVideoArray addObjectsFromArray:info.dataList];
            
            dataTableView.showsInfiniteScrolling = mainInfo.directorVideoArray.count > 0;
            
        }else {
            [mainInfo.actorVideoArray removeAllObjects];
            [mainInfo.actorVideoArray addObjectsFromArray:info.dataList];
            
            dataTableView.showsInfiniteScrolling = mainInfo.actorVideoArray.count > 0;
        }
        
        [dataTableView reloadData];
        
        //play
        [self startPlayVideo];
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:YES];
        //[dataTableView.pullToRefreshView stopAnimating];
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
        [HUD hide:YES];
        //[dataTableView.pullToRefreshView stopAnimating];
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
    }];
    
}

#pragma mark - LLAHallVideoInfoCellDelegate

- (void) userHeadViewClickedWithUserInfo:(LLAUser *) userInfo itemInfo:(LLAHallVideoItemInfo *) videoItemInfo {
    
    LLAUserProfileViewController *userProfile = [[LLAUserProfileViewController alloc] initWithUserIdString:userInfo.userIdString];
    [self.navigationController pushViewController:userProfile animated:YES];
}
/**
 *  点赞按钮点击
 */
- (void) loveVideoWithVideoItemInfo:(LLAHallVideoItemInfo *) videoItemInfo loveButton:(UIButton *)loveButton {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:videoItemInfo.scriptID forKey:@"playId"];
    
    [LLAHttpUtil httpPostWithUrl:@"/play/zan" param:params responseBlock:^(id responseObject) {
        
        //
        [LLAViewUtil showLoveSuccessAnimationInView:self.view fromView:loveButton.imageView duration:0 compeleteBlock:^(BOOL finished) {
            videoItemInfo.hasPraised = YES;
            videoItemInfo.praiseNumbers ++;
            [dataTableView reloadData];
        }];
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
    }];
    
    
}
/**
 *  评论按钮点击
 */
- (void) commentVideoWithVideoItemInfo:(LLAHallVideoItemInfo *) videoItemInfo {
    [self pushToCommentViewControllerWithInfo:videoItemInfo];
}
/**
 *  分享按钮点击
 */
- (void) shareVideoWithVideoItemInfo:(LLAHallVideoItemInfo *)videoItemInfo {
    
}
/**
 *  评论中用户名按钮点击
 */
- (void) commentVideoChooseWithCommentInfo:(LLAHallVideoCommentItem *) commentInfo videoItemInfo:(LLAHallVideoItemInfo *) vieoItemInfo {
    [self pushToCommentViewControllerWithInfo:vieoItemInfo];
}

- (void) chooseUserFromComment:(LLAHallVideoCommentItem *) commentInfo userInfo:(LLAUser *)userInfo videoInfo:(LLAHallVideoItemInfo *) videoItemInfo {
    
    if (userInfo.userIdString.length > 0) {
    
        LLAUserProfileViewController *userProfile = [[LLAUserProfileViewController alloc] initWithUserIdString:userInfo.userIdString];
        [self.navigationController pushViewController:userProfile animated:YES];
    }
}

#pragma mark - LLAPickVideoNavigationControllerDelegate

- (void) videoPicker:(LLAPickVideoNavigationController *)videoPicker didFinishPickVideo:(NSURL *)videoURL thumbImage:(UIImage *)thumbImage {
    
    [[LLAUploadVideoShareManager shareManager] addUserVideoTashWithThumbImage:thumbImage videoFileURL:videoURL];
}

- (void) videoPickerDidCancelPick:(LLAPickVideoNavigationController *)videoPicker {
    
}

#pragma mark - PlayerViewDelegate

- (void) playerViewTappToPlay:(LLAVideoPlayerView *) playerView {
    //
    NSArray *visibleCells = [dataTableView visibleCells];
    
    for (UITableViewCell* tempCell in visibleCells) {
        if ([[tempCell class] conformsToProtocol:@protocol(LLACellPlayVideoProtocol)]) {
            
            UITableViewCell<LLACellPlayVideoProtocol> *tc = (UITableViewCell<LLACellPlayVideoProtocol> *)tempCell;
            if (playerView != tc.videoPlayerView) {
                [tc.videoPlayerView stopVideo];
            }
        }
    }
    
}

- (void) playerViewTappToPause:(LLAVideoPlayerView *)playerView {
    
}

#pragma mark - LLAVideoCommentViewControllerDelegate

- (void) commentSuccess:(LLAHallVideoCommentItem *)commentContent videoId:(NSString *)videoIdString {
    
    if (commentContent && videoIdString.length > 0) {
        //find
        
        for (LLAHallVideoItemInfo *videoInfo in mainInfo.showingVideoType == UserProfileHeadVideoType_Director?mainInfo.directorVideoArray:mainInfo.actorVideoArray) {
            if ([videoIdString isEqualToString:videoInfo.scriptID]) {
                
                NSMutableArray *commentArray = [NSMutableArray array];
                [commentArray addObject:commentContent];
                
                [commentArray addObjectsFromArray:videoInfo.commentArray];
                
                videoInfo.commentArray = commentArray;
                videoInfo.commentNumbers ++;
                [dataTableView reloadData];
                
                break;
            }
        }
        
    }
    
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return photoArray.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < photoArray.count)
        return photoArray[index];
    return nil;
}



#pragma mark - Start Stop Video

#pragma mark - Private Method

- (void) pushToCommentViewControllerWithInfo:(LLAHallVideoItemInfo *) videoImteInfo {
    LLAVideoCommentViewController *comment = [[LLAVideoCommentViewController alloc] initWithVideoIdString:videoImteInfo.scriptID];
    comment.delegate = self;
    [self.navigationController pushViewController:comment animated:YES];

}

#pragma mark - Public Method

- (void) stopAllVideo {
    
    NSArray *visibleCells = [dataTableView visibleCells];
    
    for (UITableViewCell* tempCell in visibleCells) {
        if ([[tempCell class] conformsToProtocol:@protocol(LLACellPlayVideoProtocol)]) {
            
            UITableViewCell<LLACellPlayVideoProtocol> *tc = (UITableViewCell<LLACellPlayVideoProtocol> *)tempCell;
            [tc.videoPlayerView stopVideo];
        }
    }
    
}

- (void) startPlayVideo {
    
    [self scrollViewDidEndDecelerating:dataTableView];
}



@end
