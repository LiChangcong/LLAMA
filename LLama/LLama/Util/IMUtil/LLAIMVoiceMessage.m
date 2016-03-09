//
//  LLAIMVoiceMessage.m
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAIMVoiceMessage.h"

@implementation LLAIMVoiceMessage

- (void) updateMessageWithNewMessage:(LLAIMMessage *)newMessage {
    [super updateMessageWithNewMessage:newMessage];
    
    LLAIMVoiceMessage *message = (LLAIMVoiceMessage *) newMessage;
    
    self.size = message.size;
    self.format = message.format;
    self.duration = message.duration;
    self.audioURL = message.audioURL;
}

@end
