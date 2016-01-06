//
//  TMFriendValidationController.m
//  LLama
//
//  Created by tommin on 15/12/28.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMFriendValidationController.h"

@interface TMFriendValidationController ()

//@property (nonatomic, strong) UIButton *button;

@end

@implementation TMFriendValidationController

//- (UIButton *)button
//{
//    if (!_button) {
//        _button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_button setImage:[UIImage imageNamed:@"unchose"] forState:UIControlStateNormal];
//        [_button setImage:[UIImage imageNamed:@"chose"] forState:UIControlStateSelected];
//        [_button sizeToFit];
//    }
//    return _button;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = TMCommonBgColor;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    // 去除多余的cell
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"允许任何人给我发消息";
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"unchose"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"chose1"] forState:UIControlStateSelected];
        [button sizeToFit];
        cell.accessoryView = button;
    }else{
        cell.textLabel.text = @"允许好友给我发消息";
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"unchose"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"chose1"] forState:UIControlStateSelected];
        [button sizeToFit];
        button.selected = YES;
        cell.accessoryView = button;

    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}


//- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
//{
//    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
//    [footer.textLabel setTextColor:[UIColor whiteColor]];
//}


@end
