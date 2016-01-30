//
//  LLADelegate.m
//  LLama
//
//  Created by WanDa on 16/1/6.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLADelegate.h"
#import "TMLoginRegisterViewController.h"

#import "LLAThirdSDKDelegate.h"
#import "LLABaseNavigationController.h"
#import "TMTabBarController.h"

@interface LLADelegate()

@end

@implementation LLADelegate

#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 显示窗口
    [self.window makeKeyAndVisible];
    
    // 三方SDK
    [self setupThirdSDK];
    
    // 3DTouch
    [self setupShortCutsItems];
    
    //
    if ([LLAUser me].isLogin) {
    
        TMTabBarController *tabbar = [[TMTabBarController alloc] init];
    
        self.window.rootViewController = tabbar;
        
    }else {
        TMLoginRegisterViewController *loginViewController =  [[TMLoginRegisterViewController alloc] init];
        LLABaseNavigationController *loginNavi = [[LLABaseNavigationController alloc] initWithRootViewController:loginViewController];
        
        self.window.rootViewController = loginNavi;
    }


    
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
//    
//    if([urlStr hasPrefix:@"wx"]){
//        return  [WXApi handleOpenURL:url delegate:[LLAThirdSDKDelegate shareInstance]];
//    }else if([urlStr hasPrefix:@"tencent"] || [urlStr hasPrefix:@"QQ"]){
//    
//        [QQApiInterface handleOpenURL:url delegate:[LLAThirdSDKDelegate shareInstance]];
//        
//        if([TencentOAuth CanHandleOpenURL:url]){
//            return [TencentOAuth HandleOpenURL:url];
//        }
//        
//    }else if([urlStr hasPrefix:@"wb"]){
//        return [WeiboSDK handleOpenURL:url delegate:[LLAThirdSDKDelegate shareInstance]];
//    }
    
    // umeng
    BOOL umResult = [UMSocialSnsService handleOpenURL:url];
    
    if (!umResult){
        if([urlStr hasPrefix:@"wx"]){
            return  [WXApi handleOpenURL:url delegate:[LLAThirdSDKDelegate shareInstance]];
        }
    }
    
    
    return YES;
}

#pragma mark - Setup Third SDK

- (void) setupThirdSDK {
//    [self setupQQSDK];
//    [self setupSinaWeiBoSDK];
//    [self setupWeiXinSDK];
    
    [self setupUmengSDK];
    [self setupAliPaySDK];
}

- (void) setupUmengSDK {
    
    
    [UMSocialData setAppKey:LLA_UMENG_APPKEY];
    
#if DEBUG
    [MobClick setLogEnabled:YES];
    
#else
    [MobClick startWithAppkey:LLA_UMENG_APPKEY  reportPolicy:BATCH channelId:nil];
    [MobClick setLogEnabled:NO];
#endif
    
    //weChat
    [UMSocialWechatHandler setWXAppId:LLA_WEIXIN_APPID appSecret:LLA_WEIXIN_APP_SECRET url:SDK_REDIRECT_URL];
    //[WXApi registerApp:LLA_WEIXIN_APPID withDescription:@"LLAMA"];
    //qq
    [UMSocialQQHandler setQQWithAppId:LLA_QQ_APPID appKey:LLA_QQ_APPKEY url:SDK_REDIRECT_URL];
    //sina
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:LLA_SINA_WEIBO_APPKEY RedirectURL:SDK_REDIRECT_URL];
}

//- (void) setupQQSDK {
//    [WeiboSDK enableDebugMode:YES];
//    [WeiboSDK registerApp:LLA_SINA_WEIBO_APPKEY];
//}
//
//- (void) setupSinaWeiBoSDK {
//    
//}
//
//- (void) setupWeiXinSDK {
//    [WXApi registerApp:LLA_WEIXIN_APPID];
//}

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

@end
