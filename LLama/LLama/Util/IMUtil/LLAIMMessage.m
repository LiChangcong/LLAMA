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

#import "LLAInstantMessageStorageUtil.h"

#import "LLAIMImageMessage.h"
#import "LLAIMVoiceMessage.h"

static NSString * const tempImageCacheDirectory = @"tempImage";

@implementation LLAIMMessage

+ (instancetype) messageFromLeanTypedMessage:(AVIMTypedMessage *)leanMessage {
    //
    if (!leanMessage) {
        return nil;
    }
    
    LLAIMMessage *message = nil;
    
    if (leanMessage.mediaType == kAVIMMessageMediaTypeText) {
        
        LLAIMMessage *textMessage = [LLAIMMessage new];
        textMessage.mediaType = LLAIMMessageType_Text;
        
        message = textMessage;
        
    }else if (leanMessage.mediaType == kAVIMMessageMediaTypeImage) {
    
        LLAIMImageMessage *imageMessage = [LLAIMImageMessage new];
        AVIMImageMessage *typeMessage = (AVIMImageMessage *) leanMessage;
        imageMessage.width = typeMessage.width;
        imageMessage.height = typeMessage.height;
        imageMessage.format = typeMessage.format;
        imageMessage.imageURL = [NSURL URLWithString:typeMessage.file.url];
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
        
        LLAIMMessage *textMessage = [LLAIMMessage new];
        textMessage.mediaType = LLAIMMessageType_Text;
        
        message = textMessage;
        
    }
    
    //common
    message.ioType = leanMessage.ioType == AVIMMessageIOTypeIn ? LLAIMMessageIOType_In : LLAIMMessageIOType_Out;
    message.msgStatus = (NSInteger)leanMessage.status;
    message.messageId = leanMessage.messageId;
    message.clientId = leanMessage.clientId;
    message.conversationId = leanMessage.conversationId;
    message.content = leanMessage.text;
    message.sendTimestamp = leanMessage.sendTimestamp;
    message.deliveredTimestamp = leanMessage.deliveredTimestamp;
    message.transient = leanMessage.transient;
    
    //get author info from message
    if (message.clientId.length > 0)
        message.authorUser = [[LLAInstantMessageStorageUtil shareInstance] getUserByUserId:message.clientId];
    
    return message;
}

+ (instancetype) textMessageWithContent:(NSString *) content {
    
    LLAIMMessage *textMessage = [LLAIMMessage new];
    textMessage.content = content;
    textMessage.authorUser = [LLAUser me];
    textMessage.sendTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    textMessage.mediaType = LLAIMMessageType_Text;
    textMessage.messageId = [self generateTmpMessageId];
    
    return textMessage;
    
}

+ (instancetype) imageMessageWithImage:(UIImage *) image {
    
    LLAIMImageMessage *imageMessage = [LLAIMImageMessage new];
    
    imageMessage.mediaType = LLAIMMessageType_Image;
    imageMessage.authorUser = [LLAUser me];
    imageMessage.sendTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    imageMessage.width = image.size.width;
    imageMessage.height = image.size.height;
    imageMessage.messageId = [self generateTmpMessageId];
    
    //save image to disk and then get the url
    
    imageMessage.imageURL =[NSURL fileURLWithPath:[self saveImage:image messageId:imageMessage.messageId]] ;
    
    
    return imageMessage;
    
}

+ (instancetype) voiceMessageWithAudioFilePath:(NSString *) audioFilePath {
    
    LLAIMVoiceMessage *audioMessage = [LLAIMVoiceMessage new];
    audioMessage.mediaType = LLAIMMessageType_Audio;
    audioMessage.authorUser = [LLAUser me];
    audioMessage.sendTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    audioMessage.duration = .0;
    audioMessage.messageId = [self generateTmpMessageId];

    audioMessage.audioURL = audioFilePath;
    
    return audioMessage;
    
}

//
+ (NSString *) generateTmpMessageId {
    
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString ;

}

+ (NSString *) saveImage:(UIImage *)image messageId:(NSString *) messageId {
    
    if (!image || messageId.length < 1) {
        return nil;
    }
    
    NSString *filePath = [self filePathForKey:messageId];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:NULL];
    
    BOOL success = [UIImageJPEGRepresentation(image, 0.6) writeToFile:filePath atomically:YES];
    
    
    return filePath;
    
}

+ (NSString *) filePathForKey:(NSString *)key{
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *ourDocumentPath = [documentPaths objectAtIndex:0];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSString *adVideoCachPath = [ourDocumentPath stringByAppendingPathComponent:tempImageCacheDirectory];
    if (![defaultManager fileExistsAtPath:adVideoCachPath]){
        [defaultManager createDirectoryAtPath:adVideoCachPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [adVideoCachPath stringByAppendingFormat:@"/%@.jpg",key];
}

@end
