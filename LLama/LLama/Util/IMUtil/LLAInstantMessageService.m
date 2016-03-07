//
//  LLAInstantMessageService.m
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAInstantMessageService.h"
#import "LLAIMConversation.h"

#import "LLAInstantMessageDispatchManager.h"
#import "LLAInstantMessageStorageUtil.h"


@interface LLAInstantMessageService()<AVIMClientDelegate>
{
    
    NSMutableArray *chattingCoversations;
}

@property(nonatomic , readwrite , strong) AVIMClient *imClient;

@property(nonatomic , readwrite , strong) NSString *currentUIDString;

@property(nonatomic , readwrite , assign) IMClientStatus clientStatus;

@end

@implementation LLAInstantMessageService
@synthesize currentUIDString;
@synthesize imClient;

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
    
    _clientStatus = IMClientStatus_Offline;
    
    [[LLAInstantMessageDispatchManager sharedInstance] dispatchImClientStatusChanged:_clientStatus];
}

- (void) imClientResumed:(AVIMClient *)imClient {
    
    _clientStatus = IMClientStatus_Online;
    [[LLAInstantMessageDispatchManager sharedInstance] dispatchImClientStatusChanged:_clientStatus];
}

- (void) imClientResuming:(AVIMClient *)imClient {
    
    _clientStatus = IMClientStatus_Connecting;
    [[LLAInstantMessageDispatchManager sharedInstance] dispatchImClientStatusChanged:_clientStatus];
}

#pragma mark - AVIMClient message Delegate

- (void) conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message {
    
}

- (void) conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    
    //if (conversation.members && [conversation.members containsObject:imClient.clientId]) {
        
        //
    if (!conversation || !message) {
        return;
    }
    
    LLAIMConversation *imCoversation = [LLAIMConversation conversationWithLeanCloudConversation:conversation];
    LLAIMMessage *imMessage = [LLAIMMessage messageFromLeanTypedMessage:message];
        
    [[LLAInstantMessageDispatchManager sharedInstance] dispatchNewMessageArrived:imMessage conversation:imCoversation];
    
    [[LLAInstantMessageStorageUtil shareInstance] insertMsg:imMessage];
    
    if (![self isConversationChatting:imCoversation]) {
        
        [[LLAInstantMessageStorageUtil shareInstance] insertRoomWithConvid:imCoversation.conversationId coverObj:imCoversation];
        [[LLAInstantMessageStorageUtil shareInstance] incrementUnreadWithConvid:imCoversation.conversationId];
        
        //
    }
        
    //}
    
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
    imClient.delegate = self;
    
    [imClient openWithCallback:^(BOOL succeeded, NSError *error) {
        
        [[LLAInstantMessageStorageUtil shareInstance] setupWithUserId:currentUIDString];
        [[LLAInstantMessageStorageUtil shareInstance] setupUserInfoDBQueue];
        
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
            if (succeeded) {
                [[LLAInstantMessageStorageUtil shareInstance] closeDBQueue];
            }
        }];
        
    }else {
        if (callBack)
            callBack(NO,nil);
    }
}

#pragma mark - CreateConversations

- (void) createSingleChatConversationWithMembers:(NSArray<LLAUser *> *)members callBack:(LLAIMConversationResultBlock)callBack {
    
    //
    NSMutableArray *memberIds = [NSMutableArray arrayWithCapacity:members.count];
    
    NSMutableArray *membersInfoArray = [NSMutableArray arrayWithCapacity:members.count];
    
    NSString *conversationName = @"";
    
    for (LLAUser *user in members) {
        [memberIds addObject:user.userIdString];
        
        [membersInfoArray addObject:[user dicForIMAttributes]];
        
        if (![user.userIdString isEqualToString:currentUIDString]) {
            conversationName = user.userName;
        }
    };
    
    //construct attribues
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setValue:@(LLAConversationType_Single) forKey:LLACONVERSATION_ATTRIBUTES_TYPEKEY];
    [attributes setValue:membersInfoArray forKey:LLACONVERSATION_ATTRIBUTES_MEMBERSKEY];
    
    [imClient createConversationWithName:conversationName clientIds:memberIds attributes:attributes options:AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
        
        if (!error) {
            //construct conversation
            LLAIMConversation *imConv = [LLAIMConversation conversationWithLeanCloudConversation:conversation];
            
            [[LLAInstantMessageDispatchManager sharedInstance] dispatchNewMessageArrived:nil conversation:imConv];
            
            [[LLAInstantMessageStorageUtil shareInstance] insertRoomWithConvid:imConv.conversationId coverObj:imConv];
            
            
            if (callBack)
                callBack(imConv,error);
            
        }else {
            if (callBack)
                callBack (nil,error);
        }
        
    }];
    
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
