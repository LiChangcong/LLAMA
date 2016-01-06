//
//  TMHallTableViewController.m
//  LLama
//
//  Created by tommin on 15/12/8.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMHallTableViewController.h"
#import "TMTopicCell.h"
#import "TMCommentViewController.h"
#import "TMLikeTableViewController.h"
#import "TMMoreView.h"

@interface TMHallTableViewController ()<TMTopicCellDelegate>

@end

@implementation TMHallTableViewController

static NSString * const TMTopicCellId = @"topic";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置背景色
    self.view.backgroundColor = [UIColor redColor];
    
    
    // 设置tableView
    [self setupTable];

}

- (void)setupTable
{
    // 内边距
    self.tableView.contentInset = UIEdgeInsetsMake( 64 , 0, 59, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TMTopicCell class]) bundle:nil] forCellReuseIdentifier:TMTopicCellId];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TMTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:TMTopicCellId];
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    // 设置cell的代理，点击cell中按钮后才能跳出控制器
    cell.delegate = self;

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 800;
}

// 评论模块
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TMCommentViewController *comment = [[TMCommentViewController alloc] init];

    [self.navigationController pushViewController:comment animated:YES];
}


#pragma mark - 代理
// 点赞按钮点击后显示点赞用户页面
- (void)topicCellDidClickLikeButton:(TMTopicCell *)topicCell
{
    
    TMLikeTableViewController *like = [[TMLikeTableViewController alloc] init];
    [self.navigationController pushViewController:like animated:YES];

}
#pragma mark - 代理
// 点赞按钮点击后显示点赞用户页面
- (void)topicCellDidClickMoreButton:(TMTopicCell *)topicCell
{
    TMMoreView *moreView = [TMMoreView moreView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    moreView.frame = window.bounds;
    [window addSubview:moreView];

    
}

@end
