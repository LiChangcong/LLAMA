//
//  LLAVideoDetailViewController.m
//  LLama
//
//  Created by Live on 16/1/17.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAVideoDetailViewController.h"
#import "LLAUserProfileViewController.h"
#import "LLAVideoCommentViewController.h"


//view
#import "LLATableView.h"
#import "LLALoadingView.h"
#import "LLAVideoPlayerView.h"
#import "LLAHallVideoInfoCell.h"
#import "MMPopup.h"

//model
#import "LLAHallVideoItemInfo.h"

//category
#import "SVPullToRefresh.h"

//util
#import "LLAViewUtil.h"
#import "LLAHttpUtil.h"
#import "LLASocialShareUtil.h"

//
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"

@interface LLAVideoDetailViewController()<UITableViewDataSource,UITableViewDelegate,LLAHallVideoInfoCellDelegate,LLAVideoPlayerViewDelegate,LLAVideoCommentViewControllerDelegate>
{
    LLATableView *dataTableView;
    
    LLALoadingView *HUD;
    
    LLAHallVideoItemInfo *videoInfo;
    
    NSString *videoIdString;
    
    LLAVideoPlayerView *playerView;

}

@end

@implementation LLAVideoDetailViewController

#pragma mark - Life Cycle

- (instancetype) initWithVideoId:(NSString *)videoId {
    self = [super init];
    if (self) {
        videoIdString = [videoId copy];
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self initNavigationItems];
    [self initSubViews];
    
    //
    [HUD show:YES];
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
    self.navigationItem.title = @"视频";
}

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
        [weakSelf startPlayVideo];
    }];
    
//    [dataTableView addInfiniteScrollingWithActionHandler:^{
//        [weakSelf loadMoreData];
//    }];
    
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
    
    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];

}

#pragma mark - LoadData

- (void) loadData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:videoIdString forKey:@"playId"];
    
    [LLAHttpUtil httpPostWithUrl:@"/play/getFinishedPlay" param:params responseBlock:^(id responseObject) {
        
        [HUD hide:YES];
        [dataTableView.pullToRefreshView stopAnimating];
        
        LLAHallVideoItemInfo *tempInfo = [LLAHallVideoItemInfo parseJsonWithDic:responseObject];
        if (tempInfo) {
            videoInfo = tempInfo;
            [dataTableView reloadData];
        }
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:YES];
        [dataTableView.pullToRefreshView stopAnimating];
        
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        [HUD hide:YES];
        [dataTableView.pullToRefreshView stopAnimating];
        
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
    }];
    
    
}

- (void) loadMoreData {
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (videoInfo) {
        return 1;
    }else {
        return 0;
    }
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIden = @"cell";
    
    LLAHallVideoInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell) {
        cell = [[LLAHallVideoInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
        cell.delegate = self;
        playerView = cell.videoPlayerView;
    }
    
    // 设置每个cell的数据
    [cell updateCellWithVideoInfo:videoInfo tableWidth:tableView.frame.size.width];
    
    return cell;

}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 返回每行高度
    return [LLAHallVideoInfoCell calculateHeightWithVideoInfo:videoInfo tableWidth:tableView.frame.size.width];
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
    
    /**
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

    **/
    
    //test share
    LLAShareRequestInfo *requestInfo = [LLAShareRequestInfo new];
    requestInfo.urlString = @"/play/getShareInfo";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:videoIdString forKey:@"playId"];
    
    requestInfo.paramsDic = params;
    
    [LLASocialShareUtil shareWithRequestInfo:requestInfo title:@"分享这个视频到" reportHandler:^(void) {
        
    } stateChangeHandler:^(LLASocialShareResponseState state, NSString *message, NSError *error) {
        
        NSLog(@"share Message:%@",message);
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

- (void) commentSuccess:(LLAHallVideoCommentItem *)commentContent videoId:(NSString *)videoIdStr {
    
    if (commentContent && [videoIdStr isEqualToString:videoIdString]) {
        //find
        if ([videoIdString isEqualToString:videoInfo.scriptID]) {
            
            NSMutableArray *commentArray = [NSMutableArray array];
            [commentArray addObject:commentContent];
            
            [commentArray addObjectsFromArray:videoInfo.commentArray];
            
            videoInfo.commentArray = commentArray;
            videoInfo.commentNumbers ++;
            [dataTableView reloadData];

        }

        
    }
    
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

- (void) stopAllVideo {
    
    [playerView stopVideo];
}

- (void) startPlayVideo {
    
    playerView.playingVideoInfo = videoInfo.videoInfo;
    [playerView playVideo];
}

@end
