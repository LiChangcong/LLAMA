//
//  LLAThirdSDKDelegate.m
//  LLama
//
//  Created by WanDa on 16/1/7.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAThirdSDKDelegate.h"

#import "LLAHttpUtil.h"
#import "LLASaveUserDefaultUtil.h"
#import "LLAThirdPayManager.h"

#import "LLAInstantMessageService.h"


@interface LLAThirdSDKDelegate()
{
    TencentOAuth *qqAuth;
}

@property(nonatomic , copy) ThirdLoginBlock loginCallBack;

@end

@implementation LLAThirdSDKDelegate

+ (instancetype) shareInstance {
    static LLAThirdSDKDelegate *shareInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareInstance = [[[self class] alloc] init];
    });
    return shareInstance;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Init

- (instancetype) init {
    self = [super init];
    if (self) {
        //qqAuth = [[TencentOAuth alloc] initWithAppId:LLA_QQ_APPID andDelegate:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

#pragma mark - Notification

- (void) applicationDidBecomeActive:(NSNotification *) noti {
    //
}

#pragma mark - Public Method

- (void) thirdLoginWithType:(UserLoginType)loginType loginCallBack:(ThirdLoginCallBack)callBack {
    if (loginType == UserLoginType_SinaWeiBo) {
        //umeng
        if (callBack)
            callBack(nil,nil,LLAThirdLoginState_Begin,nil);
        
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        
        snsPlatform.loginClickHandler(nil,[UMSocialControllerService defaultControllerService],NO,^(UMSocialResponseEntity *response){
            
            //          获取微博用户名、uid、token等
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            //NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            if (callBack)
                callBack(snsAccount.usid,snsAccount.accessToken,[self umResponseCodeToLoginState:response.responseCode],response.error);
        });
        
    }else if(loginType == UserLoginType_QQ) {
        if (callBack)
            callBack(nil,nil,LLAThirdLoginState_Begin,nil);
        
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
        
        snsPlatform.loginClickHandler(nil,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            //          获取微博用户名、uid、token等
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            if (callBack)
                callBack(snsAccount.usid,snsAccount.accessToken,[self umResponseCodeToLoginState:response.responseCode],response.error);
        });
        
    }else if(loginType == UserLoginType_WeChat) {
        
        if (callBack)
            callBack(nil,nil,LLAThirdLoginState_Begin,nil);
        
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        
        snsPlatform.loginClickHandler(nil,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            if (callBack)
                callBack(snsAccount.usid,snsAccount.accessToken,[self umResponseCodeToLoginState:response.responseCode],response.error);
            
        });
        
        
    }else {
        if (callBack){
            callBack(nil,nil,LLAThirdLoginState_Failed,nil);
        }
    }
}

- (void) qqLogin:(ThirdLoginBlock) callBack {
    
    self.loginCallBack = callBack;
    
    NSArray *permissions = [NSArray arrayWithObjects:@"all", nil];
    if (![qqAuth authorize:permissions inSafari:NO]) {
        
        if (self.loginCallBack){
            self.loginCallBack(nil,LLAThirdLoginState_Failed,nil);
            self.loginCallBack = nil;
        }
    };
}

- (void) weChatLogin:(ThirdLoginBlock) callBack {
    if(![WXApi isWXAppInstalled]){
        //未安装微信
        return;
    }
    
    self.loginCallBack = callBack;
    
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
    req.state = SDK_REDIRECT_URL ;
    
    if ([WXApi sendReq:req]) {
        if (self.loginCallBack){
            self.loginCallBack(nil,LLAThirdLoginState_Failed,nil);
            self.loginCallBack = nil;
        }

    }
}

- (void) sinaWeiBoLogin:(ThirdLoginBlock) callBack {
    
    self.loginCallBack = callBack;
    //
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];

    request.redirectURI = SDK_REDIRECT_URL;
    request.scope = @"all";
    request.userInfo = @{@"type": @"login"};
    if ([WeiboSDK sendRequest:request]) {
        if (self.loginCallBack){
            self.loginCallBack(nil,LLAThirdLoginState_Failed,nil);
            self.loginCallBack = nil;
        }
    }
}

