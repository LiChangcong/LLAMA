//
//  LLAHomeHallViewController.m
//  LLama
//
//  Created by Live on 16/1/12.
//  Copyright © 2016年 heihei. All rights reserved.
//

//controller
#import "LLAHomeHallViewController.h"

//view
#import "LLATableView.h"
#import "LLALoadingView.h"
#import "LLAVideoPlayerView.h"
#import "LLAHallVideoInfoCell.h"
//category
#import "SVPullToRefresh.h"

//model
#import "LLAHallMainInfo.h"

//util
#import "LLAViewUtil.h"
#import "LLAHttpUtil.h"

@interface LLAHomeHallViewController()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,LLAHallVideoInfoCellDelegate>
{
    LLATableView *dataTableView;
    
    LLALoadingView *HUD;
    
    LLAHallMainInfo *mainInfo;

}

@end

@implementation LLAHomeHallViewController

#pragma mark - Life Cycle

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏
    [self initNaviItems];
    
    // 设置内部子控件
    [self initSubViews];
    
    // 显示菊花
    [HUD show:YES];
    
    // 刷新数据
    [self loadData];
    
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
      constraintsWithVisualFormat:@"H:|-(0)-[dataTableView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataTableView)]];
    
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
        
        LLAHallMainInfo *tempInfo = [LLAHallMainInfo parseJsonWithDic:responseObject];
        if (tempInfo){
            mainInfo = tempInfo;
            [dataTableView reloadData];
        }
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

- (void) tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    

}

//





#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //get the index
    
    
    id <LLACellPlayVideoProtocol> playCell = nil;
    
        NSArray *visibleCells = [dataTableView visibleCells];
    
        for (UITableViewCell* tempCell in visibleCells) {
            if ([[tempCell class] conformsToProtocol:@protocol(LLACellPlayVideoProtocol)]) {
    
                UITableViewCell<LLACellPlayVideoProtocol> *tc = (UITableViewCell<LLACellPlayVideoProtocol> *)tempCell;
                
                CGRect playerFrame = tc.videoPlayerView.frame;
                
                CGRect subViewFrame = [tc convertRect:playerFrame toView:scrollView];
    
                if (subViewFrame.origin.y >= scrollView.contentOffset.y && subViewFrame.origin.y+tc.videoPlayerView.frame.size.height <= scrollView.contentOffset.y + scrollView.frame.size.height) {
                    playCell = tc;
                }else {
                    [tc.videoPlayerView stopVideo];
                }
            }
        }
    
    playCell.videoPlayerView.playingVideoInfo = playCell.shouldPlayVideoInfo;
    [playCell.videoPlayerView playVideo];

    
}

#pragma mark - LLAHallVideoInfoCellDelegate

- (void) userHeadViewClickedWithUserInfo:(LLAUser *) userInfo itemInfo:(LLAHallVideoItemInfo *) videoItemInfo {
    
}

- (void) loveVideoWithVideoItemInfo:(LLAHallVideoItemInfo *) videoItemInfo loveButton:(UIButton *)loveButton {

}

- (void) commentVideoWithVideoItemInfo:(LLAHallVideoItemInfo *) videoItemInfo {

}

- (void) shareVideoWithVideoItemInfo:(LLAHallVideoItemInfo *)videoItemInfo {

}

- (void) commentVideoChooseWithCommentInfo:(LLAHallVideoCommentItem *) commentInfo videoItemInfo:(LLAHallVideoItemInfo *) vieoItemInfo {
    
}

- (void) chooseUserFromComment:(LLAHallVideoCommentItem *) commentInfo userInfo:(LLAUser *)userInfo videoInfo:(LLAHallVideoItemInfo *) videoItemInfo {
    
}

@end
