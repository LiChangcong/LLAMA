//
//  LLAMessageCenterRoomInfo.m
//  LLama
//
//  Created by Live on 16/2/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAMessageCenterRoomInfo.h"

@implementation LLAMessageCenterRoomInfo

+ (instancetype) roomInfoWithConversation:(LLAIMConversation *)conversation {
    LLAMessageCenterRoomInfo *room = [LLAMessageCenterRoomInfo new];
    room.conversation = conversation;
    
    return room;
}

@end
