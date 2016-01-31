//
//  LLAVideoCommentViewController.m
//  LLama
//
//  Created by Live on 16/1/31.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAVideoCommentViewController.h"

//view
#import "LLATableView.h"
#import "LLALoadingView.h"

//category
#import "SVPullToRefresh.h"

//util
#import "LLAViewUtil.h"
#import "LLAHttpUtil.h"


@interface LLAVideoCommentViewController()<UITableViewDataSource,UITableViewDelegate>
{
    LLATableView *dataTableView;
    
    LLALoadingView *HUD;

}

@end

@implementation LLAVideoCommentViewController

#pragma mark - Life Cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏
    [self initNavigationItems];
    
    // 设置内部子控件
    [self initSubViews];
    
    // 显示菊花
    [HUD show:YES];
    
    // 刷新数据
    [self loadData];
}

#pragma mark - Init

- (void) initNavigationItems {
    self.title = @"评论";
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
    }];
    
    [dataTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreData];
    }];
}

#pragma mark - LoadData

- (void) loadData {
    
}

- (void) loadMoreData {
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
