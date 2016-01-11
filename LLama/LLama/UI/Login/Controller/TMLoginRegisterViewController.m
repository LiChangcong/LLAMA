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
}

- (IBAction)registerButtonClick:(UIButton *)sender {
    
    TMRegisterViewController *registerVC = [[TMRegisterViewController alloc] initWithNibName:nil bundle:nil];
    
    [self.navigationController pushViewController:registerVC animated:YES];


}

- (IBAction)loginButtonClick:(UIButton *)sender {
    
    TMLoginViewController *login = [[TMLoginViewController alloc] init];
    
    [self.navigationController pushViewController:login animated:YES];
}


@end
