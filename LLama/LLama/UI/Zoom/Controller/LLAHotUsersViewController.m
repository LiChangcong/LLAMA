//
//  LLAHotUsersViewController.m
//  LLama
//
//  Created by tommin on 16/2/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAHotUsersViewController.h"

#import "LLAHotUsersTableViewCell.h"


static NSString *cellIdentifier = @"cellIdentifier";

@interface LLAHotUsersViewController () <UITableViewDataSource, UITableViewDelegate, LLAHotUsersTableViewCellDelegate>
{
    UITableView *dataTableView;
    
    
    //
    UIColor *backGroundColor;
}
@end

@implementation LLAHotUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:0x1e1d28];
    
    if (self.userType == UserTypeIsHotUsers) {
        self.navigationItem.title = @"热门用户";
    }else {
        self.navigationItem.title = @"相关用户";
    }
    // 设置
//    [self initVariables];
    [self initSubViews];
    [self initSubConstraints];

}

- (void)initVariables
{
    backGroundColor = [UIColor colorWithHex:0x1e1d28];
}

- (void)initSubViews
{
    // dataTableView
    dataTableView = [[UITableView alloc] init];
    dataTableView.translatesAutoresizingMaskIntoConstraints = NO;
    dataTableView.dataSource = self;
    dataTableView.delegate = self;
    dataTableView.showsVerticalScrollIndicator = NO;
    dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    dataTableView.backgroundColor = backGroundColor;
    [self.view addSubview:dataTableView];
    
    [dataTableView registerClass:[LLAHotUsersTableViewCell class] forCellReuseIdentifier:cellIdentifier];

}

- (void)initSubConstraints
{

    [dataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.userType == UserTypeIsHotUsers) {
        return self.hotUsersArray.count;
    }else{
        return self.searchResultUsersArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LLAHotUsersTableViewCell *cell = [dataTableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (UserTypeIsHotUsers == self.userType) {
        [cell updateCellWithInfo:self.hotUsersArray[indexPath.row] tableWidth:tableView.bounds.size.width];
    }else{
        [cell updateCellWithInfo:self.searchResultUsersArray[indexPath.row] tableWidth:tableView.bounds.size.width];
    }
    
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

#pragma mark - tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d,%d", indexPath.section, indexPath.row);
}

#pragma mark - hotUsersTableViewCellDelegate

- (void)hotUsersTableViewCellDidSelectedAttentionButton:(LLAHotUsersTableViewCell *)hotUsersTableViewCell
{
    NSLog(@"点击了关注按钮");

    // 发送请求给服务器，代表关注了该用户
}
@end
