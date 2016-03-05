//
//  LLAInstantMessageService.h
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLAInstantMessageHeader.h"

#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

@class LLAIMConversation;
@class LLAUser;

@interface LLAInstantMessageService : NSObject

@property(nonatomic , readonly) NSString *currentUIDString;

@property(nonatomic , readonly) IMClientStatus clientStatus;

@property(nonatomic , readonly) AVIMClient *imClient;

+ (instancetype) shareService;

- (void) openWithClientId:(NSString *) clientId callBack:(LLAIMBooleanResultBlock) callBack;

- (void) closeClientWithCallBack:(LLAIMBooleanResultBlock) callBack;

//create conversation

- (void) createSingleChatConversationWithMembers:(NSArray<LLAUser *> *) members callBack:(LLAIMConversationResultBlock) callBack;

//

-(BOOL) isConversationChatting:(LLAIMConversation *)conversation;

-(void) addChattingCoversation:(LLAIMConversation *)conversation;

-(void) removeChattinCoversation:(LLAIMConversation *)conversation;

@end
