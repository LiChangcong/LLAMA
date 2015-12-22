//
//  TMILikeViewController.m
//  LLama
//
//  Created by tommin on 15/12/21.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMILikeViewController.h"
#import "TMProfileLikeCell.h"

@interface TMILikeViewController ()

@end

@implementation TMILikeViewController

static NSString * const TMProfileLikeCellId = @"like";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置背景色
    self.view.backgroundColor = [UIColor greenColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TMProfileLikeCell class]) bundle:nil] forCellReuseIdentifier:TMProfileLikeCellId];
    
    // 内边距
    self.tableView.contentInset = UIEdgeInsetsMake( 64 , 0, 10, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 禁止掉[自动设置scrollView的内边距]
    self.automaticallyAdjustsScrollViewInsets = NO;


}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TMProfileLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:TMProfileLikeCellId];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}



@end
