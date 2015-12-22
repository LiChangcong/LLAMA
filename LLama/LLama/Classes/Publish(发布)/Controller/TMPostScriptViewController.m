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
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" highImage:@"backh" target:self action:@selector(backButtonClick)];
    
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
