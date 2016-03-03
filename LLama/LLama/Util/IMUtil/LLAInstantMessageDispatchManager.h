//
//  LLAInstantMessageDispatchManager.h
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLAInstantMessageHeader.h"
#import "LLAIMConversation.h"
#import "LLAIMMessage.h"

//---这个字符串表示要得到所有的消息，而其它单个的消息则用对话ID来标识
#define INSTANT_MESSAGE_ALL_MESSAGE @"*****"

@protocol LLAIMEventObserver <NSObject>
//---新的消息来了
- (void)newMessageArrived:(LLAIMMessage *)message conversation:(LLAIMConversation*)conversation;
//---消息发送成功了
- (void)messageDelivered:(LLAIMMessage*)message conversation:(LLAIMConversation*)conversation;
//---网络状态发生了变化
-(void)imClientStatusChanged:(IMClientStatus)status;

@end


@interface LLAInstantMessageDispatchManager : NSObject

+ (instancetype) sharedInstance;
//------分发消息
- (void) dispatchNewMessageArrived:(LLAIMMessage *)message conversation:(LLAIMConversation*)conversation;
- (void) dispatchMessageDelivered:(LLAIMMessage*)message conversation:(LLAIMConversation*)conversation;
- (void) dispatchImClientStatusChanged:(IMClientStatus )status;

//------添加移除消息监测
- (void) addEventObserver:(id<LLAIMEventObserver> ) observer forConversation:(NSString *)conversationId;
- (void) removeEventObserver:(id<LLAIMEventObserver>) observer forConversation:(NSString *)conversationId;

@end
