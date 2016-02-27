//
//  LLAMessageReceivedCommentController.m
//  LLama
//
//  Created by Live on 16/2/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAMessageReceivedCommentController.h"

//view
#import "LLATableView.h"
#import "LLALoadingView.h"

//util
#import "LLAViewUtil.h"

//category
#import "SVPullToRefresh.h"

@interface LLAMessageReceivedCommentController()<UITableViewDelegate,UITableViewDataSource>
{
    LLATableView *dataTableView;
}

@end

@implementation LLAMessageReceivedCommentController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initVariables];
    [self initNavigationItems];
    [self initSubViews];
    
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
    
    
}

#pragma mark - Load Data

- (void) loadData {
    
}

- (void) loadMoreData {
    
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}


@end