#pragma mark - SinaWeiBoDelegate

- (void) didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void) didReceiveWeiboResponse:(WBBaseResponse *)response {
    WeiboSDKResponseStatusCode statusCode = response.statusCode;
    if(statusCode == WeiboSDKResponseStatusCodeSuccess){
        NSString *type = [response.requestUserInfo valueForKey:@"type"];
        if([type isEqualToString:@"login"]){
            
            WBAuthorizeResponse *authorizeResponse = (WBAuthorizeResponse *)response;
            NSString *accessToken = authorizeResponse.accessToken;
            NSString *uid = authorizeResponse.userID;
            
            LLAUser *user = [LLAUser new];
            user.loginType = UserLoginType_SinaWeiBo;
            user.sinaWeiBoUid = [uid integerValue];
            user.sinaWeiBoAccess_Token = accessToken;
            
            [self fetchUserAccessTokenInfoWithInfo:user callBack:^(NSString *token, NSError *error) {
                
            }];
            
        }else if([type isEqualToString:@"share"]){
        
        }
    }
}

#pragma mark - WeiXinDelegate

- (void) onReq:(BaseReq *)req {
    
}

- (void) onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        //pay
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
            {
                //服务器端查询支付通知或查询API返回的结果再提示成功
                [[LLAThirdPayManager shareManager] payResponseFromThirdPartyWithType:LLAThirdPayType_WeChat responseCode:LLAThirdPayResponseStatus_Success error:nil];
                break;
            }
            default:
            {
                [[LLAThirdPayManager shareManager] payResponseFromThirdPartyWithType:LLAThirdPayType_WeChat responseCode:LLAThirdPayResponseStatus_Failed error:nil];
                
                break;
            }
        }
        
    }else {
        if ([resp isKindOfClass:[SendAuthResp class]]) {
            //login
            if (resp.errCode == 0) {
                NSLog(@"用户同意");
                SendAuthResp *aresp = (SendAuthResp *)resp;
                if (aresp.code != nil) {
                    //获取token和openUid
                    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",LLA_WEIXIN_APPID,LLA_WEIXIN_APP_SECRET,aresp.code];
                    
                    NSURL *url = [NSURL URLWithString:urlString];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
                        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (data){
                                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                if ([dict objectForKey:@"errcode"]){
                                    NSLog(@"获取token错误");
                                }
                                else{
                                    
                                    NSString *openId = [dict objectForKey:@"openid"];
                                    NSString *accessToken = [dict objectForKey:@"access_token"];
                                    
                                    LLAUser *user = [LLAUser new];
                                    user.loginType = UserLoginType_WeChat;
                                    user.weChatOpenId = openId;
                                    user.weChatAccess_Token = accessToken;
                                    
                                    [self fetchUserAccessTokenInfoWithInfo:user callBack:^(NSString *token, NSError *error) {
                                        
                                    }];
                                    
                                }
                            }
                        });
                    });
                }
                
            }else if(resp.errCode ==-4){
                NSLog(@"用户拒绝");
            }else if(resp.errCode == -2){
                NSLog(@"用户取消");
            }

            
        }
        
    }

}

#pragma mark - Tencent Login

- (void) tencentDidLogin {
    //login
//    if ([qqAuth getUserInfo]) {
//        
//    }
    
    LLAUser *user = [LLAUser new];
    
    user.loginType = UserLoginType_QQ;
    user.qqOpenId = qqAuth.openId;
    user.qqAccess_Token = qqAuth.accessToken;
    
    [self fetchUserAccessTokenInfoWithInfo:user callBack:^(NSString *token, NSError *error) {
        
    }];
}

- (void) tencentDidNotLogin:(BOOL)cancelled {
    
    if (cancelled) {
        //cancel login
    }else {
        //login failed
    }
}

- (void) tencentDidNotNetWork {
    //bad network
}

- (void)isOnlineResponse:(NSDictionary *)response {
    
}

//- (void) getUserInfoResponse:(APIResponse *)response {
//    
//}

#pragma mark - Get UserInfo

