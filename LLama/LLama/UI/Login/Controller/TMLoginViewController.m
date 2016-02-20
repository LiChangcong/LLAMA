//
//  TMLoginViewController.m
//  LLama
//
//  Created by tommin on 15/12/10.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMLoginViewController.h"
#import "TMTabBarController.h"
#import "TMRetrievePasswordViewController.h"
#import "TMRegisterViewController.h"
#import "TMDataIconController.h"
#import "TMTabBarController.h"

#import "LLAThirdSDKDelegate.h"
#import "LLAHttpUtil.h"
#import "LLAViewUtil.h"
#import "LLALoadingView.h"

#import "LLACommonUtil.h"

#import "LLAUserAgreementViewController.h"

@interface TMLoginViewController ()
{
    LLALoadingView *HUD;
}

@property(nonatomic, strong) TMRetrievePasswordViewController *retrieve;
- (IBAction)sinaWeiBoLoginClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;


@property (weak, nonatomic) IBOutlet UIButton *weiboButton;
@property (weak, nonatomic) IBOutlet UIButton *weixinButton;
@property (weak, nonatomic) IBOutlet UIButton *qqButton;

@property (weak, nonatomic) IBOutlet UILabel *userPrivacyLabel;

@end

@implementation TMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //UIImage *loginBackImage = [[UIImage llaImageWithName:@"finish"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 30)];
    
    //[self.loginButton setBackgroundImage:loginBackImage forState:UIControlStateNormal];
    
    //
    [self.registerButton sizeToFit];
    
    [self.registerButton addTarget:self action:@selector(registerUserClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.phoneNumField.keyboardType = UIKeyboardTypePhonePad;
    
    //
    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];
    [HUD hide:NO];
    
    self.navigationItem.title = @"登 陆";
    
    if (![QQApiInterface isQQInstalled]) {
        self.qqButton.hidden = YES;
    }
    if (![WXApi isWXAppInstalled]) {
        self.weixinButton.hidden = YES;
    }
//    if (![WeiboSDK isWeiboAppInstalled]) {
//        self.weiboButton.hidden = YES;
//    }

    // 添加手势
    UITapGestureRecognizer *tapUserPrivacy = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserPrivacyLabel)];
    self.userPrivacyLabel.userInteractionEnabled = YES;
    [self.userPrivacyLabel addGestureRecognizer:tapUserPrivacy];
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
    
//    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self.view endEditing:YES];

    [self.navigationController popViewControllerAnimated:YES];

}


- (IBAction)inLlamaButtonClick:(UIButton *)sender {
    
    //login
    
    [self.view endEditing:YES];
    
    //check
    if (![LLACommonUtil validateMobile:self.phoneNumField.text]) {
        [LLAViewUtil showAlter:self.view withText:@"请输入正确的手机号"];
        return;
    }
    
    if (self.passwordField.text.length < 1) {
        [LLAViewUtil showAlter:self.view withText:@"请填写密码"];
        return;
    }

    
    LLAUser *user = [LLAUser new];
    
    user.mobilePhone = self.phoneNumField.text;
    user.mobileLoginPsd = self.passwordField.text;
    user.loginType = UserLoginType_MobilePhone;
    
    [self fetchUserInfoWithUser:user loginType:UserLoginType_MobilePhone];
    
    
}
- (IBAction)forgetPwdClick:(UIButton *)sender {
    
    
    // 推出键盘
    [self.view endEditing:YES];

    
    TMRetrievePasswordViewController *retrieve = [[TMRetrievePasswordViewController alloc] init];

    [self.navigationController pushViewController:retrieve animated:YES];
    

}

- (IBAction)registerUserClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    TMRegisterViewController *registerController = [TMRegisterViewController new];

    [self.navigationController pushViewController:registerController animated:YES];
    
}

// 点击屏幕时也推出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)sinaWeiBoLoginClicked:(id)sender {
    [[LLAThirdSDKDelegate shareInstance] thirdLoginWithType:UserLoginType_SinaWeiBo loginCallBack:^(NSString *openId, NSString *accessToken, LLAThirdLoginState state, NSError *error) {
        
        if (state == LLAThirdLoginState_Success) {
        
            LLAUser *user = [LLAUser new];
            user.loginType = UserLoginType_SinaWeiBo;
            user.sinaWeiBoUid = [openId integerValue];
            user.sinaWeiBoAccess_Token = accessToken;
            
            //fetch UserInfo
            
            [self fetchUserInfoWithUser:user loginType:UserLoginType_SinaWeiBo];
            
        }else if (state == LLAThirdLoginState_Failed){
            [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
        }
        
    }];
}
- (IBAction)weChatLoginClicked:(id)sender {
    
    [[LLAThirdSDKDelegate shareInstance] thirdLoginWithType:UserLoginType_WeChat loginCallBack:^(NSString *openId, NSString *accessToken, LLAThirdLoginState state, NSError *error) {
        
        if (state == LLAThirdLoginState_Success) {
            
            LLAUser *user = [LLAUser new];
            user.loginType = UserLoginType_WeChat;
            user.weChatOpenId = openId;
            user.weChatAccess_Token = accessToken;
            
            //fetch token;
            [self fetchUserInfoWithUser:user loginType:UserLoginType_WeChat];

        }else if (state == LLAThirdLoginState_Failed){
            [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
        }
        
    }];
    
}
- (IBAction)qqLoginClicked:(id)sender {
    
    [[LLAThirdSDKDelegate shareInstance]  thirdLoginWithType:UserLoginType_QQ loginCallBack:^(NSString *openId, NSString *accessToken, LLAThirdLoginState state, NSError *error) {
        
        if (state == LLAThirdLoginState_Success) {
            LLAUser *user = [LLAUser new];
            
            user.loginType = UserLoginType_QQ;
            user.qqOpenId = openId;
            user.qqAccess_Token = accessToken;
            //fetch
            
            [self fetchUserInfoWithUser:user loginType:UserLoginType_QQ];

            
        }else if(state == LLAThirdLoginState_Failed) {
            [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
        }
        
    }];
    
}

- (void) fetchUserInfoWithUser:(LLAUser *) user loginType:(UserLoginType)loginType{
    
    [HUD show:YES];
    
    
    __weak typeof (self) blockSelf = self;
    
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
        //
        TMDataIconController *finishProfile = [TMDataIconController new];
        
        [self.navigationController pushViewController:finishProfile animated:YES];
    }
}


#pragma mark - tapUserPrivacyLabel

- (void)tapUserPrivacyLabel
{
//    NSLog(@"点击了用户隐私");
    LLAUserAgreementViewController *userAgreement = [[LLAUserAgreementViewController alloc] init];
    [self.navigationController pushViewController:userAgreement animated:YES];

}

@end
