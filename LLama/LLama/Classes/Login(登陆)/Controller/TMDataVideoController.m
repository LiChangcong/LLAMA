//
//  TMDataVideoController.m
//  LLama
//
//  Created by tommin on 15/12/24.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMDataVideoController.h"
#import "TMTabBarController.h"

@interface TMDataVideoController ()

@end

@implementation TMDataVideoController

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
- (IBAction)backBtnClick:(UIButton *)sender {
    
    // 推出键盘
    [self.view endEditing:YES];

    
    [UIView animateWithDuration:0.4 animations:^{
        self.view.frame = CGRectMake(self.view.width, 0, self.view.width, self.view.height);
        //        [self.view removeFromSuperview];
        //        self.view = perfect.view;
    }];
    
    // 推出键盘
    [self.view endEditing:YES];

}

- (IBAction)ignore:(UIButton *)sender {
    
    // 推出键盘
    [self.view endEditing:YES];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[TMTabBarController alloc] init];
}

// 点击屏幕时也推出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



@end
