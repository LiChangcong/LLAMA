//
//  LLAUser.h
//  LLama
//
//  Created by WanDa on 16/1/7.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle.h"

#define LLA_USER_LOGIN_STATE_CHANGED_NOTIFICATION @"LLA_USER_LOGIN_STATE_CHANGED_NOTIFICATION"

typedef NS_ENUM(NSInteger,UserGender){
    UserGender_Female = 0,
    UserGender_Male = 1,
};

typedef NS_ENUM(NSInteger,UserLoginType){
    UserLoginType_Unknow = 0,
    UserLoginType_MobilePhone = 1,
    UserLoginType_SinaWeiBo = 2,
    UserLoginType_WeChat = 3,
    UserLoginType_QQ = 4,
};

@interface LLAUser : MTLModel<MTLJSONSerializing>

@property(nonatomic , copy) NSString *userIdString;

@property(nonatomic , copy) NSString *userName;

@property(nonatomic , copy) NSString *mobilePhone;
//

/***
 只用做临时存储
 ***/

@property(nonatomic , copy) NSString *mobileLoginPsd;
//
@property(nonatomic , assign) UserGender gender;

@property(nonatomic , assign) UserLoginType loginType;

@property(nonatomic , copy) NSString *genderString;

@property(nonatomic , copy) NSString *headImageURL;

@property(nonatomic , copy) NSString *userVideo;

@property(nonatomic , copy) NSString *userDescription;
//token
@property(nonatomic , copy) NSString *authenToken;
//is login
@property(nonatomic , assign) BOOL isLogin;

//Sina weiBo
@property(nonatomic , assign) long sinaWeiBoUid;
@property(nonatomic , copy) NSString *sinaWeiBoAccess_Token;
//qq
@property(nonatomic , copy) NSString *qqOpenId;
@property(nonatomic , copy) NSString *qqAccess_Token;
//weChat
@property(nonatomic , copy) NSString *weChatOpenId;
@property(nonatomic , copy) NSString *weChatAccess_Token;

+ (LLAUser *) parseJsonWidthDic:(NSDictionary *) data;

+ (LLAUser *) me;

+ (void) updateUserInfo:(LLAUser *) newUser;

- (BOOL) hasUserProfile;

@end
