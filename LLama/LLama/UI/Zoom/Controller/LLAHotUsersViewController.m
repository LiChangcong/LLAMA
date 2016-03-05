//
//  LLAHotUsersViewController.m
//  LLama
//
//  Created by tommin on 16/2/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAHotUsersViewController.h"

#import "LLAHotUsersTableViewCell.h"

#import "LLAUserProfileViewController.h"


#import "LLAHttpUtil.h"
#import "LLALoadingView.h"
#import "LLAViewUtil.h"


static NSString *cellIdentifier = @"cellIdentifier";

@interface LLAHotUsersViewController () <UITableViewDataSource, UITableViewDelegate, LLAHotUsersTableViewCellDelegate>
{
    UITableView *dataTableView;
    
    LLALoadingView *HUD;

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
    
    // 菊花控件
    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];

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
    cell.delegate = self;
    if (UserTypeIsHotUsers == self.userType) {
        cell.indexPathRow = indexPath.row;
        [cell updateCellWithInfo:self.hotUsersArray[indexPath.row] tableWidth:tableView.bounds.size.width];
    }else{
        cell.indexPathRow = indexPath.row;
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
    if (self.userType == UserTypeIsHotUsers) {

        if (self.hotUsersArray[indexPath.row].userIdString.length > 0) {
            
            LLAUserProfileViewController *userProfile = [[LLAUserProfileViewController alloc] initWithUserIdString:self.hotUsersArray[indexPath.row].userIdString];
            [self.navigationController pushViewController:userProfile animated:YES];
        }
    }else{
    
        if (self.searchResultUsersArray[indexPath.row].userIdString.length > 0) {
            
            LLAUserProfileViewController *userProfile = [[LLAUserProfileViewController alloc] initWithUserIdString:self.searchResultUsersArray[indexPath.row].userIdString];
            [self.navigationController pushViewController:userProfile animated:YES];
        }

    }

}

#pragma mark - hotUsersTableViewCellDelegate

//- (void)hotUsersTableViewCellDidSelectedAttentionButton:(LLAHotUsersTableViewCell *)hotUsersTableViewCell
- (void)hotUsersTableViewCellDidSelectedAttentionButton:(LLAHotUsersTableViewCell *)hotUsersTableViewCell withIndexPathRow:(NSInteger)indexPathRow
{
    NSString *userId = nil;
    
    if (self.userType == UserTypeIsHotUsers) {
        userId = self.hotUsersArray[indexPathRow].userIdString;
    }else {
        
        userId = self.searchResultUsersArray[indexPathRow].userIdString;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:userId forKey:@"userId"];

    // 发送请求
    [LLAHttpUtil httpPostWithUrl:@"/user/zanUser" param:params responseBlock:^(id responseObject) {
        
        [HUD hide:NO];
        int tempInfo = [[responseObject valueForKey:@"followStat"] intValue];

        if (tempInfo) {
            // 更改模型中followstate状态；
            self.hotUsersArray[indexPathRow].attentionType =tempInfo;
            [dataTableView reloadData];
        }
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:NO];
        
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
        [HUD hide:NO];
        
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
        
    }];

}

#pragma mark - LLAHotUsersTableViewCellDelegate

- (void)userHeadViewTapped:(LLAUser *)userInfo
{
    if (userInfo.userIdString.length > 0) {
        
        LLAUserProfileViewController *userProfile = [[LLAUserProfileViewController alloc] initWithUserIdString:userInfo.userIdString];
        [self.navigationController pushViewController:userProfile animated:YES];
    }

}
@end
