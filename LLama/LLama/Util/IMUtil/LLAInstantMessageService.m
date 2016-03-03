//
//  LLAInstantMessageService.m
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAInstantMessageService.h"
#import "LLAIMConversation.h"

#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

@interface LLAInstantMessageService()<AVIMClientDelegate>
{
    AVIMClient *imClient;
    
    NSMutableArray *chattingCoversations;
}

@property(nonatomic , readwrite , strong) NSString *currentUIDString;

@end

@implementation LLAInstantMessageService
@synthesize currentUIDString;

+ (instancetype) shareService {
    static LLAInstantMessageService *shareService = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareService = [[[self class] alloc] init];
    });
    
    return shareService;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        chattingCoversations = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - AVIMClient status Delegate

- (void)imClientPaused:(AVIMClient *)imClient error:(NSError *)error{
    
}

- (void) imClientResumed:(AVIMClient *)imClient {
    
}

- (void) imClientResuming:(AVIMClient *)imClient {
    
}

#pragma mark - AVIMClient message Delegate

- (void) conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message {
    
}

- (void) conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    
}

- (void) conversation:(AVIMConversation *)conversation messageDelivered:(AVIMMessage *)message  {
    
    
}

- (void) conversation:(AVIMConversation *)conversation membersAdded:(NSArray *)clientIds byClientId:(NSString *)clientId {
    
}

- (void) conversation:(AVIMConversation *)conversation membersRemoved:(NSArray *)clientIds byClientId:(NSString *)clientId {
    
}

- (void) conversation:(AVIMConversation *)conversation invitedByClientId:(NSString *)clientId {
    
}

- (void) conversation:(AVIMConversation *)conversation kickedByClientId:(NSString *)clientId {
    
}

- (void)client:(AVIMClient *)client didOfflineWithError:(NSError *)error {
    
}

#pragma mark - Open,close client

- (void) openWithClientId:(NSString *)clientId callBack:(LLAIMBooleanResultBlock)callBack {
    
    imClient = [[AVIMClient alloc] initWithClientId:clientId];
    
    [imClient openWithCallback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            currentUIDString = [clientId copy];
        }
        if (callBack)
            callBack(succeeded,error);
    }];
    
}

- (void) closeClientWithCallBack:(LLAIMBooleanResultBlock)callBack {
    if (!(imClient.status == AVIMClientStatusClosed || imClient.status == AVIMClientStatusClosing || imClient.status == AVIMClientStatusNone)) {
        
        [imClient closeWithCallback:^(BOOL succeeded, NSError *error) {
            if (callBack)
                callBack(succeeded,error);
        }];
        
    }else {
        if (callBack)
            callBack(NO,nil);
    }
}

#pragma mark - ChattiongCoversations
-(BOOL) isConversationChatting:(LLAIMConversation *)conversation{
    return [chattingCoversations containsObject:conversation.conversationId];
}
-(void) addChattingCoversation:(LLAIMConversation *)conversation{
    if (![chattingCoversations containsObject:conversation.conversationId]){
        [chattingCoversations addObject:conversation.conversationId];
    }
}
-(void) removeChattinCoversation:(LLAIMConversation *)conversation{
    for (NSString *convId in chattingCoversations){
        if ([convId isEqualToString:conversation.conversationId]){
            [chattingCoversations removeObject:convId];
            break;
        }
    }
}


@end
