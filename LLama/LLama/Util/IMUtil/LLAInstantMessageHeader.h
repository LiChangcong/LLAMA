//
//  LLAInstantMessageHeader.h
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#ifndef LLAInstantMessageHeader_h
#define LLAInstantMessageHeader_h

typedef void (^LLAIMBooleanResultBlock)(BOOL succeeded, NSError *error);

typedef NS_ENUM(NSInteger,LLAConverstionType) {
    
    //单聊
    LLAConverstionType_Single = 0,
    //群聊
    LLAConverstionType_Group = 1,
    //系统消息
    LLAConverstionType_System = 2,
    
};

typedef enum:NSInteger{
    //断开
    IMClientStatus_Offline = 1,
    //连接中
    IMClientStatus_Connecting = 2,
    //已连接
    IMClientStatus_Online = 3,
    
}IMClientStatus;

#endif /* LLAInstantMessageHeader_h */
