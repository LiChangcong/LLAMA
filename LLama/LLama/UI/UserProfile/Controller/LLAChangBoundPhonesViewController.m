//
//  LLAChangBoundPhonesViewController.m
//  LLama
//
//  Created by tommin on 16/1/26.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAChangBoundPhonesViewController.h"
#import "LLANextChangBoundPhonesViewController.h"

#import "LLAViewUtil.h"
#import "LLACommonUtil.h"
#import "LLALoadingView.h"
#import "LLAHttpUtil.h"


#import "LLAUser.h"

@interface LLAChangBoundPhonesViewController ()
{
    LLALoadingView *HUD;
    
    NSString *changeToken;
}

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UITextField *identityField;


@property (weak, nonatomic) IBOutlet UIButton *sendToGetIDCodeButton;

@property (weak, nonatomic) IBOutlet UILabel *sendSmsCodePhoneLabel;

@end

@implementation LLAChangBoundPhonesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"更换绑定的手机号";
    [self.sendToGetIDCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];

    // 显示：将发送验证码到绑定的手机
    NSString *boundPhones = [LLAUser me].mobilePhone;
    self.sendSmsCodePhoneLabel.text = [NSString stringWithFormat:@"将发送验证码到手机: %@",boundPhones];
    
    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];


}

// 获取验证码
- (IBAction)sendToGetIdCodeClicked:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    [HUD show:NO];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    __weak typeof(self) blockSelf = self;
    
    [LLAHttpUtil httpPostWithUrl:@"/user/getCurrentSms" param:params progress:NULL responseBlock:^(id responseObject) {
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


// 下一步
- (IBAction)nextStepButtonClick:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    //check
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
    [params setValue:self.passwordField.text forKey:@"pwd"];
    [params setValue:self.identityField.text forKey:@"smsCode"];
    
    __weak  typeof(self) blockSelf = self;
    
    [LLAHttpUtil httpPostWithUrl:@"/user/changeMobileStep1" param:params progress:NULL responseBlock:^(id responseObject) {
        
        //[HUD hide:YES];
        
        NSString *token = [responseObject valueForKey:@"changeToken"];
        
        if ([token isKindOfClass:[NSString class]]) {
        
            changeToken = token;
            
            // 到换绑手机第二步
            LLANextChangBoundPhonesViewController *next = [[LLANextChangBoundPhonesViewController alloc] init];
            next.changeToken = changeToken;
            [self.navigationController pushViewController:next animated:YES];
        }
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:YES];
        [LLAViewUtil showAlter:blockSelf.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
        [HUD hide:YES];
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
    }];

}


@end
