//
//  LLANewLoginViewController.m
//  LLama
//
//  Created by tommin on 16/3/8.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLANewLoginViewController.h"

#import "LLANewRetrievePasswordViewController.h"

@interface LLANewLoginViewController ()
{
    UIView *inputView;
    UILabel *NumLabel;
    UITextField *phoneNumTextField;
    UIView *Hline;
    UIView *vLine;
    UITextField *pswTextField;
    UIView *Hline2;

    
    UIView *btnView;
    UIButton *loginButton;
    UIButton *registButton;
    UIButton *forgetButton;
    
    UIView *thirdLoginView;
    UILabel *desLabel;
    UIView *leftLine;
    UIView *rightLine;
    UIButton *weixin;
    UIButton *weibo;
    UIButton *qq;
    
    UILabel *secretLabel;

    
}
@end

@implementation LLANewLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initVariables];
    [self initSubViews];
    [self initSubConstraints];
}

- (void)initVariables
{
    self.view.backgroundColor = [UIColor colorWithHex:0x1e1d22];
    self.navigationItem.title = @"登陆";
    
    
}

- (void)initSubViews
{
    /*------------------------------------*/
    inputView = [[UIView alloc] init];
    [self.view addSubview:inputView];
    
    NumLabel = [[UILabel alloc] init];
    NumLabel.text = @"+86";
    NumLabel.textAlignment = NSTextAlignmentCenter;
    [inputView addSubview:NumLabel];
    
    phoneNumTextField = [[UITextField alloc] init];
    phoneNumTextField.placeholder = @"填写手机号";
    [inputView addSubview:phoneNumTextField];
    
    pswTextField = [[UITextField alloc] init];
    pswTextField.placeholder = @"请输入密码";
    [inputView addSubview:pswTextField];
    
    
    Hline = [[UIView alloc] init];
    Hline.backgroundColor = [UIColor colorWithHex:0x4a485b alpha:0.5];
    [inputView addSubview:Hline];
    
    vLine = [[UIView alloc] init];
    vLine.backgroundColor = [UIColor colorWithHex:0x4a485b alpha:0.5];
    [inputView addSubview:vLine];
    
    Hline2 = [[UIView alloc] init];
    Hline2.backgroundColor = [UIColor colorWithHex:0x4a485b alpha:0.5];
    [inputView addSubview:Hline2];
    /*------------------------------------*/
    btnView = [[UIView alloc] init];
//    btnView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:btnView];
    
    loginButton = [[UIButton alloc] init];
    loginButton.backgroundColor = [UIColor colorWithHex:0x4a485b alpha:0.5];
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor colorWithHex:0xa6a5a8] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [btnView addSubview:loginButton];
    
    registButton = [[UIButton alloc] init];
    [registButton setTitle:@"没有嘿嘿账号?去注册" forState:UIControlStateNormal];
    [registButton setTitleColor:[UIColor colorWithHex:0xa6a5a8] forState:UIControlStateNormal];
    [registButton setImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
    [registButton setImage:[UIImage imageNamed:@"user"] forState:UIControlStateHighlighted];
    registButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [btnView addSubview:registButton];
    
    forgetButton = [[UIButton alloc] init];
    [forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetButton setTitleColor:[UIColor colorWithHex:0xa6a5a8] forState:UIControlStateNormal];
    [forgetButton setImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
    [forgetButton setImage:[UIImage imageNamed:@"user"] forState:UIControlStateHighlighted];
    [forgetButton addTarget:self action:@selector(forgetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [btnView addSubview:forgetButton];
    
    /*------------------------------------*/
    thirdLoginView = [[UIView alloc] init];
    [self.view addSubview:thirdLoginView];
    
    desLabel = [[UILabel alloc] init];
    desLabel.text = @"其他方式登陆";
    desLabel.font = [UIFont systemFontOfSize:12];
    desLabel.textColor = [UIColor colorWithHex:0xa6a5a8];
    [thirdLoginView addSubview:desLabel];
    
    leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = [UIColor colorWithHex:0xa6a5a8];
    [thirdLoginView addSubview:leftLine];
    
    rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = [UIColor colorWithHex:0xa6a5a8];
    [thirdLoginView addSubview:rightLine];
    
    weixin = [[UIButton alloc] init];
    [weixin setImage:[UIImage imageNamed:@"wechat-login"] forState:UIControlStateNormal];
    [weixin setImage:[UIImage imageNamed:@"wechat-loginh"] forState:UIControlStateNormal];
    [thirdLoginView addSubview:weixin];

    weibo = [[UIButton alloc] init];
    [weibo setImage:[UIImage imageNamed:@"weibo-login"] forState:UIControlStateNormal];
    [weibo setImage:[UIImage imageNamed:@"weibo-loginh"] forState:UIControlStateNormal];
    [thirdLoginView addSubview:weibo];

    qq = [[UIButton alloc] init];
    [qq setImage:[UIImage imageNamed:@"qq-login"] forState:UIControlStateNormal];
    [qq setImage:[UIImage imageNamed:@"qq-loginh"] forState:UIControlStateNormal];
    [thirdLoginView addSubview:qq];

    secretLabel = [[UILabel alloc] init];
    secretLabel.text = @"注册代表你已阅读并同意\n嘿嘿用户协议和隐私条款";
    secretLabel.numberOfLines = 0;
    secretLabel.textAlignment = NSTextAlignmentCenter;
    secretLabel.font = [UIFont systemFontOfSize:12];
    secretLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:secretLabel];
}

- (void)initSubConstraints
{
    /*------------------------------------*/
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(64);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@80);
    }];
    
    [NumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView);
        make.left.equalTo(inputView);
        make.width.equalTo(@80);
        make.height.equalTo(@40);
    }];
    
    [phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NumLabel.mas_top);
        make.left.equalTo(NumLabel.mas_right);
        make.right.equalTo(inputView.mas_right);
        make.height.equalTo(@40);
    }];
    
    [pswTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NumLabel.mas_bottom).with.offset(1);
        make.left.equalTo(inputView.mas_left).with.offset(20);
        make.right.equalTo(inputView.mas_right).with.offset(20);
        make.bottom.equalTo(inputView.mas_bottom);
    }];
    
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@1);
        make.height.equalTo(@40);
        make.top.equalTo(NumLabel.mas_top);
        make.left.equalTo(inputView).with.offset(70);
    }];
    
    [Hline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.equalTo(inputView.mas_left).with.offset(20);
        make.right.equalTo(inputView.mas_right).with.offset(10);
        make.top.equalTo(NumLabel.mas_bottom);
    }];
    
    [Hline2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.equalTo(inputView.mas_left).with.offset(0);
        make.right.equalTo(inputView.mas_right).with.offset(10);
        make.bottom.equalTo(pswTextField.mas_bottom);
    }];

    
    /*------------------------------------*/
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView.mas_bottom);;
        make.left.right.equalTo(self.view);
        make.height.equalTo(@100);
        
    }];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(btnView.mas_left).with.offset(20);
        make.right.equalTo(btnView.mas_right).with.offset(-20);
        make.height.equalTo(@40);
    }];
    
    [registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginButton.mas_bottom).with.offset(10);
        make.left.equalTo(loginButton.mas_left);
        make.height.equalTo(@20);
    }];
    
    [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginButton.mas_bottom).with.offset(10);
        make.right.equalTo(loginButton.mas_right);
        make.height.equalTo(@20);
    }];
    
    /*------------------------------------*/
    [thirdLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnView.mas_bottom).with.offset(60);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@100);
    }];
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(thirdLoginView);
        make.centerX.equalTo(thirdLoginView);
    }];
    
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(desLabel);
        make.left.equalTo(thirdLoginView.mas_left).with.offset(20);
        make.right.equalTo(desLabel.mas_left).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(desLabel);
        make.right.equalTo(thirdLoginView.mas_right).with.offset(-20);
        make.left.equalTo(desLabel.mas_right).with.offset(10);
        make.height.equalTo(@1);
    }];

    [weixin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLabel.mas_bottom).with.offset(20);
        make.centerX.equalTo(thirdLoginView);
        make.width.height.equalTo(@80);
    }];
    
    [weibo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weixin.mas_left).with.offset(-37);
        make.centerY.equalTo(weixin);
        make.width.height.equalTo(@80);
    }];
    
    [qq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weixin.mas_right).with.offset(37);
        make.centerY.equalTo(weixin);
        make.width.height.equalTo(@80);
    }];

    [secretLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-10);
        make.centerX.equalTo(self.view);
        
    }];
}


- (void)forgetButtonClick
{
    LLANewRetrievePasswordViewController *newRetrieve = [[LLANewRetrievePasswordViewController alloc] init];
    [self.navigationController pushViewController:newRetrieve animated:YES];
}
@end
