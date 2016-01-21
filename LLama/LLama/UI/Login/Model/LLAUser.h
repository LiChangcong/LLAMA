//
//  LLAUser.h
//  LLama
//
//  Created by WanDa on 16/1/7.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle.h"
#import "LLAChooseItemProtocol.h"
#import "LLAVideoInfo.h"

#define LLA_USER_LOGIN_STATE_CHANGED_NOTIFICATION @"LLA_USER_LOGIN_STATE_CHANGED_NOTIFICATION"


//性别

typedef NS_ENUM(NSInteger,UserGender){
    UserGender_Female = 0,
    UserGender_Male = 1,
};
//用户登陆方式

typedef NS_ENUM(NSInteger,UserLoginType){
    UserLoginType_Unknow = 0,
    UserLoginType_MobilePhone = 1,
    UserLoginType_SinaWeiBo = 2,
    UserLoginType_WeChat = 3,
    UserLoginType_QQ = 4,
};

@interface LLAUser : MTLModel<MTLJSONSerializing,LLAChooseItemProtocol>

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

@property(nonatomic , strong) LLAVideoInfo *userVideo;

@property(nonatomic , copy) NSString *userDescription;

@property(nonatomic , assign) CGFloat balance;
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

//for temp save
@property(nonatomic , copy) NSString *videoCoverImageURL;
@property(nonatomic , copy) NSString *videoPlayURL;

+ (LLAUser *) parseJsonWidthDic:(NSDictionary *) data;

+ (LLAUser *) me;

+ (void) updateUserInfo:(LLAUser *) newUser;

- (BOOL) hasUserProfile;

+ (BOOL) isSimpleUserModel;
+ (void) setIsSimpleUserModel:(BOOL) isSimple;

@end
