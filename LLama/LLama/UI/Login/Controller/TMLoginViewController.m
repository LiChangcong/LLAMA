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


@interface TMLoginViewController ()

@property(nonatomic, strong) TMRetrievePasswordViewController *retrieve;

@end

@implementation TMLoginViewController

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
    
//    [self dismissViewControllerAnimated:NO completion:nil];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.view.frame = CGRectMake(self.view.width, 0, self.view.width, self.view.height);
        //        [self.view removeFromSuperview];
        //        self.view = perfect.view;
    }];
    
    // 推出键盘
    [self.view endEditing:YES];


}


- (IBAction)inLlamaButtonClick:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[TMTabBarController alloc] init];
    
}
- (IBAction)forgetPwdClick:(UIButton *)sender {
    
    
    // 推出键盘
    [self.view endEditing:YES];

    
    TMRetrievePasswordViewController *retrieve = [[TMRetrievePasswordViewController alloc] init];
    self.retrieve = retrieve;
    
    self.retrieve.view.frame = CGRectMake(self.view.width, 0, self.view.width, self.view.height);
    [UIView animateWithDuration:0.4 animations:^{
        self.retrieve.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        [self.view addSubview:self.retrieve.view];
        //        self.view = perfect.view;
    }];
    

}


// 点击屏幕时也推出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



@end
