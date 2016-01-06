//
//  TMPostScriptViewController.m
//  LLama
//
//  Created by tommin on 15/12/15.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMPostScriptViewController.h"

@interface TMPostScriptViewController ()

@end

@implementation TMPostScriptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 设置标题
    self.navigationItem.title = @"剧本";
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" highImage:@"backh" target:self action:@selector(backButtonClick)];
    
    // 设置导航栏背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"] forBarMetrics:UIBarMetricsDefault];
}

- (void)backButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
