//
//  TMLikeTableViewController.m
//  LLama
//
//  Created by tommin on 15/12/9.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMLikeTableViewController.h"
#import "TMLikeCell.h"

@interface TMLikeTableViewController ()

@end

@implementation TMLikeTableViewController

static NSString * const TMLikeCellId = @"like";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.view.backgroundColor = [UIColor greenColor];
    
    // 设置tableView
    [self setupTable];

}

- (void)setupTable
{
    // 标题
    self.navigationItem.title = @"点赞用户";
    
    // 内边距
    self.tableView.contentInset = UIEdgeInsetsMake( 64 , 0, 10, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 禁止掉[自动设置scrollView的内边距]
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TMLikeCell class]) bundle:nil] forCellReuseIdentifier:TMLikeCellId];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TMLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:TMLikeCellId];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 104;
}

@end
