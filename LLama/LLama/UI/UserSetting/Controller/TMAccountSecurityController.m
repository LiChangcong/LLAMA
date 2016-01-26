//
//  TMAccountSecurityController.m
//  LLama
//
//  Created by tommin on 15/12/28.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMAccountSecurityController.h"
#import "TMSwitch.h"
#import "TMChangePwdController.h"
#import "LLABoundPhonesViewController.h"

@interface TMAccountSecurityController ()

//@property (nonatomic, weak) UISwitch *witch;

@end

@implementation TMAccountSecurityController

//- (UISwitch *)witch
//{
//    if (_witch == nil) {
//        _witch = [[UISwitch alloc] init];
//    }
//    return _witch;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = TMCommonBgColor;

    
    // 去除多余的cell
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger row = 0;

    if (section == 0) {
        row = 2;
    }else{
        row = 3;
    }
    
    return row;

}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"绑定社交账号";
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor clearColor];
//    view.frame = CGRectMake(0, 0, self.view.width, 40);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.view.width,40)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;

    label.text = @"绑定社交账号";
    label.textColor = [UIColor lightGrayColor];
//    [view addSubview:label];

    return label;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TMLog(@"%li,%li",indexPath.section,indexPath.row);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];

    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"绑定手机号";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"更改密码";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;


        }
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"wechat"];
            cell.accessoryView = [[TMSwitch alloc] init];
            
        }else if (indexPath.row == 1){
            cell.imageView.image = [UIImage imageNamed:@"weibo"];
            cell.accessoryView = [[TMSwitch alloc] init];
            
        }else if (indexPath.row == 2) {
            cell.imageView.image = [UIImage imageNamed:@"qq"];
            cell.accessoryView = [[TMSwitch alloc] init];
            
        }
 
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 60;
    }else {
        return 0;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
        return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger height = 0;
    
    if (indexPath.section == 0) {
        
        height = 58;
    }else{
        height = 70;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
//        TMLog(@"点击了绑定手机号");
//        LLABoundPhonesViewController *boundPhones = [[LLABoundPhonesViewController alloc] init];
//        [self.navigationController pushViewController:boundPhones animated:YES];
        
    }else if (indexPath.section == 0 && indexPath.row == 1){
//        TMLog(@"点击了更改密码");
        TMChangePwdController *pwd = [[TMChangePwdController alloc] init];
        [self.navigationController pushViewController:pwd animated:YES];
        
    }
}


@end
