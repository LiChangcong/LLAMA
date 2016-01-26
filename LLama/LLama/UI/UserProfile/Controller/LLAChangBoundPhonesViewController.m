//
//  LLAChangBoundPhonesViewController.m
//  LLama
//
//  Created by tommin on 16/1/26.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAChangBoundPhonesViewController.h"
#import "LLANextChangBoundPhonesViewController.h"

@interface LLAChangBoundPhonesViewController ()

@end

@implementation LLAChangBoundPhonesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = TMCommonBgColor;
    
    self.navigationItem.title = @"更换绑定的手机号";

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

- (IBAction)nextStepButtonClick:(UIButton *)sender {
    
    LLANextChangBoundPhonesViewController *next = [[LLANextChangBoundPhonesViewController alloc] init];
    [self.navigationController pushViewController:next animated:YES];
}



@end
