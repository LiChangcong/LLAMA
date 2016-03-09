//
//  LLAInviteToActViewController.m
//  LLama
//
//  Created by tommin on 16/3/7.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAInviteToActViewController.h"
#import "LLAInviteToActCell.h"
#import "LLAUser.h"
#import "LLAInviteToActInfo.h"


#import "LLALoadingView.h"
#import "LLAViewUtil.h"
#import "LLAHttpUtil.h"

#import "LLAILoveWhoInfo.h"

#import "SVPullToRefresh.h"
#import "LLAUserProfileViewController.h"

static NSString *cellIdentifier = @"cellIdentifier";


@interface LLAInviteToActViewController () <UITableViewDataSource, UITableViewDelegate, LLAInviteToActCellDelegate>
{
    UITableView *dataTableView;
    
    
//    // 服务器返回的llauser数组
//    NSMutableArray< LLAUser *> *returnUserArray;

    // 待选
    NSMutableArray< LLAInviteToActInfo *> *selectedUserArray;
    
    // 选定
    NSMutableArray< LLAUser *> *hasSelectedUserArray;
    
    
    LLALoadingView *HUD;
    LLAILoveWhoInfo *mainInfo;



}
@end

@implementation LLAInviteToActViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self initNav];
    [self initVariables];
    [self initSubViews];
    [self initSubConstraints];
    
    
    // 显示菊花
    [HUD show:YES];
    
    // 刷新数据
    [self loadData];

}

- (void)initNav
{
    self.navigationItem.title = @"邀请出演";
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickFinishButton) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)initVariables
{
    hasSelectedUserArray = [NSMutableArray array];
    
    selectedUserArray = [NSMutableArray array];


}

- (void)initSubViews
{
    dataTableView = [[UITableView alloc] init];
    dataTableView.dataSource = self;
    dataTableView.delegate = self;
    dataTableView.showsVerticalScrollIndicator = NO;
    dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    dataTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:dataTableView];
    
    
    [dataTableView registerClass:[LLAInviteToActCell class] forCellReuseIdentifier:cellIdentifier];

    
    __weak typeof(self) weakSelf = self;
    
    [dataTableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadData];
    }];
    
    [dataTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreData];
    }];


}
- (void)initSubConstraints
{
    [dataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 菊花控件
    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];

}

#pragma mark -loadData

// 刷新数据
- (void) loadData {
    
    LLAUser *me = [LLAUser me];
    NSString *userId = me.userIdString;
    NSString *type = @"LIKETO";
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:userId forKey:@"userId"];
    [params setValue:type forKey:@"type"];
    [params setValue:@(0) forKey:@"pageNumber"];
    [params setValue:@(LLA_LOAD_DATA_DEFAULT_NUMBERS) forKey:@"pageSize"];
    
    // 发送请求
    [LLAHttpUtil httpPostWithUrl:@"/user/getLikeList" param:params responseBlock:^(id responseObject) {
        
        [HUD hide:NO];
        [dataTableView.pullToRefreshView stopAnimating];
        [dataTableView.infiniteScrollingView resetInfiniteScroll];
        
        LLAILoveWhoInfo *tempInfo = [LLAILoveWhoInfo parseJsonWithDic:responseObject];
        if (tempInfo){
            mainInfo = tempInfo;
            
            // 返回数据转成模型
            for (int i = 0; i < mainInfo.dataList.count; i++) {
                
                //selectedUserArray[i].inviteUser = mainInfo.dataList[i];
                LLAInviteToActInfo *info = [LLAInviteToActInfo new];
                info.inviteUser = mainInfo.dataList[i];
                [selectedUserArray addObject:info];
            }
            
            [dataTableView reloadData];
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

- (void) loadMoreData {
    
    LLAUser *me = [LLAUser me];
    NSString *userId = me.userIdString;
    NSString *type = @"LIKETO";
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:userId forKey:@"userId"];
    [params setValue:type forKey:@"type"];
    [params setValue:@(mainInfo.currentPage + 1) forKey:@"pageNumber"];
    [params setValue:@(LLA_LOAD_DATA_DEFAULT_NUMBERS) forKey:@"pageSize"];
    
    // 发送请求
    [LLAHttpUtil httpPostWithUrl:@"/user/getLikeList" param:params responseBlock:^(id responseObject) {
        
        [dataTableView.infiniteScrollingView stopAnimating];
        
        LLAILoveWhoInfo *tempInfo = [LLAILoveWhoInfo parseJsonWithDic:responseObject];
        if (tempInfo.dataList.count > 0){
            
                // 返回数据转成模型
                for (int i = 0; i < mainInfo.dataList.count; i++) {
                    
                    //selectedUserArray[i].inviteUser = mainInfo.dataList[i];
                    LLAInviteToActInfo *info = [LLAInviteToActInfo new];
                    info.inviteUser = mainInfo.dataList[i];
                    [selectedUserArray addObject:info];
                }
            
                mainInfo.currentPage = tempInfo.currentPage;
                mainInfo.pageSize = tempInfo.pageSize;
                mainInfo.isFirstPage = tempInfo.isFirstPage;
                mainInfo.isLastPage = tempInfo.isLastPage;
                mainInfo.totalPageNumbers = tempInfo.totalPageNumbers;
                mainInfo.totalDataNumbers = tempInfo.totalDataNumbers;
                
                [dataTableView reloadData];

                
        }else {
//            [dataTableView.infiniteScrollingView setInfiniteNoMoreLoading];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return selectedUserArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LLAInviteToActCell *cell = [dataTableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.indexPath = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateCellWithInfo:selectedUserArray[indexPath.row] tableWidth:tableView.bounds.size.width];

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}


#pragma mark - LLAInviteToActCellDelegate

- (void)inviteToActCellDidSelectedSelectButton:(LLAInviteToActCell *)inviteToActCell withIndexPath:(NSInteger)indexPath
{
    selectedUserArray[indexPath].selected = !selectedUserArray[indexPath].selected;
    
    if (selectedUserArray[indexPath].selected == YES) {
        [hasSelectedUserArray addObject:selectedUserArray[indexPath].inviteUser];
    }
    
    [dataTableView reloadData];
    
}


- (void)clickFinishButton
{
    self.callBack(hasSelectedUserArray);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)userHeadViewTapped:(LLAUser *)userInfo
{
    if (userInfo.userIdString.length > 0) {
        
        LLAUserProfileViewController *userProfile = [[LLAUserProfileViewController alloc] initWithUserIdString:userInfo.userIdString];
        [self.navigationController pushViewController:userProfile animated:YES];
    }


}
@end
