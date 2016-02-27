//
//  LLAMessageReceivedPraiseController.m
//  LLama
//
//  Created by Live on 16/2/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

//controller
#import "LLAMessageReceivedPraiseController.h"

//view
#import "LLATableView.h"
#import "LLALoadingView.h"
#import "LLAMessageReceivedPraiseCell.h"

//util
#import "LLAViewUtil.h"

//model
#import "LLAMessageReceivedPraiseItemInfo.h"

//category
#import "SVPullToRefresh.h"

@interface LLAMessageReceivedPraiseController()<UITableViewDataSource,UITableViewDelegate>
{
    LLATableView *dataTableView;
    
    NSMutableArray *dataArray;
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
    
}

#pragma mark - Init

- (void) initVariables {
    dataArray = [NSMutableArray array];
    
    LLAMessageReceivedPraiseItemInfo *itemInfo = [LLAMessageReceivedPraiseItemInfo new];
    
    itemInfo.authorUser = [LLAUser me];
    itemInfo.editTimeString = @"刚刚";
    itemInfo.manageContent = @"赞了你的视频";
    itemInfo.infoImageURL = @"http://www.baidu.com";
    
    [dataArray addObject:itemInfo];
    
    LLAMessageReceivedPraiseItemInfo *itemInfo1 = [LLAMessageReceivedPraiseItemInfo new];
    
    itemInfo1.authorUser = [LLAUser me];
    itemInfo1.editTimeString = @"刚刚";
    itemInfo1.manageContent = @"赞了你的视频";
    
    
    [dataArray addObject:itemInfo1];

    
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
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *praiseIden = @"praiseIden";
    
    LLAMessageReceivedPraiseCell *cell = [tableView dequeueReusableCellWithIdentifier:praiseIden];
    if (!cell) {
        cell = [[LLAMessageReceivedPraiseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:praiseIden];
    }
    
    [cell updateCellWithInfo:dataArray[indexPath.row] tableWidth:tableView.bounds.size.width];
    return cell;
                            
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LLAMessageReceivedPraiseCell calculateHeightWithInfo:dataArray[indexPath.row] tableWidth:tableView.bounds.size.width];
}

@end
