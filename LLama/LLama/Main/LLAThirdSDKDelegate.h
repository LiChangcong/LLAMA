//
//  LLAThirdSDKDelegate.h
//  LLama
//
//  Created by WanDa on 16/1/7.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LLA_QQ_APPID @"1105024860"
#define LLA_QQ_APPKEY @"k4Nznv263UT0cXxt"

#define LLA_SINA_WEIBO_APPKEY @"514339865"

#define LLA_WEIXIN_APPID @"wxae2f98ae451293df"
#define LLA_WEIXIN_APP_SECRET @"f1c063d044076449afea4652ff90f6f4"

//sina
#import "WeiboSDK.h"

//QQ
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
//weixin
#import "WXApi.h"

typedef NS_ENUM(NSInteger,LLAThirdLoginState) {

    LLAThirdLoginState_Unknow = 0,
    LLAThirdLoginState_Begin = 1,
    LLAThirdLoginState_Success = 2,
    LLAThirdLoginState_Cancel = 3,
    LLAThirdLoginState_Failed = 4,
    
};

typedef void(^ThirdLoginBlock)(NSString *tokenString,LLAThirdLoginState state,NSError *error);

@class LLAUser;

@interface LLAThirdSDKDelegate : NSObject<WeiboSDKDelegate,WXApiDelegate,TencentSessionDelegate,QQApiInterfaceDelegate>
@property(nonatomic , copy) NSString *tempToken;

+ (instancetype) shareInstance;

- (void) sinaWeiBoLogin:(ThirdLoginBlock) callBack;

- (void) weChatLogin:(ThirdLoginBlock) callBack;

- (void) qqLogin:(ThirdLoginBlock) callBack;

- (void) fetchUserAccessTokenInfoWithInfo:(LLAUser *) user;

@end
