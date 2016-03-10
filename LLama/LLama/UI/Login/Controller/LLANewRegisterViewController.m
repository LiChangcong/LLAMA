//
//  LLANewRegisterViewController.m
//  LLama
//
//  Created by tommin on 16/3/9.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLANewRegisterViewController.h"

#import "LLANewRetrievePasswordViewController.h"
#import "TMTabBarController.h"
#import "TMDataIconController.h"
#import "LLAUserAgreementViewController.h"

#import "LLAThirdSDKDelegate.h"
#import "LLAViewUtil.h"
#import "LLALoadingView.h"
#import "LLACommonUtil.h"
#import "LLAHttpUtil.h"



@interface LLANewRegisterViewController ()
{
    UIView *inputView;
    UILabel *NumLabel;
    UITextField *phoneNumTextField;
    UIView *Hline;
    UIView *vLine;
    UITextField *VerificationCodeTextField;
    UIButton *VerificationCodeButton;
    UIView *Hline2;
    UITextField *pswTextField;
    
    
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
    
    
    LLALoadingView *HUD;
    
    NSTimer *idTimer;
    
    NSInteger timeInterval;


}

@end

@implementation LLANewRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initVariables];
    [self initSubViews];
    [self initSubConstraints];

    
    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];

    // 隐藏三方登陆按钮
    if (![QQApiInterface isQQInstalled]) {
        qq.hidden = YES;
    }
    if (![WXApi isWXAppInstalled]) {
        weixin.hidden = YES;
    }

}

