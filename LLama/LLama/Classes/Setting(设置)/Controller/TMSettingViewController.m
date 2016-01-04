//
//  TMSettingViewController.m
//  LLama
//
//  Created by tommin on 15/12/28.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMSettingViewController.h"
#import "TMAccountSecurityController.h"
#import "TMUserAgreementViewController.h"
#import "TMFriendValidationController.h"
#import "TMClearCacheCell.h"
#import "TMSettingCell.h"
#import "TMVersionCell.h"

@interface TMSettingViewController ()

@property (strong, nonatomic) UIButton *loginBtn;

@end

@implementation TMSettingViewController

static NSString * const TMClearCacheCellId = @"clear_cache";
static NSString * const TMSettingCellId = @"setting";
static NSString * const TMVersionCellId = @"version";




- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏
    [self setUpNav];
    
    // 注册cell
    [self.tableView registerClass:[TMClearCacheCell class] forCellReuseIdentifier:TMClearCacheCellId];
    [self.tableView registerClass:[TMSettingCell class] forCellReuseIdentifier:TMSettingCellId];
    [self.tableView registerClass:[TMVersionCell class] forCellReuseIdentifier:TMVersionCellId];



    // 设置footer
    [self setUpFooter];

    
}

// 设置导航栏
- (void)setUpNav
{
    // 设置导航栏标题
    self.navigationItem.title = @"设置";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // 设置背景颜色
    self.view.backgroundColor = TMCommonBgColor;
    
    // 设置导航栏背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"] forBarMetrics:UIBarMetricsDefault];
}

- (void)setUpFooter
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 28, self.tableView.frame.size.width-2*12, 50)];
    [self.loginBtn addTarget:self action:@selector(clickedLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn setTitle:@"登 陆" forState:UIControlStateNormal];
    [self.loginBtn setTitle:@"登 出" forState:UIControlStateSelected];
    [self.loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    self.loginBtn.backgroundColor = TMYellowColor;
    
    [footerView addSubview:self.loginBtn];
    
    [self.tableView setTableFooterView:footerView];
    
}

- (void)clickedLoginBtn:(UIButton *)sender
{
    TMLog(@"点击登出按钮");
}

#pragma mark - 数据源方法
// 组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

// 每组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger row = 0;
    
    if (section == 0) {
        row = 1;
    } else {
        row = 6;
    }
    
    return row;
}

// header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

// footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    
//    if (cell == nil) {
//        
//        if ((indexPath.section == 1 && indexPath.row == 4) || (indexPath.section == 1 && indexPath.row == 5)) {
//        
//                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Tcell"];
//            
//            cell.detailTextLabel.textColor = TMYellowColor;
//            
//            
//            
//        
//        }else{
//        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        
//        }
//    }
//    
//    
//    if (indexPath.section == 0) {
//        cell.textLabel.text = @"账号与安全";
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//
//    }else{
//    
//        if (indexPath.row == 0) {
//            cell.textLabel.text = @"好友验证";
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//
//        }else if(indexPath.row == 1){
//            cell.textLabel.text = @"加V认证";
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//
//        }else if (indexPath.row == 2){
//            cell.textLabel.text = @"用户协议";
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//
//        }else if (indexPath.row == 3){
//            cell.textLabel.text = @"App评分";
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//
//        
//        }else if (indexPath.row == 4){
//            cell.textLabel.text = @"版本信息";
//            cell.detailTextLabel.text = @"1.0.2";
//        
//        }else if (indexPath.row == 5){
//            cell.textLabel.text = @"消除缓存";
//            cell.detailTextLabel.text = @"36M";
//        
//        }
//    
//    }
    
    
    
    
    if (indexPath.section == 1 && indexPath.row == 5) {
    
        TMClearCacheCell *cell =  [tableView dequeueReusableCellWithIdentifier:TMClearCacheCellId];
        return cell;
        
        
    }else if (indexPath.section == 1 && indexPath.row == 4){
    
        TMVersionCell *cell =  [tableView dequeueReusableCellWithIdentifier:TMVersionCellId];
//        cell.textLabel.text = @"版本信息";
        return cell;

    }else{
        
        TMSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:TMSettingCellId];
        
        if (indexPath.section == 0) {
            cell.textLabel.text = @"账号与安全";

        }else{
            if (indexPath.row == 0) {
                cell.textLabel.text = @"好友验证";

            }else if(indexPath.row == 1){
                
                cell.textLabel.text = @"加V认证";

            }else if(indexPath.row == 2){
                
                cell.textLabel.text = @"用户协议";

            
            }else if(indexPath.row == 3){
                
            cell.textLabel.text = @"App评分";

            }
        
        }
        
    
        return cell;

    }

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0 && indexPath.row == 0) {
        TMAccountSecurityController *accountSecurity = [[TMAccountSecurityController alloc] init];
        accountSecurity.title = @"账户安全";
        [self.navigationController pushViewController:accountSecurity animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 0){
//        TMLog(@"好友认证");
        TMFriendValidationController *fv = [[TMFriendValidationController alloc] init];
        [self.navigationController pushViewController:fv animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 1){
        TMLog(@"加V认证");

    
    }else if (indexPath.section == 1 && indexPath.row == 2){

        // 用户协议
        TMUserAgreementViewController *userAgree = [[TMUserAgreementViewController alloc] init];
        userAgree.title = @"用户协议";
        [self.navigationController pushViewController:userAgree animated:YES];

    
    }else if (indexPath.section == 1 && indexPath.row == 3){
        
        TMLog(@"App评分");

    }else if (indexPath.section == 1 && indexPath.row == 4){
        
        TMLog(@"版本信息");

        
    }else if (indexPath.section == 1 && indexPath.row == 5){
        TMLog(@"清除缓存");

    }
}
@end
