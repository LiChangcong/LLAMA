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
    
    TMRegisterViewController *registerVC = [[TMRegisterViewController alloc] initWithNibName:nil bundle:nil];
    
    [self.navigationController pushViewController:registerVC animated:YES];


}

- (IBAction)loginButtonClick:(UIButton *)sender {
    
    TMLoginViewController *login = [[TMLoginViewController alloc] init];
    
    [self.navigationController pushViewController:login animated:YES];
}

// 更改状态栏颜色是黑色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
@end
