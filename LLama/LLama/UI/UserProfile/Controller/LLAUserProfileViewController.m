//
//  LLAUserProfileViewController.m
//  LLama
//
//  Created by Live on 16/1/12.
//  Copyright © 2016年 heihei. All rights reserved.
//

//controller
#import "LLAUserProfileViewController.h"

//view
#import "LLATableView.h"

#import "LLALoadingView.h"

//category
#import "UIScrollView+SVPullToRefresh.h"

//model

//util
#import "LLAViewUtil.h"
#import "LLAHttpUtil.h"

@interface LLAUserProfileViewController()<UITableViewDelegate,UITableViewDataSource>
{
    LLATableView *dataTableView;
    
    LLALoadingView *HUD;
}

@end

@implementation LLAUserProfileViewController

#pragma mark - Life Cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationItems];
    [self initSubViews];
}

- (void) initNavigationItems {
    
}

- (void) initSubViews {
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
    
    //first,load user data,then load video data
    
}

- (void) loadMoreData {
    
    //load more video data
    
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //
}



@end
