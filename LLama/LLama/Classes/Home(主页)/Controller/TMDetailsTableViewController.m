//
//  TMDetailsTableViewController.m
//  LLama
//
//  Created by tommin on 15/12/9.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMDetailsTableViewController.h"
#import "TMDetailsCell.h"
#import "TMPurseHeadCell.h"
#import "TMSignUpActorCell.h"

@interface TMDetailsTableViewController ()

@end

@implementation TMDetailsTableViewController

static NSString * const TMDetailsCellId = @"details";
static NSString * const TMSignUpActorCellId = @"signUp";



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置表格
    [self setupTable];
    
    // 设置导航栏
    [self setupNav];
}

/**
 *  设置表格
 */
- (void)setupTable
{
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TMDetailsCell class]) bundle:nil] forCellReuseIdentifier:TMDetailsCellId];
    
    [self.tableView registerClass:[TMSignUpActorCell class] forCellReuseIdentifier:TMSignUpActorCellId];
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TMPurseHeadCell class]) bundle:nil] forCellReuseIdentifier:TMPurseHeadId];
    
    // 设置背景色为蓝色
    self.view.backgroundColor = [UIColor blueColor];
    
}

/**
 *  设置导航栏
 */
- (void)setupNav
{
    // 设置标题
    self.navigationItem.title = @"详情";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        TMDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:TMDetailsCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
    
        TMSignUpActorCell *cell = [tableView dequeueReusableCellWithIdentifier:TMSignUpActorCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 300;
}
@end
