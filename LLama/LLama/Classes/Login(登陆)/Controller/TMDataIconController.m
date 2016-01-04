//
//  TMDataIconController.m
//  LLama
//
//  Created by tommin on 15/12/24.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMDataIconController.h"
#import "TMDataVideoController.h"

@interface TMDataIconController ()

@property (nonatomic, strong) TMDataVideoController *dataVideo;

@end

@implementation TMDataIconController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextStepButtonClick:(UIButton *)sender {
    
    // 推出键盘
    [self.view endEditing:YES];

    
    TMDataVideoController *dataVideo = [[TMDataVideoController alloc] init];
    self.dataVideo = dataVideo;
    
    self.dataVideo.view.frame = CGRectMake(self.view.width, 0, self.view.width, self.view.height);
    [UIView animateWithDuration:0.4 animations:^{
        self.dataVideo.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        [self.view addSubview:self.dataVideo.view];
    }];
    
}

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


// 点击屏幕时也推出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
