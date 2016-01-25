//
//  LLAUserAccountWithdrawCashViewController.m
//  LLama
//
//  Created by Live on 16/1/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

//controller
#import "LLAUserAccountWithdrawCashViewController.h"

//view
#import "LLALoadingView.h"
#import "LLATableView.h"

//category

//model

//util
#import "LLAViewUtil.h"

@interface LLAUserAccountWithdrawCashViewController()<UITableViewDataSource,UITableViewDelegate>

{
    LLATableView *dataTableView;
    
    LLALoadingView *HUD;
}

@end

@implementation LLAUserAccountWithdrawCashViewController

#pragma mark - Life Cycle

- (void) viewDidLoad {

    [super viewDidLoad];
    
}

#pragma mark - Init

- (void) initVariables {
    
}

- (void) initNavigationItems {
    self.navigationItem.title = @"提现信息";
}

- (void) initSubViews {

    dataTableView = [[LLATableView alloc] init];
    dataTableView.translatesAutoresizingMaskIntoConstraints = NO;
    dataTableView.dataSource = self;
    dataTableView.delegate = self;
    dataTableView.showsVerticalScrollIndicator = NO;
    dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    dataTableView.backgroundColor = [UIColor colorWithHex:0xeaeaea];
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

@end
