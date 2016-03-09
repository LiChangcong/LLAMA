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
#import "LLAInstantMessageDispatchManager.h"

#import "LLAIMImageMessage.h"
#import "LLAIMVoiceMessage.h"

#import "SDWebImageManager.h"
#import "LLAAudioCacheUtil.h"

#import "XHVoiceCommonHelper.h"

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
    imConversation.keyedConversation = [conversation keyedConversation];
    
    NSDictionary *attributes = conversation.attributes;
    
    //get creator info
    imConversation.creator = [[LLAInstantMessageStorageUtil shareInstance] getUserByUserId:conversation.clientId];
    //get members info from  . attributes
    
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
            isResent:(BOOL)isResent
       progressBlock:(LLAIMProgressBlock)progressBlock
            callback:(LLAIMSendMessageResultBlock)callback{
    
    //
    
    AVIMTypedMessage *typeMessage = nil;
    
    if (message.mediaType == LLAIMMessageType_Text) {
    
        AVIMTextMessage *textMessage = [AVIMTextMessage messageWithText:message.content attributes:nil];
        typeMessage = textMessage;
        
    }else if (message.mediaType == LLAIMMessageType_Image) {
    
        NSString *tempImagePath = [LLAIMMessage filePathForKey:message.messageId];
        
        AVIMImageMessage *imageMessage = [AVIMImageMessage messageWithText:nil attachedFilePath:tempImagePath attributes:nil];
        
        typeMessage = imageMessage;
        
    }else if (message.mediaType == LLAIMMessageType_Audio) {
        
        NSString *keyString = [XHVoiceCommonHelper keyFromPath:((LLAIMVoiceMessage *)message).audioURL];
        NSString *voicePath = [XHVoiceCommonHelper audioPathWithKey:keyString];
        
        AVIMAudioMessage *audioMessage = [AVIMAudioMessage messageWithText:nil attachedFilePath:voicePath attributes:nil];
        
        typeMessage = audioMessage;
        
    }
    
    //set attributes,for android
    typeMessage.attributes = self.leanConversation.attributes;
    
    if (typeMessage) {
        
        message.conversationId = self.conversationId;
        message.msgStatus = LLAIMMessageStatusSending;
        
        //save to disk
        if (!isResent) {
            [[LLAInstantMessageStorageUtil shareInstance] insertMsg:message];
        //dispatch it
            [[LLAInstantMessageDispatchManager sharedInstance] dispatchNewMessageArrived:message conversation:self];
        }
        
        [self.leanConversation sendMessage:typeMessage progressBlock:^(NSInteger percentDone) {
            if (progressBlock)
                progressBlock(percentDone/100.0);
            
        } callback:^(BOOL succeeded, NSError *error) {
            
            LLAIMMessage *newMessage = nil;
            
            if (succeeded) {
            
                newMessage = [LLAIMMessage messageFromLeanTypedMessage:typeMessage];
                //save temp image to cache
                if (message.mediaType == LLAIMMessageType_Image) {
                    
                    NSString *tempImagePath = [LLAIMMessage filePathForKey:message.messageId];
                    UIImage *tempImage = [UIImage imageWithContentsOfFile:tempImagePath];
                    if (tempImage) {
                        
                        [[SDWebImageManager sharedManager] saveImageToCache:tempImage forURL:[NSURL URLWithString:typeMessage.file.url]];
                        
                        [self performSelector:@selector(deleteDiskImage:) withObject:[((LLAIMImageMessage *)message).imageURL path] afterDelay:5];
                    }
                    
                    //[[NSFileManager defaultManager] removeItemAtPath:[((LLAIMImageMessage *)message).imageURL path] error:nil];
                    
                }else if (message.mediaType == LLAIMMessageType_Audio) {
                    
                    //move amr,wav file to cache and rename it
                    //if wav file is playing delete it when it plays end
                    
                    NSString *keyString = [XHVoiceCommonHelper keyFromPath:((LLAIMVoiceMessage *)message).audioURL];
                    NSString *voicePath = [XHVoiceCommonHelper audioPathWithKey:keyString];

                    
                    NSURL *audioURL = [NSURL URLWithString:((AVIMAudioMessage *)typeMessage).file.url];
                    
                    [[LLAAudioCacheUtil shareInstance] saveAmrFile:voicePath forURL:audioURL];
                    
                    //delete ,or mark the wav video should be delete
                    
                }
            
                //
                [[LLAInstantMessageStorageUtil shareInstance] updateFailedMsg:newMessage byTmpId:message.messageId];
                
                if (callback) {
                    callback(succeeded,newMessage,error);
                }

                
            }else {
                
                newMessage = message;
                newMessage.msgStatus = LLAIMMessageStatusFailed;
                
                [[LLAInstantMessageStorageUtil shareInstance] updateStatus:LLAIMMessageStatusFailed byMsgId:newMessage.messageId];
                if (callback)
                    callback(succeeded,newMessage,error);
            }
            
        }];
    }else {
        if (callback)
            callback(NO,message,nil);
    }
    
    
}

- (void) deleteDiskImage:(id) path {
    
    [[NSFileManager defaultManager] removeItemAtPath:(NSString *)path error:nil];
    
}

@end