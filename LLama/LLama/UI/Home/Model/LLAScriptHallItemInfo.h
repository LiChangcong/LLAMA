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

typedef NS_ENUM(NSInteger,LLAScriptStatus) {
    LLAScriptStatus_Unknow = 0,
    LLAScriptStatus_Normal = 1,
    LLAScriptStatus_PayUnvertified = 2,
    LLAScriptStatus_PayVertified = 3,
    LLAScriptStatus_VideoUploaded = 4,
    LLAScriptStatus_WaitForUploadTimeOut = 5,
};

typedef NS_ENUM(NSInteger,LLAUserRoleInScript) {
    LLAUserRoleInScript_Passer = 0,
    LLAUserRoleInScript_Actor = 1,
    LLAUserRoleInScript_Director = 2,
};

@interface LLAScriptHallItemInfo : MTLModel<MTLJSONSerializing,LLATextContentStretchProtocol,LLAScriptChooseActorTempChooseProtocol>

@property(nonatomic , copy) NSString *scriptIdString;

@property(nonatomic , copy) NSString *scriptContent;

@property(nonatomic , strong) LLAUser *directorInfo;

@property(nonatomic , assign) NSInteger rewardMoney;

@property(nonatomic , copy) NSString *scriptImageURL;

@property(nonatomic , assign) BOOL isPrivateVideo;

@property(nonatomic , assign) LLAScriptStatus status;

@property(nonatomic , assign) LLAUserRoleInScript currentRole;

@property(nonatomic , strong) NSMutableArray <LLAUser *> *partakeUsersArray;

@property(nonatomic , copy) NSString *choosedUserIdString;

@property(nonatomic , assign) long long publishTimeInterval;

@property(nonatomic , copy) NSString *publisthTimeString;

@property(nonatomic , assign) long long timeOutInterval;

+ (LLAScriptHallItemInfo *) parseJsonWithDic:(NSDictionary *) data;

@end
