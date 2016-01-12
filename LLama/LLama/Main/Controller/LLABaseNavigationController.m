//
//  LLABaseNavigationController.m
//  LLama
//
//  Created by WanDa on 16/1/7.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLABaseNavigationController.h"

#import "LLACustomNavigationBarViewController.h"


@interface LLABaseNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation LLABaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set navigationBar Attribute
    
    [self.navigationBar setTranslucent:YES];
    self.navigationBar.barTintColor = [UIColor llaNavigationBarColor];
    self.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //
    self.delegate = self;
    
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.interactivePopGestureRecognizer.enabled = NO;
    }

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // fix 'nested pop animation can result in corrupted navigation bar'
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

//

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (navigationController.viewControllers.count > 1) {
            navigationController.interactivePopGestureRecognizer.enabled = YES;
        }else {
            navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
    //
}

- (BOOL) shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return self.topViewController.preferredStatusBarStyle;
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
