//
//  TMRegisterViewController.m
//  LLama
//
//  Created by tommin on 15/12/18.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMRegisterViewController.h"
#import "TMTabBarController.h"
#import "TMDataIconController.h"

#import "LLAViewUtil.h"
#import "LLAHttpUtil.h"
#import "LLALoadingView.h"
#import "LLACommonUtil.h"

#import "LLAThirdSDKDelegate.h"



@interface TMRegisterViewController ()
{
    LLALoadingView *HUD;
    
    NSTimer *idTimer;
    
    NSInteger timeInterval;
}


@property (weak, nonatomic) IBOutlet UITextField *cellPhoneNumerFiled;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *identityField;
@property (weak, nonatomic) IBOutlet UIButton *sendToGetIDCodeButton;

@end

@implementation TMRegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.cellPhoneNumerFiled.keyboardType = UIKeyboardTypePhonePad;
    self.passwordField.keyboardType = UIKeyboardTypeASCIICapable;
    self.identityField.keyboardType = UIKeyboardTypeASCIICapable;
//    self.identityField.backgroundColor = [UIColor colorWithHex:0xebebeb];
    
    [self.sendToGetIDCodeButton setTitle:@"发 送" forState:UIControlStateNormal];
    
    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];
    
    self.navigationItem.title = @"注 册";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)cancelButtonClick:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)okButtonClick:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    //check
    if (![LLACommonUtil validateMobile:self.cellPhoneNumerFiled.text]) {
        [LLAViewUtil showAlter:self.view withText:@"请输入正确的手机号"];
        return;
    }
    
    if (self.passwordField.text.length < 1) {
        [LLAViewUtil showAlter:self.view withText:@"请填写密码"];
        return;
    }
    
    if (self.passwordField.text.length > 16) {
        
        [LLAViewUtil showAlter:self.view withText:@"密码长度不能超过16位"];
        return;
    }
    
    if (self.identityField.text.length < 1) {
    
        [LLAViewUtil showAlter:self.view withText:@"请输入验证码"];
        return;
    }

    [HUD show:YES];
    
    //register
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:self.cellPhoneNumerFiled.text forKey:@"mobile"];
    [params setValue:self.passwordField.text forKey:@"pwd"];
    [params setValue:self.identityField.text forKey:@"smsCode"];
    
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
    
    NSString *phoneNumber = self.cellPhoneNumerFiled.text;
    
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
        [blockSelf buttonTitleTime:self.sendToGetIDCodeButton withTime:@"60"];
        
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
        
        self.sendToGetIDCodeButton.enabled = YES;
        
        [self.sendToGetIDCodeButton setTitle:@"发 送" forState:UIControlStateNormal];
        
    }else {
        self.sendToGetIDCodeButton.enabled = NO;
        
        //[self.sendToGetIDCodeButton setTitle:[NSString stringWithFormat:@"%lds后重新获取",timeInterval] forState:UIControlStateNormal];
        [self.sendToGetIDCodeButton setTitle:[NSString stringWithFormat:@"%lds后重新新获取",timeInterval] forState:UIControlStateDisabled];
        
        
        timeInterval --;
    }
}

// 点击屏幕时也推出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

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



@end
