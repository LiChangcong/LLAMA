//
//  LLAInstantMessageHeader.h
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#ifndef LLAInstantMessageHeader_h
#define LLAInstantMessageHeader_h

#define LLACONVERSATION_ATTRIBUTES_TYPEKEY @"type"
#define LLACONVERSATION_ATTRIBUTES_MEMBERSKEY @"members"

#define LLACONVERSATION_LOAD_HISTORY_MESSAGE_NUMPERTIME 15

@class LLAIMConversation;

typedef void (^LLAIMBooleanResultBlock)(BOOL succeeded, NSError *error);
typedef void (^LLAIMConversationResultBlock)(LLAIMConversation *conversation, NSError *error);
typedef void (^LLAIMProgressBlock)(CGFloat percent);

typedef NS_ENUM(NSInteger,LLAConversationType) {
    
    //单聊
    LLAConversationType_Single = 0,
    //群聊
    LLAConversationType_Group = 1,
    //系统消息
    LLAConversationType_System = 2,
    
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
