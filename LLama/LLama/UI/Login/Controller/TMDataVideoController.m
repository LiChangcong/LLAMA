//
//  TMDataVideoController.m
//  LLama
//
//  Created by tommin on 15/12/24.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMDataVideoController.h"
#import "TMTabBarController.h"

#import "LLAViewUtil.h"
#import "LLALoadingView.h"

@interface TMDataVideoController ()
{
    LLALoadingView *HUD;
}

@property (weak, nonatomic) IBOutlet UIButton *chooseVideoButton;

@end

@implementation TMDataVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.chooseVideoButton.clipsToBounds = YES;
    self.chooseVideoButton.layer.cornerRadius = self.chooseVideoButton.frame.size.height/2;
    
    // 导航栏右边返回按钮
    UIButton *doNotUploadButton = [[UIButton alloc] init];
    [doNotUploadButton setTitle:@"跳过" forState:UIControlStateNormal];
    [doNotUploadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doNotUploadButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [doNotUploadButton sizeToFit];
    [doNotUploadButton addTarget:self action:@selector(doNotUploadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doNotUploadButton];
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


- (IBAction)chooseVideoButtonClicked:(id)sender {
    
}

- (IBAction)uploadVideoButtonClicked:(id)sender {
    
    TMTabBarController *main = [TMTabBarController new];
    [UIApplication sharedApplication].keyWindow.rootViewController = main;
}

- (IBAction)doNotUploadButtonClicked:(id)sender {
    TMTabBarController *main = [TMTabBarController new];
    [UIApplication sharedApplication].keyWindow.rootViewController = main;
    
}

@end
