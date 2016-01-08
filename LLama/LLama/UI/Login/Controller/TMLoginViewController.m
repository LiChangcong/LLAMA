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
#import "LLAThirdSDKDelegate.h"

@interface TMLoginViewController ()

@property(nonatomic, strong) TMRetrievePasswordViewController *retrieve;
- (IBAction)sinaWeiBoLoginClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

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
    
    [[LLAThirdSDKDelegate shareInstance] sinaWeiBoLogin];
}
- (IBAction)weChatLoginClicked:(id)sender {
    [[LLAThirdSDKDelegate shareInstance] weChatLogin];
}
- (IBAction)qqLoginClicked:(id)sender {
    [[LLAThirdSDKDelegate shareInstance] qqLogin];
    
}

@end
