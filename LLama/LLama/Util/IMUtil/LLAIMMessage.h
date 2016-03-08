//
//  LLAIMMessage.h
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"

#import "LLAUser.h"

typedef NS_ENUM(NSInteger , LLAIMMessageIOType) {
    //别人发的
    LLAIMMessageIOType_In = 1,
    //我发的
    LLAIMMessageIOType_Out = 2,
};

typedef NS_ENUM(NSInteger , LLAIMMessageStatus) {
    LLAIMMessageStatusNone = 0,
    LLAIMMessageStatusSending = 1,
    LLAIMMessageStatusSent,
    LLAIMMessageStatusDelivered,
    LLAIMMessageStatusFailed,
};

typedef NS_ENUM(NSInteger , LLAIMMessageType){
    LLAIMMessageType_None = 0,
    LLAIMMessageType_Text = -1,
    LLAIMMessageType_Image = -2,
    LLAIMMessageType_Audio = -3,
};

@class AVIMTypedMessage;

@interface LLAIMMessage : MTLModel

@property (nonatomic , assign ) LLAIMMessageIOType ioType;

@property (nonatomic , assign ) LLAIMMessageStatus msgStatus;

@property (nonatomic , assign) LLAIMMessageType mediaType;

@property (nonatomic ,strong) NSString *messageId;

@property (nonatomic ,strong) NSString *clientId;

@property (nonatomic ,strong) NSString *conversationId;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) int64_t sendTimestamp;

@property (nonatomic, assign) int64_t deliveredTimestamp;

@property (nonatomic, assign) BOOL transient;

@property (nonatomic, strong) LLAUser *authorUser;

+ (instancetype) messageFromLeanTypedMessage:(AVIMTypedMessage *) leanMessage;

+ (instancetype) textMessageWithContent:(NSString *) content;

+ (instancetype) imageMessageWithImage:(UIImage *) image;

+ (instancetype) voiceMessageWithAudioFilePath:(NSString *) audioFilePath withDuration:(CGFloat) duration;

//temp image file path
+ (NSString *) filePathForKey:(NSString *)key;

@end
