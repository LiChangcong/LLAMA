//
//  LLAModifyPasswordViewController.m
//  LLama
//
//  Created by tommin on 16/1/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAModifyPasswordViewController.h"

#import "LLALoadingView.h"
#import "LLAViewUtil.h"
#import "LLAHttpUtil.h"

#import "LLAUser.h"

@interface LLAModifyPasswordViewController ()
{
    LLALoadingView *HUD;
}
@property (weak, nonatomic) IBOutlet UITextField *pwdTextFieldOld;
@property (weak, nonatomic) IBOutlet UITextField *pwdextFieldNew;

@end

@implementation LLAModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"更改密码";
}


- (IBAction)confirmButtonClick:(UIButton *)sender {
    
    
    [self.view endEditing:YES];
        
    
    if (self.pwdTextFieldOld.text.length < 1) {
        
        [LLAViewUtil showAlter:self.view withText:@"请输入旧密码"];
        return;
    }
    
    if (self.pwdextFieldNew.text.length < 1) {
        
        [LLAViewUtil showAlter:self.view withText:@"请输入新密码"];
        return;
    }
    
    if (self.pwdextFieldNew.text.length > 16) {
        
        [LLAViewUtil showAlter:self.view withText:@"密码长度不能超过16位"];
        return;
    }
    
    [HUD show:YES];
    
    //register
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:self.pwdTextFieldOld.text forKey:@"oldPwd"];
    [params setValue:self.pwdextFieldNew.text forKey:@"newPwd"];
    
    __weak  typeof(self) blockSelf = self;
    
    [LLAHttpUtil httpPostWithUrl:@"/user/changePwd" param:params progress:NULL responseBlock:^(id responseObject) {
        
        //[HUD hide:YES];
        
        LLAUser *newUser = [LLAUser me];
        newUser.mobileLoginPsd = self.pwdextFieldNew.text;
        [LLAUser updateUserInfo:newUser];
        
//        [LLAViewUtil showAlter:self.view withText:@"密码修改成功"];
        
        // 跳到上个页面
        [self.navigationController popViewControllerAnimated:YES];
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:YES];
        [LLAViewUtil showAlter:blockSelf.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
        [HUD hide:YES];
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
    }];
    

    
}


@end
