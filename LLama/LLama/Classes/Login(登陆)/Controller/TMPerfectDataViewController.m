//
//  TMPerfectDataViewController.m
//  LLama
//
//  Created by tommin on 15/12/10.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMPerfectDataViewController.h"
#import "TMTabBarController.h"
//#import "TMCameraAlbumViewController.h"

@interface TMPerfectDataViewController ()

@end

@implementation TMPerfectDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
- (IBAction)cancelButton:(UIButton *)sender {
    
//    [self dismissViewControllerAnimated:NO completion:nil];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.view.frame = CGRectMake(self.view.width, 0, self.view.width, self.view.height);
//        [self.view removeFromSuperview];
        //        self.view = perfect.view;
    }];
    
    // 推出键盘
    [self.view endEditing:YES];

}

- (IBAction)inLlama:(UIButton *)sender {
    
    [self.view endEditing:YES];

    [UIApplication sharedApplication].keyWindow.rootViewController = [[TMTabBarController alloc] init];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (IBAction)albumButtonClick:(UIButton *)sender {
    
    TMLog(@"登陆模块选择头像");
    // 头像拍照和相册选择
//    TMCameraAlbumViewController * cameraAlbum =[[TMCameraAlbumViewController alloc] init];
//    [self presentViewController:cameraAlbum animated:YES completion:nil];
}

@end
