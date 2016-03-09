//
//  LLANewRetrievePasswordViewController.m
//  LLama
//
//  Created by tommin on 16/3/8.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLANewRetrievePasswordViewController.h"

@interface LLANewRetrievePasswordViewController ()
{
    UIView *inputView;
    UILabel *NumLabel;
    UITextField *phoneNumTextField;
    UIView *Hline;
    UIView *vLine;
    UITextField *verificationCodeTextField;
    UIButton *verificationCodeButton;
    UIView *Hline2;
    UITextField *newPsw;
    UIView *Hline3;
    UIButton *canSeeButton;
    
}

@end

@implementation LLANewRetrievePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initVariables];
    [self initSubViews];
    [self initSubConstraints];

}

- (void)initVariables
{
    self.view.backgroundColor = [UIColor colorWithHex:0x1e1d22];
    self.navigationItem.title = @"找回密码";
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"finishedokay"] forState:UIControlStateNormal];
    [button sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
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
    
    verificationCodeTextField = [[UITextField alloc] init];
    verificationCodeTextField.placeholder = @"输入验证码";
    [inputView addSubview:verificationCodeTextField];
    
    verificationCodeButton = [[UIButton alloc] init];
    [verificationCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
    [verificationCodeButton setBackgroundColor:[UIColor colorWithHex:0x2c293a] forState:UIControlStateNormal];
    [verificationCodeButton setTitleColor:[UIColor colorWithHex:0xa6a5a8] forState:UIControlStateNormal];
    verificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [inputView addSubview:verificationCodeButton];
    
    Hline = [[UIView alloc] init];
    Hline.backgroundColor = [UIColor colorWithHex:0x4a485b alpha:0.5];
    [inputView addSubview:Hline];
    
    vLine = [[UIView alloc] init];
    vLine.backgroundColor = [UIColor colorWithHex:0x4a485b alpha:0.5];
    [inputView addSubview:vLine];
    
    Hline2 = [[UIView alloc] init];
    Hline2.backgroundColor = [UIColor colorWithHex:0x4a485b alpha:0.5];
    [inputView addSubview:Hline2];

    newPsw =[[UITextField alloc] init];
    newPsw.placeholder = @"请输入新密码";
    [inputView addSubview:newPsw];
    
    Hline3 = [[UIView alloc] init];
    Hline3.backgroundColor = [UIColor colorWithHex:0x4a485b alpha:0.5];
    [inputView addSubview:Hline3];

    canSeeButton = [[UIButton alloc] init];
    [canSeeButton setImage:[UIImage imageNamed:@"login_eye-code"] forState:UIControlStateNormal];
    [canSeeButton setImage:[UIImage imageNamed:@"login_eye-codeh"] forState:UIControlStateSelected];
    [canSeeButton addTarget:self action:@selector(canSeeButtonButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:canSeeButton];
}

- (void)initSubConstraints
{
    /*------------------------------------*/
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(64);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@120);
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
    
    [verificationCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NumLabel.mas_bottom).with.offset(1);
        make.left.equalTo(inputView.mas_left).with.offset(20);
        make.right.equalTo(inputView.mas_right).with.offset(20);
//        make.bottom.equalTo(inputView.mas_bottom);
        make.height.equalTo(@40);
    }];
    
    [verificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verificationCodeTextField);
        make.right.equalTo(inputView.mas_right).with.offset(20);
        make.height.equalTo(verificationCodeTextField);
        make.width.equalTo(@140);
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
        make.left.equalTo(inputView.mas_left).with.offset(20);
        make.right.equalTo(inputView.mas_right).with.offset(0);
        make.top.equalTo(verificationCodeTextField.mas_bottom);
    }];
    
    [newPsw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Hline2.mas_bottom);
        make.left.equalTo(inputView.mas_left).with.offset(20);
        make.right.equalTo(inputView.mas_right).with.offset(20);
        make.bottom.equalTo(inputView.mas_bottom);

    }];

    [Hline3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.equalTo(inputView.mas_left).with.offset(20);
        make.right.equalTo(inputView.mas_right).with.offset(0);
        make.top.equalTo(newPsw.mas_bottom);
    }];

    [canSeeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(newPsw);
        make.right.equalTo(inputView.mas_right).with.offset(20);
        make.height.equalTo(newPsw);
//        make.width.equalTo(@140);
    }];
    
}

- (void)canSeeButtonButtonClick
{
    canSeeButton.selected = !canSeeButton.selected;
    
    if (canSeeButton.selected) {
        
        newPsw.secureTextEntry = YES;
    }
}

@end
