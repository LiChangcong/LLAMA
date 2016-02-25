//
//  LLASocialShareHeader.h
//  LLama
//
//  Created by Live on 16/2/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#ifndef LLASocialShareHeader_h
#define LLASocialShareHeader_h

typedef NS_ENUM(NSInteger,LLASocialSharePlatform) {
    LLASocialSharePlatform_WechatSession = 0,
    LLASocialSharePlatform_WechatTimeLine = 1,
    LLASocialSharePlatform_SinaWeiBo = 2,
    LLASocialSharePlatform_QQFriend = 3,
    LLASocialSharePlatform_QQZone = 4,
    LLASocialSharePlatform_CopyLink = 5,
};

typedef NS_ENUM(NSInteger,LLASocialShareResponseState) {
    
    LLASocialShareResponseState_Unknow = 0,
    LLASocialShareResponseState_Begin = 1,
    LLASocialShareResponseState_Success = 2,
    LLASocialShareResponseState_Failed = 3,
    LLASocialShareResponseState_Cancel = 4,
    
};

typedef void (^LLASocialShareStateChangeHandler)(LLASocialShareResponseState state,NSString *message,NSError *error);
typedef void (^LLASocialReportHandler)(void);

#endif /* LLASocialShareHeader_h */
