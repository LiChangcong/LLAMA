//
//  LLAHomeHallViewController.m
//  LLama
//
//  Created by Live on 16/1/12.
//  Copyright © 2016年 heihei. All rights reserved.
//

//controller
#import "LLAHomeHallViewController.h"
#import "LLAUserProfileViewController.h"
#import "LLAVideoCommentViewController.h"

//view
#import "LLATableView.h"
#import "LLALoadingView.h"
#import "LLAVideoPlayerView.h"
#import "LLAHallVideoInfoCell.h"
#import "MMPopup.h"

#import "LLAUploadVideoProgressView.h"
//category
#import "SVPullToRefresh.h"

//model
#import "LLAHallMainInfo.h"

//util
#import "LLAViewUtil.h"
#import "LLAHttpUtil.h"
#import "LLAUploadVideoShareManager.h"
#import "LLAVideoPlayUtil.h"

@interface LLAHomeHallViewController()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,LLAHallVideoInfoCellDelegate,LLAUploadVideoProgressViewDelegate,LLAVideoPlayerViewDelegate,LLAVideoCommentViewControllerDelegate>
{
    LLATableView *dataTableView;
    
    LLALoadingView *HUD;
    
    LLAHallMainInfo *mainInfo;
    
    //
    LLAUploadVideoProgressView *videoProgressView;

    //
    NSMutableArray *playerCellsArray;
}

@end

@implementation LLAHomeHallViewController

@synthesize delegate;

#pragma mark - Life Cycle

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏
    [self initNaviItems];
    
    playerCellsArray = [NSMutableArray array];
    
    // 设置内部子控件
    [self initSubViews];
    
    // 显示菊花
    [HUD show:YES];
    
    // 刷新数据
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
// 设置导航栏
- (void) initNaviItems {
    self.navigationItem.title = @"大厅";
}

// 设置内部子控件
- (void) initSubViews {
    
    // tableView
    dataTableView = [[LLATableView alloc] init];
    dataTableView.translatesAutoresizingMaskIntoConstraints = NO;
    dataTableView.dataSource = self;
    dataTableView.delegate = self;
    dataTableView.showsVerticalScrollIndicator = NO;
    dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:dataTableView];
    

    __weak typeof(self) weakSelf = self;
    
    [dataTableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadData];
    }];
    
    [dataTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreData];
    }];
    
    //
    videoProgressView = [[LLAUploadVideoProgressView alloc] initWithViewType:videoUploadType_ScriptVideo];
    videoProgressView.translatesAutoresizingMaskIntoConstraints = NO;
    videoProgressView.delegate = self;
    videoProgressView.hidden = YES;
    [self.view addSubview:videoProgressView];
        
    //constraints
    
    // 添加约束

    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[dataTableView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataTableView)]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[videoProgressView(progressHeight)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"progressHeight":@(LLAUploadVideoProgressViewHeight)}
      views:NSDictionaryOfVariableBindings(videoProgressView)]];
    
    //
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[dataTableView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataTableView)]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[videoProgressView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(videoProgressView)]];
    
    // 菊花控件
    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];
    
}

#pragma mark - Load Data

// 刷新数据
- (void) loadData {
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(0) forKey:@"pageNumber"];
    [params setValue:@(LLA_LOAD_DATA_DEFAULT_NUMBERS) forKey:@"pageSize"];
    
    // 发送请求
    [LLAHttpUtil httpPostWithUrl:@"/play/getFinishedPlayList" param:params responseBlock:^(id responseObject) {
        
        [HUD hide:NO];
        [dataTableView.pullToRefreshView stopAnimating];
        [dataTableView.infiniteScrollingView resetInfiniteScroll];
        
        LLAHallMainInfo *tempInfo = [LLAHallMainInfo parseJsonWithDic:responseObject];
        if (tempInfo){
            mainInfo = tempInfo;
            [dataTableView reloadData];
            //
            [self startPlayVideo];
        }
        
        dataTableView.showsInfiniteScrolling = mainInfo.dataList.count > 0;
            
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:NO];
        [dataTableView.pullToRefreshView stopAnimating];
        
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
        [HUD hide:NO];
        [dataTableView.pullToRefreshView stopAnimating];
        
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
        
    }];
}

