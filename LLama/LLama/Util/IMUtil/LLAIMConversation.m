//
//  LLAIMConversation.m
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAIMConversation.h"

#import <AVOSCloudIM/AVOSCloudIM.h>
#import <AVOSCloud/AVOSCloud.h>

#import "LLAInstantMessageStorageUtil.h"

#import "LLAIMImageMessage.h"
#import "LLAIMVoiceMessage.h"

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

//@property (nonatomic , strong) AVIMConversation *leanConversation;

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
    
    NSDictionary *attributes = conversation.attributes;
    
    //get creator info
    imConversation.creator = [[LLAInstantMessageStorageUtil shareInstance] getUserByUserId:conversation.clientId];
    //get members info from extension attributes
    
    NSMutableArray<LLAUser *> *membersArray = [NSMutableArray array];
    
    for (NSDictionary *member in [attributes valueForKey:LLACONVERSATION_ATTRIBUTES_MEMBERSKEY]) {
        
        if ([member isKindOfClass:[NSDictionary class]]) {
            
            LLAUser *memberUser = [LLAUser parseJsonWidthDic:member];
            //storage user
            LLAUser *storageMember = [[LLAInstantMessageStorageUtil shareInstance] getUserByUserId:memberUser.userIdString];
            if (!storageMember) {
                [[LLAInstantMessageStorageUtil shareInstance] insertUserWithUserInfo:memberUser];
                [membersArray addObject:memberUser];
            }else {
                [membersArray addObject:storageMember];
            }
            
            if ([memberUser.userIdString isEqualToString:conversation.clientId]) {
                imConversation.creator = storageMember ? storageMember : memberUser;
            }
        }
    }
    
    imConversation.members = membersArray;
    
    //get is system message from extension attributes
    
    imConversation.isSys = [[attributes valueForKey:LLACONVERSATION_ATTRIBUTES_TYPEKEY] integerValue] == LLAConversationType_System;
    
    
    
    return imConversation;
    
    
}

- (void) sendMessage:(LLAIMMessage *)message
       progressBlock:(LLAIMProgressBlock)progressBlock
            callback:(LLAIMBooleanResultBlock)callback {
    
    //
    
    AVIMTypedMessage *typeMessage = nil;
    
    if (message.mediaType == LLAIMMessageType_Text) {
    
        AVIMTextMessage *textMessage = [AVIMTextMessage messageWithContent:message.content];
        typeMessage = textMessage;
        
    }else if (message.mediaType == LLAIMMessageType_Image) {
    
        AVIMImageMessage *imageMessage = [AVIMImageMessage messageWithText:@"" file:[AVFile fileWithURL:((LLAIMImageMessage *)message).imageURL] attributes:nil];
        
        typeMessage = imageMessage;
        
    }else if (message.mediaType == LLAIMMessageType_Audio) {
        
        AVIMAudioMessage *audioMessage = [AVIMAudioMessage messageWithText:@"" file:[AVFile fileWithURL:((LLAIMVoiceMessage *)message).audioURL] attributes:nil];
        
        typeMessage = audioMessage;
        
    }
    
    if (typeMessage) {
        [self.leanConversation sendMessage:typeMessage progressBlock:^(NSInteger percentDone) {
            if (progressBlock)
                progressBlock(percentDone/100.0);
            
        } callback:^(BOOL succeeded, NSError *error) {
            if (callback)
                callback(succeeded,error);
        }];
    }else {
        if (callback)
            callback(NO,nil);
    }
    
    
}

@end
