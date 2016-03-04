//
//  LLAIMConversation.h
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"

#import "LLAUser.h"
#import "LLAIMMessage.h"

#import "LLAInstantMessageHeader.h"

@class AVIMConversation;

@interface LLAIMConversation : MTLModel

@property(nonatomic , readonly) NSString *clientId;

@property(nonatomic , readonly) NSString *conversationId;

@property(nonatomic , readonly) LLAUser *creator;

@property (nonatomic, strong, readonly) NSDate *createAt;

@property (nonatomic, strong, readonly) NSString *conversationName;

@property (nonatomic, strong, readonly) NSArray<LLAUser *> *members;

//暂态消息
@property (nonatomic, assign, readonly) BOOL transient;

//系统消息
@property (nonatomic, assign, readonly) BOOL isSys;

//会话静音
@property (nonatomic, assign, readonly) BOOL muted;

//
@property (nonatomic, strong) LLAIMMessage *lastMessage;

@property (nonatomic, assign) NSInteger unreadCount;

@property (nonatomic , strong) AVIMConversation *leanConversation;


+ (instancetype) conversationWithLeanCloudConversation:(AVIMConversation *) conversation;

- (void)sendMessage:(LLAIMMessage *)message
      progressBlock:(LLAIMProgressBlock)progressBlock
           callback:(LLAIMBooleanResultBlock)callback;

@end
