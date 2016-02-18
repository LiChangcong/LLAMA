//
//  LLARedirctUtil.m
//  LLama
//
//  Created by Live on 16/2/18.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLARedirectUtil.h"

#import "MMPopup.h"

//controller
#import "LLAHomeViewController.h"


@interface LLARedirectUtil()
{
    LLARedirectType nextType;
}

@end

@implementation LLARedirectUtil

+ (instancetype) shareInstance {
    static LLARedirectUtil *shareInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareInstance = [[[self class] alloc] init];
    });
    
    return shareInstance;
}

- (void) redirectWithNewType:(LLARedirectType) newType {
    nextType = newType;
    [self doRedirect];
}

- (void) doRedirect {
    
    if (nextType == LLARedirectType_None) {
        return;
    }
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    // 隐藏MMPopUpWindow
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *tmpWindow in windows) {
        if ([tmpWindow isKindOfClass:[MMPopupWindow class]]) {
            MMPopupWindow *tmpPopWindow = (MMPopupWindow *)tmpWindow;
            [tmpPopWindow hidePopUpView];
        }
    }
    [window makeKeyAndVisible];
    
    //
    UIViewController *rootViewController = window.rootViewController;
    
    if (![rootViewController isKindOfClass:[UITabBarController class]]) {
        return;
    }
    
    UITabBarController *tabBarController = (UITabBarController *)rootViewController;
    for (UIViewController *viewController in tabBarController.viewControllers) {
        UIViewController *presentedViewController = viewController.presentedViewController;
        if (presentedViewController) {
            [viewController dismissViewControllerAnimated:NO completion:nil];
        }
        
        if (![viewController isKindOfClass:[UINavigationController class]]) {
            continue;
        }
        
        UINavigationController *navigationController = (UINavigationController *)viewController;
        [navigationController popToRootViewControllerAnimated:YES];
    }

    //
    
    switch (nextType) {
            
        case LLARedirectType_HomeHall:
        {
            tabBarController.selectedIndex = 0;
            //
            UINavigationController *navigationController = (UINavigationController *)tabBarController.selectedViewController;
            
            UIViewController *first = [navigationController.viewControllers firstObject];
            
            LLAHomeViewController *home = (LLAHomeViewController *) first;
            
            [home showHallViewController];
            
        }
            
            break;
        case LLARedirectType_UserProfile:
            tabBarController.selectedIndex = 2;
            
            break;
            
        default:
            break;
    }
    
    //
    nextType = LLARedirectType_None;

    
}

@end
