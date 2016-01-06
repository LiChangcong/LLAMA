//
//  TMRegisterViewController.m
//  LLama
//
//  Created by tommin on 15/12/18.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMRegisterViewController.h"
//#import "TMPerfectDataViewController.h"
#import "TMHTTPSessionManager.h"
#import "TMDataIconController.h"
#import "TMDataVideoController.h"

@interface TMRegisterViewController ()

//@property (nonatomic, strong) TMPerfectDataViewController *perfect;
/** 请求管理者 */
@property (nonatomic, weak) TMHTTPSessionManager *manager;

@property (nonatomic, strong) TMDataIconController *dataIcon;


@end

@implementation TMRegisterViewController


/** manager属性的懒加载 */
- (TMHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [TMHTTPSessionManager manager];
    }
    return _manager;
}

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
    
    [UIView animateWithDuration:0.4 animations:^{
        self.view.frame = CGRectMake(self.view.width, 0, self.view.width, self.view.height);
        //        [self.view removeFromSuperview];
        //        self.view = perfect.view;
    }];
    
    // 推出键盘
    [self.view endEditing:YES];

}
- (IBAction)okButtonClick:(UIButton *)sender {
    
    
//    NSString * const TMRequestURL = @"https://linxq.com/login/getRegSmsCode";
////    NSString * const TMRequestURL = @"https://192.168.31.217/login/getRegSmsCode";
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"mobile"] = @"17608002774";
//
//    [self.manager POST:TMRequestURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"请求成功 %@ ", responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"请求失败");
//    }];
//
    // 推出键盘
    [self.view endEditing:YES];
    
    TMDataIconController *dataIcon = [[TMDataIconController alloc] init];
    self.dataIcon = dataIcon;
    
    self.dataIcon.view.frame = CGRectMake(self.view.width, 0, self.view.width, self.view.height);
    [UIView animateWithDuration:0.4 animations:^{
        self.dataIcon.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        [self.view addSubview:self.dataIcon.view];
    }];
    

}

// 点击屏幕时也推出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



@end
