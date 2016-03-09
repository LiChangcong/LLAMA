//
//  LLAIMImageMessage.m
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAIMImageMessage.h"

@implementation LLAIMImageMessage

- (void) updateMessageWithNewMessage:(LLAIMMessage *)newMessage {
    [super updateMessageWithNewMessage:newMessage];
    
    LLAIMImageMessage *imageMessage = (LLAIMImageMessage *) newMessage;
    
    self.width = imageMessage.width;
    self.height = imageMessage.height;
    self.size = imageMessage.size;
    self.imageURL = imageMessage.imageURL;
    self.format = imageMessage.format;
}

@end
