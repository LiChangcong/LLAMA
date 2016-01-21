//
//  LLAScriptHallItemInfo.h
//  LLama
//
//  Created by Live on 16/1/16.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle.h"
#import "LLAUser.h"

#import "LLATextContentStretchProtocol.h"
#import "LLAScriptChooseActorTempChooseProtocol.h"

/*
 0-  位未知状态
 1-  初始状态
 2-  选定并支付,支付并没被验证通过
 3-  选定并支付,支付验证通过
 4-  视频已上传
 5-  视频未上传（超时）
 */
// 剧本状态
typedef NS_ENUM(NSInteger,LLAScriptStatus) {
    LLAScriptStatus_Unknow = 0,
    LLAScriptStatus_Normal = 1,
    LLAScriptStatus_PayUnvertified = 2,
    LLAScriptStatus_PayVertified = 3,
    LLAScriptStatus_VideoUploaded = 4,
    LLAScriptStatus_WaitForUploadTimeOut = 5,
};

// 用户角色
typedef NS_ENUM(NSInteger,LLAUserRoleInScript) {
    LLAUserRoleInScript_Passer = 0,
    LLAUserRoleInScript_Actor = 1,
    LLAUserRoleInScript_Director = 2,
};

@interface LLAScriptHallItemInfo : MTLModel<MTLJSONSerializing,LLATextContentStretchProtocol,LLAScriptChooseActorTempChooseProtocol>
/**
 *  剧本ID
 */
@property(nonatomic , copy) NSString *scriptIdString;
/**
 *  具备内容
 */
@property(nonatomic , copy) NSString *scriptContent;
/**
 *  导演详细
 */
@property(nonatomic , strong) LLAUser *directorInfo;
/**
 *  片酬金额
 */
@property(nonatomic , assign) NSInteger rewardMoney;
/**
 *  剧本图片URL
 */
@property(nonatomic , copy) NSString *scriptImageURL;
/**
 *  是否是私密视频
 */
@property(nonatomic , assign) BOOL isPrivateVideo;
/**
 *  剧本状态
 */
@property(nonatomic , assign) LLAScriptStatus status;
/**
 *  当前的角色
 */
@property(nonatomic , assign) LLAUserRoleInScript currentRole;
/**
 *  报名演员
 */
@property(nonatomic , strong) NSMutableArray <LLAUser *> *partakeUsersArray;
/**
 *  报名演员的个数
 */
@property(nonatomic , assign) NSInteger signupUserNumbers;
/**
 *  选择的演员ID
 */
@property(nonatomic , copy) NSString *choosedUserIdString;

@property(nonatomic , assign) long long publishTimeInterval;

@property(nonatomic , copy) NSString *publisthTimeString;

@property(nonatomic , assign) long long timeOutInterval;

+ (LLAScriptHallItemInfo *) parseJsonWithDic:(NSDictionary *) data;

@end