- (void)initVariables
{
    self.view.backgroundColor = [UIColor colorWithHex:0x1e1d22];
    self.navigationItem.title = @"注册";
    
    
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
    phoneNumTextField.keyboardType = UIKeyboardTypePhonePad;
    [inputView addSubview:phoneNumTextField];
    
    VerificationCodeTextField = [[UITextField alloc] init];
    VerificationCodeTextField.placeholder = @"请输入验证码";
    VerificationCodeTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [inputView addSubview:VerificationCodeTextField];
    
    VerificationCodeButton = [[UIButton alloc] init];
    [VerificationCodeButton setTitle:@"发 送" forState:UIControlStateNormal];
    [VerificationCodeButton addTarget:self action:@selector(sendToGetIdCodeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:VerificationCodeButton];
    
    Hline = [[UIView alloc] init];
    Hline.backgroundColor = [UIColor colorWithHex:0x4a485b alpha:0.5];
    [inputView addSubview:Hline];
    
    vLine = [[UIView alloc] init];
    vLine.backgroundColor = [UIColor colorWithHex:0x4a485b alpha:0.5];
    [inputView addSubview:vLine];
    
    Hline2 = [[UIView alloc] init];
    Hline2.backgroundColor = [UIColor colorWithHex:0x4a485b alpha:0.5];
    [inputView addSubview:Hline2];
    
    pswTextField = [[UITextField alloc] init];
    pswTextField.placeholder = @"请输入密码";
    pswTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [inputView addSubview:pswTextField];
    
    /*------------------------------------*/
    btnView = [[UIView alloc] init];
    //    btnView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:btnView];
    
    loginButton = [[UIButton alloc] init];
    loginButton.backgroundColor = [UIColor colorWithHex:0x4a485b alpha:0.5];
    [loginButton setTitle:@"注册" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor colorWithHex:0xa6a5a8] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:loginButton];
    
    registButton = [[UIButton alloc] init];
    [registButton setTitle:@"已有嘿嘿账号?去登陆" forState:UIControlStateNormal];
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
    [weixin addTarget:self action:@selector(weChatLogin:) forControlEvents:UIControlEventTouchUpInside];
    [thirdLoginView addSubview:weixin];
    
    weibo = [[UIButton alloc] init];
    [weibo setImage:[UIImage imageNamed:@"weibo-login"] forState:UIControlStateNormal];
    [weibo setImage:[UIImage imageNamed:@"weibo-loginh"] forState:UIControlStateNormal];
    [weibo addTarget:self action:@selector(sinaWeiBoLogin:) forControlEvents:UIControlEventTouchUpInside];
    [thirdLoginView addSubview:weibo];
    
    qq = [[UIButton alloc] init];
    [qq setImage:[UIImage imageNamed:@"qq-login"] forState:UIControlStateNormal];
    [qq setImage:[UIImage imageNamed:@"qq-loginh"] forState:UIControlStateNormal];
    [qq addTarget:self action:@selector(qqLogin:) forControlEvents:UIControlEventTouchUpInside];
    [thirdLoginView addSubview:qq];
    
    secretLabel = [[UILabel alloc] init];
    secretLabel.text = @"注册代表你已阅读并同意\n嘿嘿用户协议和隐私条款";
    secretLabel.numberOfLines = 0;
    secretLabel.textAlignment = NSTextAlignmentCenter;
    secretLabel.font = [UIFont systemFontOfSize:12];
    secretLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:secretLabel];
    
    // 添加手势
    UITapGestureRecognizer *tapSecretLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSecretLabel)];
    secretLabel.userInteractionEnabled = YES;
    [secretLabel addGestureRecognizer:tapSecretLabel];

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
    
    [VerificationCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.left.equalTo(inputView.mas_left).with.offset(20);
        make.right.equalTo(inputView.mas_right).with.offset(10);
        make.bottom.equalTo(VerificationCodeTextField.mas_bottom);
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

#pragma mark - ButtonClick


- (IBAction)sinaWeiBoLogin:(id)sender {
    
    [[LLAThirdSDKDelegate shareInstance] thirdLoginWithType:UserLoginType_SinaWeiBo loginCallBack:^(NSString *openId, NSString *accessToken, LLAThirdLoginState state, NSError *error) {
        
        if (state == LLAThirdLoginState_Success) {
            
            LLAUser *user = [LLAUser new];
            user.loginType = UserLoginType_SinaWeiBo;
            user.sinaWeiBoUid = [openId integerValue];
            user.sinaWeiBoAccess_Token = accessToken;
            
            //fetch UserInfo
            
            [self fetchUserInfoWithUser:user loginType:UserLoginType_SinaWeiBo];
            
        }else {
            [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
        }
        
    }];
}

- (IBAction)weChatLogin:(id)sender {
    
    [[LLAThirdSDKDelegate shareInstance] thirdLoginWithType:UserLoginType_WeChat loginCallBack:^(NSString *openId, NSString *accessToken, LLAThirdLoginState state, NSError *error) {
        
        if (state == LLAThirdLoginState_Success) {
            
            LLAUser *user = [LLAUser new];
            user.loginType = UserLoginType_WeChat;
            user.weChatOpenId = openId;
            user.weChatAccess_Token = accessToken;
            
            //fetch token;
            [self fetchUserInfoWithUser:user loginType:UserLoginType_WeChat];
            
        }else {
            [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
        }
        
    }];
    
}

- (IBAction)qqLogin:(id)sender {
    
    [[LLAThirdSDKDelegate shareInstance]  thirdLoginWithType:UserLoginType_QQ loginCallBack:^(NSString *openId, NSString *accessToken, LLAThirdLoginState state, NSError *error) {
        
        if (state == LLAThirdLoginState_Success) {
            LLAUser *user = [LLAUser new];
            
            user.loginType = UserLoginType_QQ;
            user.qqOpenId = openId;
            user.qqAccess_Token = accessToken;
            //fetch
            
            [self fetchUserInfoWithUser:user loginType:UserLoginType_QQ];
            
            
        }else {
            [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
        }
        
    }];
}

- (void) fetchUserInfoWithUser:(LLAUser *) user loginType:(UserLoginType)loginType{
    
    [HUD show:YES];
    
    __weak typeof(self) blockSelf = self;
    
    [[LLAThirdSDKDelegate shareInstance] fetchUserAccessTokenInfoWithInfo:user callBack:^(NSString *token, NSError *error) {
        if (token) {
            //fetch userInfo
            
            [[LLAThirdSDKDelegate shareInstance] fetchUserInfoWithUserToken:token callBack:^(LLAUser *userInfo, NSError *error) {
                
                [HUD hide:YES];
                
                if (error) {
                    [LLAViewUtil showAlter:blockSelf.view withText:error.localizedDescription];
                }else {
                    
                    //login success,save userInfo to disk
                    userInfo.loginType = loginType;
                    
                    [blockSelf loginSuccessWithUser:userInfo];
                    
                }
            }];
            
        }else{
            [HUD hide:YES];
            [LLAViewUtil showAlter:blockSelf.view withText:error.localizedDescription];
        }
    }];
}

- (void) loginSuccessWithUser:(LLAUser *)newUser {
    
    [LLAUser updateUserInfo:newUser];
    
    if ([newUser hasUserProfile]) {
        
        //
        TMTabBarController *tabController = [[TMTabBarController alloc] init];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = tabController;
    }else {
        //show finish userProfileController
        TMDataIconController *finishProfile = [TMDataIconController new];
        [self.navigationController pushViewController:finishProfile animated:YES];
        
    }
}

/*-----------------------------------------*/

// 忘记密码
- (void)forgetButtonClick
{
    LLANewRetrievePasswordViewController *newRetrieve = [[LLANewRetrievePasswordViewController alloc] init];
    [self.navigationController pushViewController:newRetrieve animated:YES];
}

// 点击注册
-(void)loginButtonClick
{
    [self.view endEditing:YES];
    
    //check
    if (![LLACommonUtil validateMobile:phoneNumTextField.text]) {
        [LLAViewUtil showAlter:self.view withText:@"请输入正确的手机号"];
        return;
    }
    
    if (pswTextField.text.length < 1) {
        [LLAViewUtil showAlter:self.view withText:@"请填写密码"];
        return;
    }
    
    if (pswTextField.text.length > 16) {
        
        [LLAViewUtil showAlter:self.view withText:@"密码长度不能超过16位"];
        return;
    }
    
    if (VerificationCodeTextField.text.length < 1) {
        
        [LLAViewUtil showAlter:self.view withText:@"请输入验证码"];
        return;
    }
    
    [HUD show:YES];
    
    //register
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:phoneNumTextField.text forKey:@"mobile"];
    [params setValue:pswTextField.text forKey:@"pwd"];
    [params setValue:VerificationCodeTextField.text forKey:@"smsCode"];
    
    __weak  typeof(self) blockSelf = self;
    
    [LLAHttpUtil httpPostWithUrl:@"/login/mobileReg" param:params progress:NULL responseBlock:^(id responseObject) {
        
        //[HUD hide:YES];
        
        NSString *token = [responseObject valueForKey:@"token"];
        
        if ([token isKindOfClass:[NSString class]]) {
            [[LLAThirdSDKDelegate shareInstance] fetchUserInfoWithUserToken:token callBack:^(LLAUser *userInfo, NSError *error) {
                
                [HUD hide:YES];
                
                if (error) {
                    [LLAViewUtil showAlter:blockSelf.view withText:error.localizedDescription];
                }else {
                    
                    //login success,save userInfo to disk
                    userInfo.loginType = UserLoginType_MobilePhone;
                    
                    [blockSelf loginSuccessWithUser:userInfo];
                }
            }];
            
        }else {
            [HUD hide:YES];
            [LLAViewUtil showAlter:blockSelf.view withText:@"无效的token"];
        }
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:YES];
        [LLAViewUtil showAlter:blockSelf.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
        [HUD hide:YES];
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
    }];


}



- (IBAction)sendToGetIdCodeClicked:(id)sender {
    //
    
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
        [blockSelf buttonTitleTime:VerificationCodeButton withTime:@"60"];
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:NO];
        [LLAViewUtil showAlter:blockSelf.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        [HUD hide:NO];
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

- (void) timeCount {
    
    if (idTimer) {
        [idTimer invalidate];
        idTimer = nil;
    }
    
    idTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(nextIntervalToGetIDTimerCount) userInfo:nil repeats:YES];
    timeInterval = 60;
    
    [self nextIntervalToGetIDTimerCount];
    
}

- (void) nextIntervalToGetIDTimerCount {
    if (timeInterval < 0) {
        [idTimer invalidate];
        idTimer = nil;
        
        VerificationCodeButton.enabled = YES;
        
        [VerificationCodeButton setTitle:@"发 送" forState:UIControlStateNormal];
        
    }else {
        VerificationCodeButton.enabled = NO;
        
        //[self.sendToGetIDCodeButton setTitle:[NSString stringWithFormat:@"%lds后重新获取",timeInterval] forState:UIControlStateNormal];
        [VerificationCodeButton setTitle:[NSString stringWithFormat:@"%lds后重新新获取",timeInterval] forState:UIControlStateDisabled];
        
        
        timeInterval --;
    }
}

#pragma mark - touchScreen
// 点击屏幕时也推出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


#pragma mark - tapUserPrivacyLabel

- (void)tapSecretLabel
{
    //    NSLog(@"点击了用户隐私");
    LLAUserAgreementViewController *userAgreement = [[LLAUserAgreementViewController alloc] init];
    [self.navigationController pushViewController:userAgreement animated:YES];
    
}


@end
