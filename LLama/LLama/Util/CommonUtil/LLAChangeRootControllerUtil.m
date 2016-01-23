//
//  LLAChangeRootControllerUtil.m
//  LLama
//
//  Created by Live on 16/1/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAChangeRootControllerUtil.h"

#import "TMLoginRegisterViewController.h"
#import "LLABaseNavigationController.h"
#import "TMTabBarController.h"

@implementation LLAChangeRootControllerUtil

+ (void) changeToLoginViewController {
    TMLoginRegisterViewController *loginViewController =  [[TMLoginRegisterViewController alloc] init];
    LLABaseNavigationController *loginNavi = [[LLABaseNavigationController alloc] initWithRootViewController:loginViewController];
    
    [UIApplication sharedApplication].delegate.window.rootViewController = loginNavi;
}

+ (void) changeToMainTabViewController {
    TMTabBarController *tabbar = [[TMTabBarController alloc] init];
    
    [UIApplication sharedApplication].delegate.window.rootViewController = tabbar;
}

@end
