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

//model
#import "LLAHallMainInfo.h"

//util
#import "LLAViewUtil.h"
#import "LLAHttpUtil.h"

@interface LLAHomeHallViewController()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
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
    
    [self initNaviItems];
    [self initSubViews];
    
    [HUD show:YES];
    [self loadData];
    
    //
}

#pragma mark - Init

- (void) initNaviItems {
    self.navigationItem.title = @"大厅";
}

- (void) initSubViews {
    
    dataTableView = [[LLATableView alloc] init];
    dataTableView.translatesAutoresizingMaskIntoConstraints = NO;
    dataTableView.dataSource = self;
    dataTableView.delegate = self;
    dataTableView.showsVerticalScrollIndicator = NO;
    dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:dataTableView];
    
    //constraints
    
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
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@(0) forKey:@"pageNumber"];
    [params setValue:@(LLA_LOAD_DATA_DEFAULT_NUMBERS) forKey:@"pageSize"];
    
    [LLAHttpUtil httpPostWithUrl:@"/play/getFinishedPlayList" param:params responseBlock:^(id responseObject) {
        
        [HUD hide:NO];
        
        LLAHallMainInfo *tempInfo = [LLAHallMainInfo parseJsonWithDic:responseObject];
        if (tempInfo){
            mainInfo = tempInfo;
            [dataTableView reloadData];
        }
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:NO];
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
        [HUD hide:NO];
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
        
    }];
}

- (void) loadMoreData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@(mainInfo.currentPage+1) forKey:@"pageNumber"];
    [params setValue:@(LLA_LOAD_DATA_DEFAULT_NUMBERS) forKey:@"pageSize"];
    
    [LLAHttpUtil httpPostWithUrl:@"/play/getFinishedPlayList" param:params responseBlock:^(id responseObject) {
        
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
        
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
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
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void) tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

@end
