//
//  LLADelegate.m
//  LLama
//
//  Created by WanDa on 16/1/6.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLADelegate.h"
#import "TMLoginRegisterViewController.h"

//sina
#import "WeiboSDK.h"

//QQ
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/TencentOAuth.h>
//weixin
#import "WXApi.h"

#define LLA_QQ_APPID @"1105024860"
#define LLA_QQ_APPKEY @"k4Nznv263UT0cXxt"

#define LLA_SINA_WEIBO_APPKEY @"514339865"

#define LLA_WEIXIN_APPID @"wxae2f98ae451293df"
#define LLA_WEIXIN_APP_SECRET @"f1c063d044076449afea4652ff90f6f4"

@interface LLADelegate()<WeiboSDKDelegate,WXApiDelegate>

@end

@implementation LLADelegate

#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController =  [[TMLoginRegisterViewController alloc] init];

    [self.window makeKeyAndVisible];
    
    //
    [self setupThirdSDK];
    
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

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    NSString *urlStr = [url absoluteString];
    
    if([urlStr hasPrefix:@"wx"]){
        return  [WXApi handleOpenURL:url delegate:self];
    }else if([urlStr hasPrefix:@"tencent"]){
        if([TencentOAuth CanHandleOpenURL:url]){
            return [TencentOAuth HandleOpenURL:url];
        }
    }else if([urlStr hasPrefix:@"wb"]){
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url {
    NSString *urlStr = [url absoluteString];
    
    if([urlStr hasPrefix:@"wx"]){
        return  [WXApi handleOpenURL:url delegate:self];
    }else if([urlStr hasPrefix:@"tencent"]){
        if([TencentOAuth CanHandleOpenURL:url]){
            return [TencentOAuth HandleOpenURL:url];
        }
    }else if([urlStr hasPrefix:@"wb"]){
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    
    return YES;

}

#pragma mark - Setup Third SDK

- (void) setupThirdSDK {
    [self setupQQSDK];
    [self setupSinaWeiBoSDK];
    [self setupWeiXinSDK];
    [self setupAliPaySDK];
}

- (void) setupQQSDK {
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:LLA_SINA_WEIBO_APPKEY];
}

- (void) setupSinaWeiBoSDK {
    
}

- (void) setupWeiXinSDK {
    [WXApi registerApp:LLA_WEIXIN_APPID];
}

- (void) setupAliPaySDK {
    
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

#pragma mark - SinaWeiBoDelegate

- (void) didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void) didReceiveWeiboResponse:(WBBaseResponse *)response {
    
}

#pragma mark - WeiXinDelegate

- (void) onReq:(BaseReq *)req {
    
}

- (void) onResp:(BaseResp *)resp {
    
}

@end
