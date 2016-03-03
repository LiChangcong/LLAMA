//
//  LLAIMMessage.m
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAIMMessage.h"

#import <AVOSCloudIM/AVOSCloudIM.h>
#import <AVOSCloud/AVOSCloud.h>

#import "LLAIMImageMessage.h"
#import "LLAIMVoiceMessage.h"

@implementation LLAIMMessage

+ (instancetype) messageFromLeanTypedMessage:(AVIMTypedMessage *)leanMessage {
    //
    if (!leanMessage) {
        return nil;
    }
    
    LLAIMMessage *message = nil;
    
    if (leanMessage.mediaType == kAVIMMessageMediaTypeText) {
        
        LLAIMMessage *textMessage = [LLAIMImageMessage new];
        textMessage.mediaType = LLAIMMessageType_Text;
        
        message = textMessage;
        
    }else if (leanMessage.mediaType == kAVIMMessageMediaTypeImage) {
    
        LLAIMImageMessage *imageMessage = [LLAIMImageMessage new];
        AVIMImageMessage *typeMessage = (AVIMImageMessage *) leanMessage;
        imageMessage.width = typeMessage.width;
        imageMessage.height = typeMessage.height;
        imageMessage.format = typeMessage.format;
        imageMessage.imageURL = typeMessage.file.url;
        imageMessage.size = typeMessage.size;
        imageMessage.mediaType = LLAIMMessageType_Image;
        
        message = imageMessage;
        
    }else if (leanMessage.mediaType == kAVIMMessageMediaTypeAudio) {
        
        LLAIMVoiceMessage *voiceMessage = [LLAIMVoiceMessage new];
        AVIMAudioMessage *typeMessage = (AVIMAudioMessage *) leanMessage;
        
        voiceMessage.duration = typeMessage.duration;
        voiceMessage.size = typeMessage.size;
        voiceMessage.audioURL = typeMessage.file.url;
        
        voiceMessage.mediaType = LLAIMMessageType_Audio;
        
        message = voiceMessage;
    
    }else {
        //unsupport mediaType message
        
        LLAIMMessage *textMessage = [LLAIMImageMessage new];
        textMessage.mediaType = LLAIMMessageType_Text;
        
        message = textMessage;
        
    }
    
    //common
    message.ioType = leanMessage.ioType == AVIMMessageIOTypeIn ? LLAIMMessageIOType_In : LLAIMMessageIOType_Out;
    message.msgStatus = (NSInteger)leanMessage.status;
    message.messageId = leanMessage.messageId;
    message.clientId = leanMessage.clientId;
    message.conversationId = leanMessage.conversationId;
    message.content = leanMessage.content;
    message.sendTimestamp = leanMessage.sendTimestamp;
    message.deliveredTimestamp = leanMessage.deliveredTimestamp;
    message.transient = leanMessage.transient;
    
    //get author info from message
    
    return message;
}

@end
