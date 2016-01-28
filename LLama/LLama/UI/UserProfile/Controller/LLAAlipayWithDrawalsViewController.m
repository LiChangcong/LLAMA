//
//  LLAAlipayWithDrawalsViewController.m
//  LLama
//
//  Created by tommin on 16/1/26.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAAlipayWithDrawalsViewController.h"

#import "LLALoadingView.h"
#import "LLAViewUtil.h"
#import "LLACommonUtil.h"
#import "LLAHttpUtil.h"

#import "LLAUser.h"


@interface LLAAlipayWithDrawalsViewController ()
{
    LLALoadingView *HUD;
    
}


@property (weak, nonatomic) IBOutlet UITextField *accountNumberTextField;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation LLAAlipayWithDrawalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"提现信息";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *confirmBarItem = [UIBarButtonItem barItemWithImage:[UIImage llaImageWithName:@"ok"] highlightedImage:[UIImage llaImageWithName:@"okh"] target:self action:@selector(confirm)];
    
    self.navigationItem.rightBarButtonItem = confirmBarItem;
    
    LLAUser *me = [LLAUser me];
    if (me.alipayAccount && me.alipayAccountUserName) {
        self.accountNumberTextField.text = me.alipayAccount;
        self.nameTextField.text = me.alipayAccountUserName;
    }else {
        self.accountNumberTextField.text = nil;
        self.nameTextField.text = nil;
    }

}

- (void)confirm
{
    NSLog(@"点击了确认按钮");
    
    [self.view endEditing:YES];
        
    [HUD show:NO];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.accountNumberTextField.text forKey:@"alipay"];
    [params setValue:self.nameTextField.text forKey:@"alipayRealname"];

    __weak typeof(self) blockSelf = self;
    
    [LLAHttpUtil httpPostWithUrl:@"/user/updateAlipay" param:params progress:NULL responseBlock:^(id responseObject) {
        //success
        [HUD hide:NO];
        
        LLAUser *user = [LLAUser me];
        user.alipayAccount = self.accountNumberTextField.text;
        user.alipayAccountUserName = self.nameTextField.text;
        
        [LLAUser updateUserInfo:user]; 
        [LLAViewUtil showAlter:self.view withText:@"绑定成功"];
        
        // 跳转到提现信息页面
        [self.navigationController popViewControllerAnimated:YES];
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:NO];
        [LLAViewUtil showAlter:blockSelf.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        [HUD hide:NO];
        [LLAViewUtil showAlter:blockSelf.view withText:error.localizedDescription];
    }];

}

@end
