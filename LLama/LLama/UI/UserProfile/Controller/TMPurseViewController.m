//
//  TMPurseViewController.m
//  LLama
//
//  Created by tommin on 15/12/19.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMPurseViewController.h"
#import "TMPurseHeadCell.h"
#import "TMTHistoryCell.h"
#import "TMNoticeView.h"

@interface TMPurseViewController ()<TMPurseHeadCellDelegate>

@end

@implementation TMPurseViewController

static NSString * const  TMPurseHeadCellId = @"purseHead";
static NSString * const  TMTHistoryCellId= @"history";


- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置导航栏背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"] forBarMetrics:UIBarMetricsDefault];
    
    // 状态栏设置为白色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    // 设置状态栏标题
    self.navigationItem.title = @"账户余额";
    
    // 内边距
    self.tableView.contentInset = UIEdgeInsetsMake( 64 , 0, 10, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 禁止掉[自动设置scrollView的内边距]
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 注册头部cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TMPurseHeadCell class]) bundle:nil] forCellReuseIdentifier:TMPurseHeadCellId];
    
    // 注册历史明细
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TMTHistoryCell class]) bundle:nil] forCellReuseIdentifier:TMTHistoryCellId];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        TMPurseHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:TMPurseHeadCellId];
        // 设置代理
        cell.delegate = self;
        return cell;
        
    }else{
        
        TMTHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:TMTHistoryCellId];
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
    
        return 400;
    }else{
        
        return 63;
        
    }

}

// 点赞按钮点击后显示点赞用户页面
- (void)purseHeadCellDidClickPurseButton:(TMPurseHeadCell *)purseHeadCell
{
    TMNoticeView *noticeView = [TMNoticeView noticeView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    noticeView.frame = window.bounds;
    [window addSubview:noticeView];
    
    
}


@end
