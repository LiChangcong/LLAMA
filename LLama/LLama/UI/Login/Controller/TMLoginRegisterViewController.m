//
//  TMLoginRegisterViewController.m
//  LLama
//
//  Created by tommin on 15/12/10.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMLoginRegisterViewController.h"
#import "TMRegisterViewController.h"
#import "TMLoginViewController.h"
#import "TMNavigationController.h"

@interface TMLoginRegisterViewController ()

@end

@implementation TMLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
}

- (IBAction)registerButtonClick:(UIButton *)sender {
    
    // 注册
    TMRegisterViewController *registerVC = [[TMRegisterViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:registerVC animated:YES];


}

- (IBAction)loginButtonClick:(UIButton *)sender {
    
    // 登陆
    TMLoginViewController *login = [[TMLoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
}

// 设置状态栏为黑色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
@end
