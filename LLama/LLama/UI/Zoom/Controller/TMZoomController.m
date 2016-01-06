//
//  TMZoomController.m
//  LLama
//
//  Created by tommin on 15/12/24.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMZoomController.h"

@interface TMZoomController ()

@end

@implementation TMZoomController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置导航栏标题
    self.navigationItem.title = @"发现";
    [self.navigationController.navigationBar setTitleTextAttributes:
                                            @{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                            NSForegroundColorAttributeName:[UIColor whiteColor]}];

    // 设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航栏背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"] forBarMetrics:UIBarMetricsDefault];

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

@end
