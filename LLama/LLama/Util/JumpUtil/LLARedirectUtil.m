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

static const NSInteger homeIndex = 0;
static const NSInteger searchIndex = 1;
static const NSInteger messageIndex = 3;
static const NSInteger userProfileIndex = 4;

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
    
    [self hidePresentedViewController:tabBarController.selectedViewController];
    [self popToRootWithController:tabBarController.selectedViewController];
    
    for (UIViewController *viewController in tabBarController.viewControllers) {
        
        if (![viewController isKindOfClass:[UINavigationController class]]) {
            continue;
        }
        
        [self hidePresentedViewController:viewController];
        [self popToRootWithController:viewController];
        
    }

    //
    
    switch (nextType) {
            
        case LLARedirectType_HomeHall:
        {
            tabBarController.selectedIndex = homeIndex;
            //
            UINavigationController *navigationController = (UINavigationController *)tabBarController.selectedViewController;
            
            UIViewController *first = [navigationController.viewControllers firstObject];
            
            LLAHomeViewController *home = (LLAHomeViewController *) first;
            
            [home showHallViewController];
            
        }
            
            break;
        case LLARedirectType_UserProfile:
            tabBarController.selectedIndex = userProfileIndex;
            
            break;
            
        default:
            break;
    }
    
    //
    nextType = LLARedirectType_None;

    
}

//
- (void) popToRootWithController:(UIViewController *) controller {
    
    if ([controller isKindOfClass:[UIViewController class]]) {
        UINavigationController *navi = (UINavigationController *) controller;
        
        if (navi.viewControllers.count > 1)
            [navi popToRootViewControllerAnimated:YES];
    }
}

- (void) hidePresentedViewController:(UIViewController *) controller {
    
    UIViewController *presentedViewController = controller.presentedViewController;
    if (presentedViewController) {
        
        [presentedViewController dismissViewControllerAnimated:NO completion:NULL];
    }

    
}

@end
