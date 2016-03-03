//
//  LLAInstantMessageService.h
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLAInstantMessageHeader.h"

@class LLAIMConversation;

@interface LLAInstantMessageService : NSObject

@property(nonatomic , readonly) NSString *currentUIDString;

+ (instancetype) shareService;

- (void) openWithClientId:(NSString *) clientId callBack:(LLAIMBooleanResultBlock) callBack;

- (void) closeClientWithCallBack:(LLAIMBooleanResultBlock) callBack;

//

-(BOOL) isConversationChatting:(LLAIMConversation *)conversation;

-(void) addChattingCoversation:(LLAIMConversation *)conversation;

-(void) removeChattinCoversation:(LLAIMConversation *)conversation;

@end
