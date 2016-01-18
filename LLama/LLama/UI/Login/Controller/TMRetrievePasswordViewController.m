//
//  TMRetrievePasswordViewController.m
//  LLama
//
//  Created by tommin on 15/12/12.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMRetrievePasswordViewController.h"
#import "LLAViewUtil.h"
#import "LLAHttpUtil.h"
#import "LLALoadingView.h"
#import "LLACommonUtil.h"

@interface TMRetrievePasswordViewController ()
{
    LLALoadingView *HUD;
}

@property (weak, nonatomic) IBOutlet UITextField *cellPhoneNumField;
@property (weak, nonatomic) IBOutlet UIButton *sendToGetIdenButton;
@property (weak, nonatomic) IBOutlet UITextField *identityCodeField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation TMRetrievePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"找回密码";
    
    self.cellPhoneNumField.keyboardType = UIKeyboardTypePhonePad;
    self.identityCodeField.keyboardType = UIKeyboardTypeASCIICapable;
//    self.identityCodeField.backgroundColor = [UIColor colorWithHex:0xebebeb];
    self.passwordField.keyboardType = UIKeyboardTypeASCIICapable;

    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];
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
    
    // 推出键盘
    [self.view endEditing:YES];
    
   
}
- (IBAction)retrieveIdCode:(id)sender {
    
    [self.view endEditing:YES];
    
    
    NSString *phoneNumber = self.cellPhoneNumField.text;
    
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
        [blockSelf buttonTitleTime:self.sendToGetIdenButton withTime:@"60"];
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:NO];
        [LLAViewUtil showAlter:blockSelf.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        [HUD hide:NO];
        [LLAViewUtil showAlter:blockSelf.view withText:error.localizedDescription];
    }];

    
}


- (IBAction)resetButtonClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    //
    
    NSString *phoneNumber = self.cellPhoneNumField.text;
    
    if (![LLACommonUtil validateMobile:phoneNumber]) {
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
    
    if (self.identityCodeField.text.length < 1) {
        
        [LLAViewUtil showAlter:self.view withText:@"请输入验证码"];
        return;
    }
    
    [HUD show:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:phoneNumber forKey:@"mobile"];
    [params setValue:self.passwordField.text forKey:@"pwd"];
    [params setValue:self.identityCodeField.text forKey:@"smsCode"];
    
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


// 点击屏幕时也推出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
