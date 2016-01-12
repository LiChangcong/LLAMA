//
//  LLAHomeScriptViewController.m
//  LLama
//
//  Created by Live on 16/1/12.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAHomeScriptViewController.h"

#import "LLATableView.h"

@interface LLAHomeScriptViewController()<UITableViewDelegate,UITableViewDataSource>
{
    LLATableView *dataTableView;
}

@end

@implementation LLAHomeScriptViewController

#pragma mark - Life Cycle

- (void) viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    [self initNaviItems];
    [self initSubViews];
}

#pragma mark - Init

- (void) initNaviItems {
    self.navigationItem.title = @"剧本";
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

@end
