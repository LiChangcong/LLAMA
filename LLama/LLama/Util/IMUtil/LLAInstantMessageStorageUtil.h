//
//  LLAInstantMessageStorageUtil.h
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LLAIMMessage.h"
#import "LLAIMConversation.h"

@interface LLAInstantMessageStorageUtil : NSObject

+ (instancetype) shareInstance;

- (NSString *) dbPathWithUserId:(NSString*)userId;
- (void) setupWithUserId:(NSString*)userId;
- (void) setupUserInfoDBQueue;
- (void) closeDBQueue;

-(NSArray<LLAIMMessage *>*)getMsgsWithConvid:(NSString*)convid maxTime:(int64_t)time limit:(int)limit;
-(int64_t)insertMsg:(LLAIMMessage *)msg;

-(LLAIMMessage *)getMsgByMsgId:(NSString*)msgId;

-(BOOL)updateStatus:(LLAIMMessageStatus)status byMsgId:(NSString*)msgId;

-(BOOL)updateMsg:(LLAIMMessage *)msg byMsgId:(NSString*)msgId;

-(BOOL)updateFailedMsg:(LLAIMMessage *)msg byTmpId:(NSString*)tmpId;

-(void)deleteMsgsByConvid:(NSString*)convid;

-(NSArray*)getRooms;

-(NSInteger)countUnread;

-(void)insertRoomWithConvid:(NSString*)convid coverObj:(LLAIMConversation *) conversation;

-(void)deleteRoomByConvid:(NSString*)convid;

-(void)incrementUnreadWithConvid:(NSString*)convid;

-(void)clearUnreadWithConvid:(NSString*)convid;

-(void)updateUserInfoWithUser:(LLAUser *) user;

-(LLAUser *)getUserByUserId:(NSString *) userIDString;

-(NSArray<LLAUser *> *)getOldestUserInfo;
-(void) insertUserWithUserInfo:(LLAUser *) user;


@end
