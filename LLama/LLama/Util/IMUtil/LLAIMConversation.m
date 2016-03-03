//
//  LLAIMConversation.m
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAIMConversation.h"

#import <AVOSCloudIM/AVOSCloudIM.h>

@interface LLAIMConversation()

@property(nonatomic , readwrite , strong) NSString *clientId;

@property(nonatomic , readwrite , strong) NSString *conversationId;

@property(nonatomic , readwrite , strong) LLAUser *creator;

@property (nonatomic, strong, readwrite) NSDate *createAt;

@property (nonatomic, strong, readwrite) NSString *conversationName;

@property (nonatomic, strong, readwrite) NSArray<LLAUser *> *members;

//暂态消息
@property (nonatomic, assign, readwrite) BOOL transient;

//系统消息
@property (nonatomic, assign, readwrite) BOOL isSys;

//会话静音
@property (nonatomic, assign, readwrite) BOOL muted;

//private

@property (nonatomic , strong) AVIMConversation *leanConversation;

@end

@implementation LLAIMConversation

+ (instancetype) conversationWithLeanCloudConversation:(AVIMConversation *)conversation {
    
    if (!conversation) {
        return nil;
    }
    
    LLAIMConversation *imConversation = [LLAIMConversation new];
    
    imConversation.clientId = conversation.clientId;
    imConversation.conversationId = conversation.conversationId;
    imConversation.createAt = conversation.createAt;
    imConversation.conversationName = conversation.name;
    imConversation.transient = conversation.transient;
    imConversation.muted = conversation.muted;
    imConversation.leanConversation = conversation;
    
    //get creator info
    
    //get members info from extension attributes
    
    //get is system message from extension attributes
    
    return imConversation;
    
    
}

@end
