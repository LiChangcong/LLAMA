//
//  TMRegisterViewController.m
//  LLama
//
//  Created by tommin on 15/12/18.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMRegisterViewController.h"
#import "LLAViewUtil.h"
#import "LLAHttpUtil.h"

@interface TMRegisterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *sendToGetIdenCode;

@property (weak, nonatomic) IBOutlet UITextField *cellPhoneNumerFiled;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *indentityField;

@end

@implementation TMRegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    //register
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:self.cellPhoneNumerFiled.text forKey:@"mobile"];
    [params setValue:self.passwordField.text forKey:@"pwd"];
    [params setValue:self.indentityField.text forKey:@"smsCode"];
    
    [LLAHttpUtil httpPostWithUrl:@"/login/mobileReg" param:params progress:NULL responseBlock:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } exception:^(NSInteger code, NSString *errorMessage) {
        [LLAViewUtil showAlter:self.view withText:errorMessage];
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
    }];
}

- (IBAction)sendToGetIdCodeClicked:(id)sender {
    //
    
    [self.view endEditing:YES];
    
    NSString *phoneNumber = self.cellPhoneNumerFiled.text;
    
    if (phoneNumber.length != 11) {
        [LLAViewUtil showAlter:self.view withText:@"请输入合法的手机号"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:phoneNumber forKey:@"mobile"];
    
    [LLAHttpUtil httpPostWithUrl:@"/login/getRegSmsCode" param:params progress:NULL responseBlock:^(id responseObject) {
        //success
        
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
    }];
    
}

// 点击屏幕时也推出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}



@end
