//
//  LLAWhoLoveMeViewController.m
//  LLama
//
//  Created by tommin on 16/2/1.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAWhoLoveMeViewController.h"
#import "LLATableView.h"
#import "LLALoveCell.h"

#import "LLALoadingView.h"


#import "SVPullToRefresh.h"

#import "LLAHttpUtil.h"
#import "LLAViewUtil.h"

#import "LLAUser.h"

#import "LLAWhoLoveMeInfo.h"

#import "LLAUserProfileViewController.h"

@interface LLAWhoLoveMeViewController () <UITableViewDataSource, UITableViewDelegate>
{
    LLATableView *dataTableView;
 
    LLALoadingView *HUD;

    LLAWhoLoveMeInfo *mainInfo;

}

@end

@implementation LLAWhoLoveMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    // 设置导航栏
    [self initNaviItems];
    
    // 设置内部子控件
    [self initSubViews];
    
    // 注册cell
    [dataTableView registerNib:[UINib nibWithNibName:@"LLALoveCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    // 显示菊花
    [HUD show:YES];
    
    // 刷新数据
    [self loadData];

}

// 设置导航栏
- (void) initNaviItems {
    self.navigationItem.title = @"谁喜欢我";
    
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

    
    // 添加约束
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[dataTableView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataTableView)]];
    
    
    //
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
    
    LLAUser *me = [LLAUser me];
    NSString *userId = me.userIdString;
    NSString *type = @"LIKEFROM";
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
        
        
        LLAWhoLoveMeInfo *tempInfo = [LLAWhoLoveMeInfo parseJsonWithDic:responseObject];
        if (tempInfo){
            mainInfo = tempInfo;
            [dataTableView reloadData];
        }
        
        //dataTableView.showsInfiniteScrolling = mainInfo.dataList.count > 0;
        if (mainInfo.dataList.count < LLA_LOAD_DATA_DEFAULT_NUMBERS) {
            [dataTableView.infiniteScrollingView setInfiniteNoMoreLoading];
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
    
    LLAUser *me = [LLAUser me];
    NSString *userId = me.userIdString;
    NSString *type = @"LIKEFROM";
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:userId forKey:@"userId"];
    [params setValue:type forKey:@"type"];
    [params setValue:@(mainInfo.currentPage+1) forKey:@"pageNumber"];
    [params setValue:@(LLA_LOAD_DATA_DEFAULT_NUMBERS) forKey:@"pageSize"];
    
    // 发送请求
    [LLAHttpUtil httpPostWithUrl:@"/user/getLikeList" param:params responseBlock:^(id responseObject) {
        
        [dataTableView.infiniteScrollingView stopAnimating];
        
        
        LLAWhoLoveMeInfo *tempInfo = [LLAWhoLoveMeInfo parseJsonWithDic:responseObject];
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
            //[LLAViewUtil showAlter:self.view withText:LLA_LOAD_DATA_NO_MORE_TIPS];
            [dataTableView.infiniteScrollingView setInfiniteNoMoreLoading];

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
    
    LLALoveCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell) {
        cell = [[LLALoveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
        //        cell.delegate = self;
    }
    

    // 设置每个cell的数据
    [cell updateCellWithVideoInfo:mainInfo.dataList[indexPath.row] tableWidth:dataTableView.frame.size.width];

    return cell;
    
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 返回每行高度
    return 52;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LLAUserProfileViewController *userProfile = [[LLAUserProfileViewController alloc] initWithUserIdString:mainInfo.dataList[indexPath.row].userIdString];
    
    [self.navigationController pushViewController:userProfile animated:YES];

}

@end
