//
//  TMDirectorTableViewController.m
//  LLama
//
//  Created by tommin on 15/12/19.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMDirectorTableViewController.h"
#import "TMTopicCell.h"

@interface TMDirectorTableViewController ()

@end

@implementation TMDirectorTableViewController

static NSString * const TMTopicCellId = @"topic";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@"%s",__func__);
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TMTopicCell class]) bundle:nil] forCellReuseIdentifier:TMTopicCellId];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    TMTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:TMTopicCellId];
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 800;
    
}

@end
