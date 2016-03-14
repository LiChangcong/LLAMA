//
//  LLALoginRegisterHomeViewController.m
//  LLama
//
//  Created by tommin on 16/3/8.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLALoginRegisterHomeViewController.h"

#import "LLANewLoginViewController.h"
#import "LLANewRegisterViewController.h"

@interface LLALoginRegisterHomeViewController ()
{
    UIImageView *bgImageView;
    UIView *contentView;
    UIButton *registerButton;
    UIButton *loginButton;
    
    UIImage *backGroundImage;
}

@end

@implementation LLALoginRegisterHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initVariables];
    [self initSubViews];
    [self initSubConstraints];

}

- (void)initVariables
{
    backGroundImage = [UIImage imageNamed:@"login-registerbg"];
}

- (void)initSubViews
{
    bgImageView = [[UIImageView alloc] init];
    bgImageView.image = backGroundImage;
//    bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:bgImageView];
    
    
    contentView =[[UIView alloc] init];
    [self.view addSubview:contentView];
    
    loginButton = [[UIButton alloc] init];
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
    loginButton.layer.borderWidth = 2;
    loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:loginButton];
    
    registerButton = [[UIButton alloc] init];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:16];
    registerButton.layer.borderWidth = 2;
    registerButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:registerButton];
    
    
}

- (void)initSubConstraints
{
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-170);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(@20);
        make.right.equalTo(loginButton.mas_left).with.offset(-20);
        make.height.equalTo(contentView);
        make.width.equalTo(loginButton);
    }];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.right.equalTo(contentView).with.offset(- 20);
        make.left.equalTo(registerButton.mas_right).with.offset(20);
        make.height.equalTo(contentView);
        make.width.equalTo(registerButton);

    }];
}

- (void)loginButtonClick
{
    LLANewLoginViewController *newLogin = [[LLANewLoginViewController alloc] init];
    [self.navigationController pushViewController:newLogin animated:YES];
}
- (void)registerButtonClick
{

    LLANewRegisterViewController *newRegister = [[LLANewRegisterViewController alloc] init];
    [self.navigationController pushViewController:newRegister animated:YES];

}
@end
