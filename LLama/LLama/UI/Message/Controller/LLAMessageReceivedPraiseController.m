//
//  LLAMessageReceivedPraiseController.m
//  LLama
//
//  Created by Live on 16/2/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

//controller
#import "LLAMessageReceivedPraiseController.h"
#import "LLAScriptDetailViewController.h"

//view
#import "LLATableView.h"
#import "LLALoadingView.h"
#import "LLAMessageReceivedPraiseCell.h"

//util
#import "LLAViewUtil.h"
#import "LLAHttpUtil.h"

//model
#import "LLAMessageReceivedPraiseItemInfo.h"
#import "LLAMessageReceivedPraiseMainInfo.h"

//category
#import "SVPullToRefresh.h"

@interface LLAMessageReceivedPraiseController()<UITableViewDataSource,UITableViewDelegate>
{
    LLATableView *dataTableView;
    
    LLAMessageReceivedPraiseMainInfo *mainInfo;
    
    LLALoadingView *HUD;
}

@end

@implementation LLAMessageReceivedPraiseController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initVariables];
    [self initNavigationItems];
    [self initSubViews];
    
    [HUD show:YES];
    
    [self loadData];
    
}

#pragma mark - Init

- (void) initVariables {
    
}

- (void) initNavigationItems {
    self.navigationItem.title = @"收到的赞";
}

- (void) initSubViews {
    
    dataTableView = [[LLATableView alloc] init];
    dataTableView.translatesAutoresizingMaskIntoConstraints = NO;
    dataTableView.dataSource = self;
    dataTableView.delegate = self;
    dataTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    dataTableView.backgroundColor = [UIColor colorWithHex:0x211f2c];
    
    [self.view addSubview:dataTableView];
    
    __weak typeof(self) blockSelf = self;
    
    [dataTableView addPullToRefreshWithActionHandler:^{
        [blockSelf loadData];
    }];
    
    [dataTableView addInfiniteScrollingWithActionHandler:^{
        [blockSelf loadMoreData];
    }];
    
    //
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

#pragma mark - Load Data

- (void) loadData {
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setValue:@"ZAN" forKey:@"type"];
    [paramDic setValue:@(0) forKey:@"pageNumber"];
    [paramDic setValue:@(LLA_LOAD_DATA_DEFAULT_NUMBERS) forKey:@"pageSize"];
    
    [LLAHttpUtil httpPostWithUrl:@"/message/getNotifyByType" param:paramDic responseBlock:^(id responseObject) {
        
        [HUD hide:NO];
        [dataTableView.pullToRefreshView stopAnimating];
        [dataTableView.infiniteScrollingView resetInfiniteScroll];
        
        LLAMessageReceivedPraiseMainInfo *tempInfo = [LLAMessageReceivedPraiseMainInfo parseJsonWithDic:responseObject];
        if (tempInfo){
            mainInfo = tempInfo;
            [dataTableView reloadData];
            //
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
    
    [params setValue:@"ZAN" forKey:@"type"];
    [params setValue:@(mainInfo.currentPage+1) forKey:@"pageNumber"];
    [params setValue:@(LLA_LOAD_DATA_DEFAULT_NUMBERS) forKey:@"pageSize"];
    
    [LLAHttpUtil httpPostWithUrl:@"/message/getNotifyByType" param:params responseBlock:^(id responseObject) {
        
        [dataTableView.infiniteScrollingView stopAnimating];
        
        LLAMessageReceivedPraiseMainInfo *tempInfo = [LLAMessageReceivedPraiseMainInfo parseJsonWithDic:responseObject];
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

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mainInfo.dataList.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *praiseIden = @"praiseIden";
    
    LLAMessageReceivedPraiseCell *cell = [tableView dequeueReusableCellWithIdentifier:praiseIden];
    if (!cell) {
        cell = [[LLAMessageReceivedPraiseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:praiseIden];
    }
    
    [cell updateCellWithInfo:mainInfo.dataList[indexPath.row] tableWidth:tableView.bounds.size.width];
    return cell;
                            
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //
    LLAMessageReceivedPraiseItemInfo *orderItem = mainInfo.dataList[indexPath.row];
    
    LLAScriptDetailViewController *detail = [[LLAScriptDetailViewController alloc] initWithScriptIdString:orderItem.scriptIdString];
    
    [self.navigationController pushViewController:detail animated:YES];

    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LLAMessageReceivedPraiseCell calculateHeightWithInfo:mainInfo.dataList[indexPath.row] tableWidth:tableView.bounds.size.width];
}

@end
