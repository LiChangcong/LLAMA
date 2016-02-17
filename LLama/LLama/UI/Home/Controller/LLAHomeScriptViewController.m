//
//  LLAHomeScriptViewController.m
//  LLama
//
//  Created by Live on 16/1/12.
//  Copyright © 2016年 heihei. All rights reserved.
//

//controller
#import "LLAHomeScriptViewController.h"
#import "LLAScriptDetailViewController.h"

//view
#import "LLATableView.h"
#import "LLAScriptHallInfoCell.h"
#import "LLALoadingView.h"

//category
#import "SVPullToRefresh.h"

//model
#import "LLAScriptHallMainInfo.h"

//util
#import "LLAViewUtil.h"
#import "LLAHttpUtil.h"

@interface LLAHomeScriptViewController()<UITableViewDelegate,UITableViewDataSource,LLAScriptHallInfoCellDelegate>
{
    LLATableView *dataTableView;
    
    LLALoadingView *HUD;
    
    LLAScriptHallMainInfo *mainInfo;
}

@end

@implementation LLAHomeScriptViewController

#pragma mark - Life Cycle

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    // 初始化导航栏

    [self initNaviItems];
    
    // 初始化子控件
    [self initSubViews];
    
    // 加载数据
    [self loadData];
    
    [HUD show:YES];
}

#pragma mark - Init
// 初始化导航栏
- (void) initNaviItems {
    self.navigationItem.title = @"剧本";
}

// 初始化子控件
- (void) initSubViews {
    
    // tableView
    dataTableView = [[LLATableView alloc] init];
    dataTableView.translatesAutoresizingMaskIntoConstraints = NO;
    dataTableView.dataSource = self;
    dataTableView.delegate = self;
    dataTableView.showsVerticalScrollIndicator = NO;
    dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    dataTableView.backgroundColor = [UIColor colorWithHex:0xf1f1f1];
    [self.view addSubview:dataTableView];
    

    __weak typeof(self) weakSelf = self;
    
    [dataTableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadData];
    }];
    
    [dataTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreData];
    }];
    
    //constraints
    

 
    // 约束
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
    
    // 显示加载菊花
    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];
}

#pragma mark - Load Data
 // 加载数据
- (void) loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@(0) forKey:@"pageNumber"];
    [params setValue:@(LLA_LOAD_DATA_DEFAULT_NUMBERS) forKey:@"pageSize"];
    
    [LLAHttpUtil httpPostWithUrl:@"/play/getUnfinishedPlayList" param:params responseBlock:^(id responseObject) {
        
        [HUD hide:NO];
        [dataTableView.pullToRefreshView stopAnimating];
        [dataTableView.infiniteScrollingView resetInfiniteScroll];
        
        LLAScriptHallMainInfo *tempInfo = [LLAScriptHallMainInfo parseJsonWithDic:responseObject];
        if (tempInfo){
            mainInfo = tempInfo;
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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@(mainInfo.currentPage+1) forKey:@"pageNumber"];
    [params setValue:@(LLA_LOAD_DATA_DEFAULT_NUMBERS) forKey:@"pageSize"];
    
    [LLAHttpUtil httpPostWithUrl:@"/play/getUnfinishedPlayList" param:params responseBlock:^(id responseObject) {
        
        [dataTableView.infiniteScrollingView stopAnimating];
        
        LLAScriptHallMainInfo *tempInfo = [LLAScriptHallMainInfo parseJsonWithDic:responseObject];
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
    return mainInfo.dataList.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIden = @"cellIden";
    
    LLAScriptHallInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell) {
        cell = [[LLAScriptHallInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
        cell.delegate = self;
    }
    
    // 给cell设置数据
    [cell updateCellWithScriptInfo:mainInfo.dataList[indexPath.row] tableWidth:tableView.frame.size.width];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 返回每行cell的高度
    return [LLAScriptHallInfoCell calculateHeightWithScriptInfo:mainInfo.dataList[indexPath.row] tableWidth:tableView.frame.size.width];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 每行cell的模型
    LLAScriptHallItemInfo *scriptInfo = mainInfo.dataList[indexPath.row];
    
    // 传入对于的剧本ID跳到对应剧本详情页
    LLAScriptDetailViewController *scriptDetail = [[LLAScriptDetailViewController alloc] initWithScriptIdString:scriptInfo.scriptIdString];
    [self.navigationController pushViewController:scriptDetail animated:YES];
    
}

#pragma mark - LLAScriptHallInfoCellDelegate

- (void) userHeadViewTapped:(LLAUser *)userInfo scriptInfo:(LLAScriptHallItemInfo *)scriptInfo {
    //go to user profile
}

@end
