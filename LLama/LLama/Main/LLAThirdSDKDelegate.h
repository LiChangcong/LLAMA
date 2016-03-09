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
#define LLA_SINA_WEIBO_APP_SECRET @"k4Nznv263UT0cXxt"

#define LLA_WEIXIN_APPID @"wxae2f98ae451293df"
#define LLA_WEIXIN_APP_SECRET @"f1c063d044076449afea4652ff90f6f4"

#define LLA_UMENG_APPKEY @"5620659c67e58e8d6c002da9"

#define LLA_BUGTAGS_APPKEY @"9247052791beea701ecdf36a1bb11b8e"

#define SDK_REDIRECT_URL @"http://www.hillama.com"

#define LLA_LEANCLOUD_APPLICATIONID @"8RFnpOoAU5UjWjzYud3CijQC-gzGzoHsz"
#define LLA_LEANCLOUD_CLIENTKEY @"WPFn9FYz5VG1boT2ju5yXQ2r"

#define LLA_LEANCLOUD_APPLICATIONID_TEST @"vfwLbNRf4KBk7YhA7HqljjtF-gzGzoHsz"
#define LLA_LEANCLOUD_CLIENTKEY_TEST @"spmftuE4gTWi9A18UYkuWnVo"

//sina
#import "WeiboSDK.h"

//QQ
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
//weixin
#import "WXApi.h"

//UMeng
#import "MobClick.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
//#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
//
#import "LLAUser.h"

//bug tags
#import <Bugtags/Bugtags.h>

//lean cloud
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

typedef NS_ENUM(NSInteger,LLAThirdLoginState) {

    LLAThirdLoginState_Unknow = 0,
    LLAThirdLoginState_Begin = 1,
    LLAThirdLoginState_Success = 2,
    LLAThirdLoginState_Cancel = 3,
    LLAThirdLoginState_Failed = 4,
};

typedef void(^ThirdLoginBlock)(NSString *tokenString,LLAThirdLoginState state,NSError *error);
typedef void(^ThirdLoginCallBack)(NSString *openId,NSString *accessToken,LLAThirdLoginState state,NSError *error);
typedef void(^fetchAccessTokenCallBack)(NSString *token,NSError *error);

typedef void(^fetchUserDetailInfoCallBack)(LLAUser *userInfo,NSError *error);

@interface LLAThirdSDKDelegate : NSObject<WXApiDelegate>

+ (instancetype) shareInstance;

- (void) thirdLoginWithType:(UserLoginType) loginType loginCallBack:(ThirdLoginCallBack) callBack;

- (void) sinaWeiBoLogin:(ThirdLoginBlock) callBack;

- (void) weChatLogin:(ThirdLoginBlock) callBack;

- (void) qqLogin:(ThirdLoginBlock) callBack;

- (void) fetchUserAccessTokenInfoWithInfo:(LLAUser *) user callBack:(fetchAccessTokenCallBack) callBack;

- (void) fetchUserInfoWithUserToken:(NSString *) token callBack:(fetchUserDetailInfoCallBack) callBack;

@end
