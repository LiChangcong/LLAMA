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
@property(nonatomic, strong) TMRegisterViewController *registerVC;
@property(nonatomic, strong) TMLoginViewController *login;

@end

@implementation TMLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)registerButtonClick:(UIButton *)sender {
    
    TMRegisterViewController *registerVC = [[TMRegisterViewController alloc] init];
    self.registerVC = registerVC;
    
    self.registerVC.view.frame = CGRectMake(self.view.width, 0, self.view.width, self.view.height);
    [UIView animateWithDuration:0.4 animations:^{
        self.registerVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        [self.view addSubview:self.registerVC.view];
    }];


}

- (IBAction)loginButtonClick:(UIButton *)sender {
    
    TMLoginViewController *login = [[TMLoginViewController alloc] init];
    self.login = login;
    
    self.login.view.frame = CGRectMake(self.view.width, 0, self.view.width, self.view.height);
    [UIView animateWithDuration:0.4 animations:^{
        self.login.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        [self.view addSubview:self.login.view];
    }];

}


@end
