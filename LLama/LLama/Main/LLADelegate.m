//
//  LLADelegate.m
//  LLama
//
//  Created by WanDa on 16/1/6.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLADelegate.h"
#import "TMLoginRegisterViewController.h"

@implementation LLADelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController =  [[TMLoginRegisterViewController alloc] init];

    [self.window makeKeyAndVisible];
    
    //
    [self setupShortCutsItems];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    if (completionHandler)
        completionHandler(YES);
}

#pragma mark - Setup ShortCuts

- (void) setupShortCutsItems {
    
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc]
                                        initWithType:@"typeString1"
                                        localizedTitle:@"拍照片"
                                        localizedSubtitle:nil
                                        icon:[UIApplicationShortcutIcon iconWithType:
                                              UIApplicationShortcutIconTypeCapturePhoto]
                                        userInfo:nil];
    UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc]
                                        initWithType:@"typeString2"
                                        localizedTitle:@"信息"
                                        localizedSubtitle:@"描述"
                                        icon:[UIApplicationShortcutIcon iconWithType:
                                              UIApplicationShortcutIconTypeMessage]
                                        userInfo:nil];
    
    [UIApplication sharedApplication].shortcutItems = @[item1,item2];
}


@end
