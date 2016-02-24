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

@interface LLAHotUsersViewController () <UITableViewDataSource, UITableViewDelegate>
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
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LLAHotUsersTableViewCell *cell = [dataTableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

@end
