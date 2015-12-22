//
//  TMProfileViewController.m
//  LLama
//
//  Created by tommin on 15/12/7.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMProfileViewController.h"
#import "TMActorTableViewController.h"
#import "TMDirectorTableViewController.h"

@interface TMProfileViewController ()

@end

@implementation TMProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 设置个人头像
    self.personIconImage = [UIImage imageNamed:@"meinv"];
    
    // 设置个人明信片
    self.personCardImage = [UIImage imageNamed:@"backGD"];
    
    // 设置导航条标题
    self.navigationItem.title = @"Cathywood";
    
    // 设置状态栏颜色为黑色
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    
    // 添加子控制器，需要显示几个子控制器的tableView就添加几个，跟UITabBarController用法一样。
    // tabBar上按钮的标题 = 子控制器的标题
    // 我导的片儿
    TMDirectorTableViewController *directorVC = [[TMDirectorTableViewController alloc] init];
    directorVC.title = @"我演的片儿";
    [self addChildViewController:directorVC];
    
    // 我演的片儿
    TMActorTableViewController *actorVC = [[TMActorTableViewController alloc] init];
    actorVC.title = @"我演的片儿";
    [self addChildViewController:actorVC];
    
    
}

@end
