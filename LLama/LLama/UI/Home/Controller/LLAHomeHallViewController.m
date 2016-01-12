//
//  LLAHomeHallViewController.m
//  LLama
//
//  Created by Live on 16/1/12.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAHomeHallViewController.h"
#import "LLATableView.h"

@interface LLAHomeHallViewController()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    LLATableView *dataTableView;
}

@end

@implementation LLAHomeHallViewController

#pragma mark - Life Cycle

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNaviItems];
    [self initSubViews];
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
    
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    return 0;
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