// 加载更多的数据
- (void) loadMoreData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@(mainInfo.currentPage+1) forKey:@"pageNumber"];
    [params setValue:@(LLA_LOAD_DATA_DEFAULT_NUMBERS) forKey:@"pageSize"];
    
    [LLAHttpUtil httpPostWithUrl:@"/play/getFinishedPlayList" param:params responseBlock:^(id responseObject) {
        
        [dataTableView.infiniteScrollingView stopAnimating];
        
        LLAHallMainInfo *tempInfo = [LLAHallMainInfo parseJsonWithDic:responseObject];
        if (tempInfo.dataList.count > 0){
            
            [mainInfo.dataList addObjectsFromArray:tempInfo.dataList];
            
            mainInfo.currentPage = tempInfo.currentPage;
            mainInfo.pageSize = tempInfo.pageSize;
            mainInfo.isFirstPage = tempInfo.isFirstPage;
            mainInfo.isLastPage = tempInfo.isLastPage;
            mainInfo.totalPageNumbers = tempInfo.totalPageNumbers;
            mainInfo.totalDataNumbers = tempInfo.totalDataNumbers;
        
            [dataTableView reloadData];
        }else {
            [dataTableView.infiniteScrollingView setInfiniteNoMoreLoading];
        }
        
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [dataTableView.infiniteScrollingView stopAnimating];
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
        [dataTableView.infiniteScrollingView stopAnimating];
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
        
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    // 行数
    return mainInfo.dataList.count;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIden = @"cell";
    
    LLAHallVideoInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell) {
        cell = [[LLAHallVideoInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
        cell.delegate = self;
        
        [playerCellsArray addObject:cell];
    }
    
    // 设置每个cell的数据
    [cell updateCellWithVideoInfo:mainInfo.dataList[indexPath.row] tableWidth:tableView.frame.size.width];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 返回每行高度
    return [LLAHallVideoInfoCell calculateHeightWithVideoInfo:mainInfo.dataList[indexPath.row] tableWidth:tableView.frame.size.width];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

//- (void) tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if ([cell conformsToProtocol:@protocol(LLACellPlayVideoProtocol)]) {
//        
//        UITableViewCell<LLACellPlayVideoProtocol> *tc = (UITableViewCell<LLACellPlayVideoProtocol> *)cell;
//        
//        [tc.videoPlayerView stopVideo];
//    }
//    
//}


#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //stop those which is out of screen
    
    [LLAVideoPlayUtil stopOutBoundsPlayingVideoInCells:playerCellsArray inScrollView:scrollView];
    
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //get the index
    
    [LLAVideoPlayUtil playShouldPlayVideoInCells:playerCellsArray inScrollView:scrollView];
    
}

#pragma mark - LLAHallVideoInfoCellDelegate

- (void) userHeadViewClickedWithUserInfo:(LLAUser *) userInfo itemInfo:(LLAHallVideoItemInfo *) videoItemInfo {
    
    [self pushToUserProfile:userInfo];
}

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

- (void) commentVideoWithVideoItemInfo:(LLAHallVideoItemInfo *) videoItemInfo {
    [self pushToCommentViewControllerWithInfo:videoItemInfo];
}

- (void) shareVideoWithVideoItemInfo:(LLAHallVideoItemInfo *)videoItemInfo {

    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    
    MMSheetViewConfig *config = [MMSheetViewConfig globalConfig];
    config.itemHighlightColor = [UIColor redColor];
    config.cancelTextNormalColor = [UIColor colorWithHex:0x00aeff];
    
    MMPopupItem *reportItem = MMItemMake(@"举报", MMItemTypeHighlight, ^(NSInteger index) {
        //report
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setValue:videoItemInfo.scriptID forKey:@"playId"];
        
        [HUD show:YES];
        
        [LLAHttpUtil httpPostWithUrl:@"/play/reportPlay" param:params responseBlock:^(id responseObject) {
            
            //
            [HUD hide:YES];
            
            [LLAViewUtil showAlter:self.view withText:@"感谢你的举报，我们会尽快处理"];
            
        } exception:^(NSInteger code, NSString *errorMessage) {
            
            [HUD hide:YES];
            [LLAViewUtil showAlter:self.view withText:errorMessage];
            
        } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
            [HUD hide:YES];
            [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
        }];
        
    });
    
    NSArray *items = @[reportItem];

    [[[MMSheetView alloc] initWithTitle:@"" items:items] showWithBlock:^(MMPopupView * popView) {
        
    }];
}

- (void) commentVideoChooseWithCommentInfo:(LLAHallVideoCommentItem *) commentInfo videoItemInfo:(LLAHallVideoItemInfo *) videoItemInfo {
    [self pushToCommentViewControllerWithInfo:videoItemInfo];
}

- (void) chooseUserFromComment:(LLAHallVideoCommentItem *) commentInfo userInfo:(LLAUser *)userInfo videoInfo:(LLAHallVideoItemInfo *) videoItemInfo {
    
    if (userInfo.userIdString.length > 0) {
        [self pushToUserProfile:userInfo];
    }
    
}

#pragma mark - LLAVideoCommentViewControllerDelegate

- (void) commentSuccess:(LLAHallVideoCommentItem *)commentContent videoId:(NSString *)videoIdString {
    
    if (commentContent && videoIdString.length > 0) {
        //find
        
        for (LLAHallVideoItemInfo *videoInfo in mainInfo.dataList) {
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

#pragma mark - Progress Delegate

- (void) uploadVideoFinished:(LLAUploadVideoProgressView *)progressView {
    //
    [dataTableView triggerPullToRefresh];
}

- (void) uploadVideoFailed:(LLAUploadVideoProgressView *)progressView {
    
}

#pragma mark - playerViewDelegate

- (void) playerViewTappToPlay:(LLAVideoPlayerView *) playerView {
    //
    [LLAVideoPlayUtil handlePlayerViewTappToPlay:playerView inCell:playerCellsArray inScrollView:dataTableView];
}

- (void) playerViewTappToPause:(LLAVideoPlayerView *)playerView {
    //
}

#pragma mark - Private Method

- (void) pushToUserProfile:(LLAUser *) user {
    
    LLAUserProfileViewController *userProfile = [[LLAUserProfileViewController alloc] initWithUserIdString:user.userIdString];
    [self.navigationController pushViewController:userProfile animated:YES];
    
}

- (void) pushToCommentViewControllerWithInfo:(LLAHallVideoItemInfo *) itemInfo {
    LLAVideoCommentViewController *comment = [[LLAVideoCommentViewController alloc] initWithVideoIdString:itemInfo.scriptID];
    comment.delegate = self;
    [self.navigationController pushViewController:comment animated:YES];
}

#pragma mark - Public Method

- (void) stopAllVideo {
    
    [LLAVideoPlayUtil stopAllVideosInCells:playerCellsArray inScrollView:dataTableView];
}

- (void) startPlayVideo {
    
    if (delegate && [delegate respondsToSelector:@selector(shouldPlayVideo)]) {
        if ([delegate shouldPlayVideo]) {
            
            if (playerCellsArray.count < 1 && mainInfo.dataList.count > 0) {
                [dataTableView visibleCells];
            }
            
            [LLAVideoPlayUtil playShouldPlayVideoInCells:playerCellsArray inScrollView:dataTableView];
        }
    }
    
}

@end
