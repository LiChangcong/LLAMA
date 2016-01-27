//
//  LLAAccountSecurityController.m
//  LLama
//
//  Created by tommin on 16/1/26.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAAccountSecurityController.h"

@interface LLAAccountSecurityController ()

@property (nonatomic, weak) IBOutlet UIView *mainTableView;

@end

@implementation LLAAccountSecurityController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 背景色
    self.view.backgroundColor = [UIColor colorWithHex:0xeaeaea];
    
    // 导航栏标题
    self.navigationItem.title = @"设置";

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
