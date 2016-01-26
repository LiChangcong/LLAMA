//
//  LLANextChangBoundPhonesViewController.m
//  LLama
//
//  Created by tommin on 16/1/26.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLANextChangBoundPhonesViewController.h"

#import "LLALoadingView.h"
#import "LLAViewUtil.h"
#import "LLACommonUtil.h"
#import "LLAHttpUtil.h"

#import "LLAUser.h"

#import "LLAUserAccountWithdrawCashViewController.h"

@interface LLANextChangBoundPhonesViewController ()
{
    LLALoadingView *HUD;
    
}

@property (weak, nonatomic) IBOutlet UITextField *identityField;

@property (weak, nonatomic) IBOutlet UITextField *BoundPhoneNew;

@property (weak, nonatomic) IBOutlet UIButton *sendToGetIDCodeButton;

@end

@implementation LLANextChangBoundPhonesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = TMCommonBgColor;

}

// 获取验证码
- (IBAction)sendToGetIdCodeClicked:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    NSString *phoneNumber = self.BoundPhoneNew.text;
    
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

// 定时器
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

- (IBAction)determineButtonClick:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    //check
    if (![LLACommonUtil validateMobile:self.BoundPhoneNew.text]) {
        [LLAViewUtil showAlter:self.view withText:@"请输入正确的手机号"];
        return;
    }
    
    
    if (self.identityField.text.length < 1) {
        
        [LLAViewUtil showAlter:self.view withText:@"请输入验证码"];
        return;
    }
    
    [HUD show:YES];
    
    //register
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:self.BoundPhoneNew.text forKey:@"newMobile"];
    [params setValue:self.identityField.text forKey:@"smsCode"];
    [params setValue:self.changeToken forKey:@"changeToken"];
    
    __weak  typeof(self) blockSelf = self;
    
    [LLAHttpUtil httpPostWithUrl:@"/user/changeMobileStep2" param:params progress:NULL responseBlock:^(id responseObject) {
        
        //[HUD hide:YES];
        
        NSString *newMobile = [responseObject valueForKey:@"newMobile"];
        
        LLAUser *newUser = [LLAUser me];
        newUser.mobilePhone = newMobile;
        [LLAUser updateUserInfo:newUser];
        
        // 跳到提现信息
        [self.navigationController popToViewController:[[LLAUserAccountWithdrawCashViewController alloc] init] animated:YES];
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:YES];
        [LLAViewUtil showAlter:blockSelf.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
        [HUD hide:YES];
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
    }];

    
}

@end