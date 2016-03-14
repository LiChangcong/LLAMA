//
//  LLANewRetrievePasswordViewController.m
//  LLama
//
//  Created by tommin on 16/3/8.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLANewRetrievePasswordViewController.h"


#import "LLAViewUtil.h"
#import "LLACommonUtil.h"
#import "LLALoadingView.h"
#import "LLAHttpUtil.h"


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
    
    
    LLALoadingView *HUD;

}

@end

@implementation LLANewRetrievePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initVariables];
    [self initSubViews];
    [self initSubConstraints];

    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];

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
    [button addTarget:self action:@selector(rightUpCornerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)initSubViews
{
    
    /*------------------------------------*/
    inputView = [[UIView alloc] init];
    [self.view addSubview:inputView];
    
    NumLabel = [[UILabel alloc] init];
    NumLabel.text = @"+86";
    NumLabel.textColor = [UIColor whiteColor];
    NumLabel.textAlignment = NSTextAlignmentCenter;
    [inputView addSubview:NumLabel];
    
    phoneNumTextField = [[UITextField alloc] init];
    phoneNumTextField.placeholder = @"填写手机号";
    phoneNumTextField.keyboardType = UIKeyboardTypePhonePad;
    phoneNumTextField.textColor = [UIColor whiteColor];
    [inputView addSubview:phoneNumTextField];
    
    verificationCodeTextField = [[UITextField alloc] init];
    verificationCodeTextField.placeholder = @"输入验证码";
    verificationCodeTextField.keyboardType = UIKeyboardTypeASCIICapable;
    verificationCodeTextField.textColor = [UIColor whiteColor];
    [inputView addSubview:verificationCodeTextField];
    
    verificationCodeButton = [[UIButton alloc] init];
    [verificationCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
    [verificationCodeButton setBackgroundColor:[UIColor colorWithHex:0x2c293a] forState:UIControlStateNormal];
    [verificationCodeButton setTitleColor:[UIColor colorWithHex:0xa6a5a8] forState:UIControlStateNormal];
    verificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [verificationCodeButton addTarget:self action:@selector(verificationCodeButtonButtonClick) forControlEvents:UIControlEventTouchUpInside];
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
    newPsw.keyboardType = UIKeyboardTypeASCIICapable;
    newPsw.textColor = [UIColor whiteColor];
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
        make.top.equalTo(self.view);
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
        make.right.equalTo(inputView.mas_right).with.offset(-20);
        make.height.equalTo(newPsw);
//        make.width.equalTo(@140);
    }];
    
}

#pragma mark - ButtonClick

- (void)canSeeButtonButtonClick
{
    canSeeButton.selected = !canSeeButton.selected;
    
    if (canSeeButton.selected) {
        
        newPsw.secureTextEntry = NO;
    }else {
        
        newPsw.secureTextEntry = YES;
    }
}


// 发送验证码
- (void)verificationCodeButtonButtonClick
{
    [self.view endEditing:YES];
    
    
    NSString *phoneNumber = phoneNumTextField.text;
    
    if (![LLACommonUtil validateMobile:phoneNumber]) {
        [LLAViewUtil showAlter:self.view withText:@"请输入正确的手机号"];
        return;
    }
    
    [HUD show:NO];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:phoneNumber forKey:@"mobile"];
    
    __weak typeof(self) blockSelf = self;
    
    [LLAHttpUtil httpPostWithUrl:@"/login/getRegSmsCode" param:params progress:NULL responseBlock:^(id responseObject) {
        //success
        [HUD hide:NO];
        
        //start count
        [blockSelf buttonTitleTime:verificationCodeButton withTime:@"60"];
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:NO];
        [LLAViewUtil showAlter:blockSelf.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        [HUD hide:NO];
        [LLAViewUtil showAlter:blockSelf.view withText:error.localizedDescription];
    }];
    
}

// 右上角确定按钮(重置密码)点击
- (void)rightUpCornerButtonClick
{
    [self.view endEditing:YES];
    
    //
    
    NSString *phoneNumber = phoneNumTextField.text;
    
    if (![LLACommonUtil validateMobile:phoneNumber]) {
        [LLAViewUtil showAlter:self.view withText:@"请输入正确的手机号"];
        return;
    }
    
    if (newPsw.text.length < 1) {
        [LLAViewUtil showAlter:self.view withText:@"请填写密码"];
        return;
    }
    
    if (newPsw.text.length > 16) {
        
        [LLAViewUtil showAlter:self.view withText:@"密码长度不能超过16位"];
        return;
    }
    
    if (verificationCodeTextField.text.length < 1) {
        
        [LLAViewUtil showAlter:self.view withText:@"请输入验证码"];
        return;
    }
    
    [HUD show:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:phoneNumber forKey:@"mobile"];
    [params setValue:newPsw.text forKey:@"pwd"];
    [params setValue:verificationCodeTextField.text forKey:@"smsCode"];
    
    //
    __weak typeof(self) blockSelf = self;
    
    [LLAHttpUtil httpPostWithUrl:@"/login/resetPwdBySms" param:params responseBlock:^(id responseObject) {
        
        //
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:YES];
        
        [LLAViewUtil showAlter:blockSelf.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
        [HUD hide:YES];
        
        [LLAViewUtil showAlter:blockSelf.view withText:error.localizedDescription];
    }];

}


- (void)buttonTitleTime:(UIButton *)button withTime:(NSString *)time
{
    __block int timeout=[time intValue]-1; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //if (isFirst) {
                [button setTitle:@"获取验证码" forState:UIControlStateNormal];
                //}else{
                [button setTitle:@"重新获取" forState:UIControlStateNormal];
                //}
                
                button.enabled = YES;
                button.alpha = 1;
                button.titleLabel.font = [UIFont llaFontOfSize:14];
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [button setTitle:[NSString stringWithFormat:@"%@s后重新获取",strTime] forState:UIControlStateDisabled];
                button.titleLabel.font = [UIFont llaFontOfSize:13];
                button.enabled = NO;
                button.alpha = 0.4;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - touchScreen
// 点击屏幕时也推出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
