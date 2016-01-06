//
//  TMScriptTableViewController.m
//  LLama
//
//  Created by tommin on 15/12/8.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMScriptTableViewController.h"
#import "TMScriptCell.h"
#import "TMDetailsTableViewController.h"

@interface TMScriptTableViewController ()

@end

@implementation TMScriptTableViewController

static NSString * const TMScriptCellID = @"script";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置背景色
    self.view.backgroundColor = [UIColor blueColor];
    
    // 设置tableView
    [self setupTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupTable
{
    // 内边距
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 59, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TMScriptCell class]) bundle:nil] forCellReuseIdentifier:TMScriptCellID];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TMScriptCell *cell = [tableView dequeueReusableCellWithIdentifier:TMScriptCellID];
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 213;
}

// 约片详情模块
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TMDetailsTableViewController *details = [[TMDetailsTableViewController alloc] init];
    
    [self.navigationController pushViewController:details animated:YES];
}


@end