- (void) fetchUserAccessTokenInfoWithInfo:(LLAUser *) user  callBack:(fetchAccessTokenCallBack)callBack{
    
    NSString *url = @"";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (user.loginType == UserLoginType_MobilePhone) {
        
        url = @"/login/mobileLogin";
        [params setValue:user.mobilePhone forKey:@"mobile"];
        [params setValue:user.mobileLoginPsd forKey:@"pwd"];
        
    }else if (user.loginType == UserLoginType_SinaWeiBo) {
        
        url = @"/login/weiboLogin";
        [params setValue:@(user.sinaWeiBoUid) forKey:@"uid"];
        [params setValue:user.sinaWeiBoAccess_Token forKey:@"access_token"];
        
    }else if (user.loginType == UserLoginType_WeChat) {
        
        url = @"/login/weixinLogin";
        [params setValue:user.weChatOpenId forKey:@"openid"];
        [params setValue:user.weChatAccess_Token forKey:@"access_token"];
        
    }else if (user.loginType == UserLoginType_QQ) {
        
        url = @"/login/qqLogin";
        [params setValue:user.qqOpenId forKey:@"openid"];
        [params setValue:user.qqAccess_Token forKey:@"access_token"];
        
    }
    
    [LLAHttpUtil httpPostWithUrl:url param:params progress:NULL responseBlock:^(id responseObject) {

        NSString *token = [responseObject valueForKey:@"token"];
        
        if (![token isKindOfClass:[NSString class]]) {
            token = @"";
        }
        if (callBack)
            callBack(token,nil);
        
//        //get userInfo
//        [LLAHttpUtil httpPostWithUrl:@"/user/getUserInfo" param:[NSMutableDictionary dictionary] progress:NULL responseBlock:^(id responseObject) {
//            //LLAUser *loginUser = [LLAUser parseJsonWidthDic:[responseObject valueForKey:@"user"]];
//            
//        } exception:^(NSInteger code, NSString *errorMessage) {
//
//        } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
//
//        }];
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        NSError *error = [NSError errorWithDomain:SDK_REDIRECT_URL code:-1 userInfo:
                          [NSDictionary dictionaryWithObjectsAndKeys:errorMessage?errorMessage:@"",NSLocalizedDescriptionKey, nil]];
        if (callBack)
            callBack(nil,error);
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        if (callBack)
            callBack(nil,error);
    }];
}

- (void) fetchUserInfoWithUserToken:(NSString *)token callBack:(fetchUserDetailInfoCallBack)callBack {
    
    //
    [LLASaveUserDefaultUtil saveUserTokenToUserDefault:token];
    
    //get user Info
    
    [LLAHttpUtil httpPostWithUrl:@"/user/getUserInfo" param:[NSDictionary dictionary] responseBlock:^(id responseObject) {
        //
        LLAUser *userInfo = [LLAUser parseJsonWidthDic:[responseObject valueForKey:@"user"]];
        userInfo.isLogin = YES;
        userInfo.authenToken = token;
        
        if (callBack)
            callBack(userInfo,nil);
        
        //
        
        //login client
        [[LLAInstantMessageService shareService] openWithClientId:userInfo.userIdString callBack:^(BOOL succeeded, NSError *error) {
            
        }];
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        if (callBack) {
            
            NSError *error = [NSError errorWithDomain:SDK_REDIRECT_URL code:code userInfo:[NSDictionary dictionaryWithObjectsAndKeys:errorMessage?errorMessage:@"",NSLocalizedDescriptionKey, nil]];
            callBack(nil,error);
        }
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        if (callBack)
            callBack(nil,error);
    }];
    
}

#pragma mark - Public

- (LLAThirdLoginState) umResponseCodeToLoginState:(UMSResponseCode) umRSPCode {
    
    LLAThirdLoginState state = LLAThirdLoginState_Unknow;
    switch (umRSPCode) {
        case UMSResponseCodeSuccess:
            state = LLAThirdLoginState_Success;
            break;
        case UMSResponseCodeCancel:
            state = LLAThirdLoginState_Cancel;
            break;
        default:
            state = LLAThirdLoginState_Failed;
            break;
    }
    
    return state;
}

@end
