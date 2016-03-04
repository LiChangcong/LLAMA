//
//  LLAMessageCenterRoomInfo.h
//  LLama
//
//  Created by Live on 16/2/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"

#import "LLAIMConversation.h"

@interface LLAMessageCenterRoomInfo : MTLModel

@property(nonatomic , strong) LLAIMConversation *conversation;

+ (instancetype) roomInfoWithConversation:(LLAIMConversation *) conversation;

@end
