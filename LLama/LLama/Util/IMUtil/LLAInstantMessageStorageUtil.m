//
//  LLAInstantMessageStorageUtil.m
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAInstantMessageStorageUtil.h"
#import "FMDB.h"
#import "LLAUser.h"

#import "LLAInstantMessageService.h"

#import <AVOSCloudIM/AVOSCloudIM.h>

#define MSG_TABLE_SQL @"CREATE TABLE IF NOT EXISTS `msgs` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `msg_id` VARCHAR(63) UNIQUE NOT NULL,`convid` VARCHAR(63) NOT NULL,`object` BLOB NOT NULL,`time` VARCHAR(63) NOT NULL)"

#define ROOMS_TABLE_SQL @"CREATE TABLE IF NOT EXISTS `rooms` (`id` INTEGER PRIMARY KEY AUTOINCREMENT,`convid` VARCHAR(63) UNIQUE NOT NULL,`conObject` BLOB NOT NULL,`unread_count` INTEGER DEFAULT 0)"

#define USERINFO_TABLE_SQL @"CREATE TABLE IF NOT EXISTS 'userInfo' ('id' INTEGER PRIMARY KEY AUTOINCREMENT,'uid' VARCHAR(200) UNIQUE NOT NULL,'name' VARCHAR(200) NOT NULL,'headUrl' VARCHAR(300),'role' INTEGER,'roleImg' VARCHAR(200), 'levelName' VARCHAR(50) , 'levelPicURL' VARCHAR(200),'updateTime' VARCHAR(63) NOT NULL)"

#define FIELD_ID @"id"
#define FIELD_CONVID @"convid"
#define FIELD_OBJECT @"object"
#define FIELD_TIME @"time"
#define FIELD_MSG_ID @"msg_id"

#define FIELD_CONVERSATION_OBJECT @"conObject"

#define FIELD_UNREAD_COUNT @"unread_count"

#define USERINFO_TABLE_NAME @"USERINFO_TABLE_NAME"

#define USERINFO_FIELD_UID @"uid"
#define USERINFO_FIELD_NAME @"name"
#define USERINFO_FIELD_HEADURL @"headUrl"
#define USERINFO_FIELD_ROLE @"role"
#define USERINFO_FIELD_ROLEIMG @"roleImg"
#define USERINFO_FIELD_LEVLENAME @"levelName"
#define USERINFO_FIELD_LEVELPICURL @"levelPicURL"
#define USERINFO_FIELD_UPDATETIME @"updateTime"

@interface LLAInstantMessageStorageUtil()
{
    
}

@property(nonatomic , strong) FMDatabaseQueue *dbQueue;
@property(nonatomic , strong) FMDatabaseQueue *userInfoDBQueue;

@end

@implementation LLAInstantMessageStorageUtil

+ (instancetype) shareInstance {
    
    static LLAInstantMessageStorageUtil *shareInstance;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareInstance = [[[self class] alloc] init];
    });
    
    return shareInstance;
    
}

- (instancetype) init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

#pragma mark - Setup dataBase

-(NSString *)dbPathWithUserId:(NSString *)userId{
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *chatLibDirectoryPath = [libPath stringByAppendingPathComponent:@"chatDirectory"];
    if (![manager fileExistsAtPath:chatLibDirectoryPath]){
        [manager createDirectoryAtPath:chatLibDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [chatLibDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"chat_%@",userId]];
}

-(void) setupWithUserId:(NSString *)userId{
    
    if (_dbQueue) {
        [_dbQueue close];
    }
    
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:[self dbPathWithUserId:userId]];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:MSG_TABLE_SQL];
        [db executeUpdate:ROOMS_TABLE_SQL];
    }];
}
-(void) setupUserInfoDBQueue{
    if (!_userInfoDBQueue){
        _userInfoDBQueue = [FMDatabaseQueue databaseQueueWithPath:[self dbPathWithUserId:USERINFO_TABLE_NAME]];
        [_userInfoDBQueue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:USERINFO_TABLE_SQL];
        }];
    }
}
-(void)closeDBQueue{
    if (_dbQueue){
        [_dbQueue close];
        [_userInfoDBQueue close];
        _dbQueue = nil;
        _userInfoDBQueue = nil;
    }
}

#pragma mark -
#pragma mark MessageTable
-(NSArray<LLAIMMessage *>*)getMsgsWithConvid:(NSString*)convid maxTime:(int64_t)time limit:(int)limit{
    __block NSArray* msgs=nil;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString* timeStr=[self strOfInt64:time];
        FMResultSet* rs=[db executeQuery:@"select * from msgs where convid=? and time<? order by time desc limit ?" withArgumentsInArray:@[convid,timeStr,@(limit)]];
        msgs=[self reverseArray:[self getMsgsByResultSet:rs]];
        [rs close];
    }];
    return msgs;
}

-(LLAIMMessage *)getMsgByMsgId:(NSString*)msgId{
    __block LLAIMMessage* msg=nil;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet* rs=[db executeQuery:@"SELECT * FROM msgs where msg_id=?" withArgumentsInArray:@[msgId]];
        if([rs next]){
            msg=[self getMsgByResultSet:rs];
        }
        [rs close];
    }];
    return msg;
}

-(BOOL)updateMsg:(LLAIMMessage*)msg byMsgId:(NSString*)msgId{
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSData* data=[NSKeyedArchiver archivedDataWithRootObject:msg];
        result=[db executeUpdate:@"UPDATE msgs SET object=? WHERE msg_id=?" withArgumentsInArray:@[data,msgId]];
    }];
    return result;
}

-(BOOL)updateFailedMsg:(LLAIMMessage*)msg byTmpId:(NSString*)tmpId{
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSData* data=[NSKeyedArchiver archivedDataWithRootObject:msg];
        result=[db executeUpdate:@"UPDATE msgs SET object=?,time=?,msg_id=? WHERE msg_id=?"
            withArgumentsInArray:@[data,[self strOfInt64:msg.sendTimestamp],msg.messageId,tmpId]];
    }];
    return result;
}

-(BOOL)updateStatus:(LLAIMMessageStatus)status byMsgId:(NSString*)msgId{
    LLAIMMessage* msg=[self getMsgByMsgId:msgId];
    if(msg){
        msg.msgStatus = status;
        return [self updateMsg:msg byMsgId:msgId];
    }else{
        return NO;
    }
}

-(NSMutableArray*)getMsgsByResultSet:(FMResultSet*)rs{
    NSMutableArray *result = [NSMutableArray array];
    while ([rs next]) {
        LLAIMMessage* msg=[self getMsgByResultSet:rs];
        if(msg!=nil){
            [result addObject:msg];
        }
    }
    [rs close];
    return result;
}

-(LLAIMMessage* )getMsgByResultSet:(FMResultSet*)rs{
    NSData* data=[rs objectForColumnName:FIELD_OBJECT];
    if([data isKindOfClass:[NSData class]] && data.length>0){
        LLAIMMessage* msg;
        @try {
            msg=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        return msg;
    }else{
        return nil;
    }
}

-(int64_t)insertMsg:(LLAIMMessage *)msg{
    __block int64_t rowId;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSData* data=[NSKeyedArchiver archivedDataWithRootObject:msg];
        [db executeUpdate:@"INSERT INTO msgs (msg_id,convid,object,time) VALUES(?,?,?,?)"
     withArgumentsInArray:@[msg.messageId,msg.conversationId,data,[self strOfInt64:msg.sendTimestamp]]];
        rowId=[db lastInsertRowId];
    }];
    return rowId;
}

-(void)deleteMsgsByConvid:(NSString*)convid{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM msgs where convid=?" withArgumentsInArray:@[convid]];
    }];
}
#pragma mark -
#pragma mark RoomsTable

-(LLAIMConversation *)getRoomByResultSet:(FMResultSet*)rs{
    
    LLAIMConversation *conv = [self getConversationByResultSet:rs];
    conv.unreadCount = [rs intForColumn:FIELD_UNREAD_COUNT];
    conv.lastMessage=[self getMsgByResultSet:rs];
    
    AVIMClient *defaultClient = [LLAInstantMessageService shareService].imClient;
    
    if (!defaultClient) {
        defaultClient = [AVIMClient defaultClient];
    }
    //conv.leanConversation = [[LLAInstantMessageService shareService].imClient conversationWithKeyedConversation:conv.keyedConversation];
    conv.leanConversation = [defaultClient conversationWithKeyedConversation:conv.keyedConversation];
    
    return conv;
}

- (LLAIMConversation *) getConversationByResultSet:(FMResultSet *) rs {
    NSData* data=[rs objectForColumnName:FIELD_CONVERSATION_OBJECT];
    if (data && data.length > 0 && [data isKindOfClass:[NSData class]]) {
        LLAIMConversation* converstion;
        @try {
            converstion = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        return converstion;

    }else {
        return nil;
    }
}

-(NSArray*)getRooms{
    NSMutableArray* rooms=[NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet* rs=[db executeQuery:@"SELECT * FROM rooms LEFT JOIN (SELECT msgs.object,MAX(time) as time ,msgs.convid as msg_convid FROM msgs GROUP BY msgs.convid) ON rooms.convid=msg_convid ORDER BY time DESC"];
        while ([rs next]) {
            [rooms addObject:[self getRoomByResultSet:rs]];
        }
        [rs close];
    }];
    return rooms;
}

-(NSInteger)countUnread{
    __block NSInteger unreadCount=0;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet* rs=[db executeQuery:@"SELECT SUM(rooms.unread_count) FROM rooms"];
        if ([rs next]) {
            unreadCount=[rs intForColumnIndex:0];
        }
        [rs close];
    }];
    return unreadCount;
}

-(void)insertRoomWithConvid:(NSString*)convid coverObj:(LLAIMConversation *) conversation{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet* rs=[db executeQuery:@"SELECT * FROM rooms WHERE convid=?",convid];
        if([rs next]==NO){
            AVIMConversation *leanCon = conversation.leanConversation;
            conversation.leanConversation = nil;
            NSData* data=[NSKeyedArchiver archivedDataWithRootObject:conversation];
            conversation.leanConversation = leanCon;
            [db executeUpdate:@"INSERT INTO rooms (convid,conObject) VALUES(?,?) " withArgumentsInArray:@[convid,data]];
        }
        [rs close];
    }];
}

-(void)deleteRoomByConvid:(NSString*)convid{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM rooms WHERE convid=?" withArgumentsInArray:@[convid]];
    }];
}

-(void)incrementUnreadWithConvid:(NSString*)convid{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"UPDATE rooms SET unread_count=unread_count+1 WHERE convid=?" withArgumentsInArray:@[convid]];
    }];
}

-(void)clearUnreadWithConvid:(NSString*)convid{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"UPDATE rooms SET unread_count=0 WHERE convid=?" withArgumentsInArray:@[convid]];
    }];
}

#pragma mark -
#pragma mark UserInfoTable
-(void)updateUserInfoWithUser:(LLAUser *) user{
    [_userInfoDBQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"REPLACE INTO userInfo (uid,name,headUrl,updateTime) VALUES(?,?,?,?)" withArgumentsInArray:
         [NSArray arrayWithObjects:
          user.userIdString,
          user.userName,
          user.headImageURL ? user.headImageURL : @"",
          [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]*1000], nil]];
    }];
}

-(NSArray<LLAUser *> *)getOldestUserInfo{
    
    [self setupUserInfoDBQueue];
    
    NSMutableArray *userInfos = [NSMutableArray array];
    [_userInfoDBQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM userInfo ORDER BY updateTime ASC LIMIT 0,99"];
        while ([rs next]) {
            [userInfos addObject:[self getUserByResultSet:rs]];
        }
        [rs close];
    }];
    return userInfos;
}
-(LLAUser *)getUserByUserId:(NSString *) userIDString{
    __block LLAUser *user = nil;
    [_userInfoDBQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM userInfo WHERE uid=?" withArgumentsInArray:[NSArray arrayWithObject:userIDString]];
        while ([rs next]) {
            user = [self getUserByResultSet:rs];
        }
        [rs close];
        
    }];
    return user;
}
-(void) insertUserWithUserInfo:(LLAUser *)user{
    [_userInfoDBQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM userInfo where uid=?" withArgumentsInArray:[NSArray arrayWithObjects:user.userIdString, nil]];
        if ([rs next] == NO){
            [db executeUpdate:@"INSERT INTO userInfo (uid,name,headUrl,updateTime) VALUES(?,?,?,?)" withArgumentsInArray:[NSArray arrayWithObjects:user.userIdString,user.userName,user.headImageURL?user.headImageURL:@"",[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]*1000], nil]];
        }
        [rs close];
    }];
}

-(LLAUser *)getUserByResultSet:(FMResultSet *)rs{
    LLAUser *user = [[LLAUser alloc] init];
    user.userIdString = [rs objectForColumnName:USERINFO_FIELD_UID];
    user.userName = [rs objectForColumnName:USERINFO_FIELD_NAME];
    user.headImageURL = [rs objectForColumnName:USERINFO_FIELD_HEADURL];
//    user.role = [[rs objectForColumnName:USERINFO_FIELD_ROLE] integerValue];
//    user.roleImageUrl = [rs objectForColumnName:USERINFO_FIELD_ROLEIMG];
//    user.level = [rs objectForColumnName:USERINFO_FIELD_LEVLENAME];
//    user.levelPicURL = [rs objectForColumnName:USERINFO_FIELD_LEVELPICURL];
    return user;
}
#pragma mark -
#pragma mark - int64
-(int64_t)int64OfStr:(NSString*)str{
    return [str longLongValue];
}

-(NSString*)strOfInt64:(int64_t)num{
    return [[NSNumber numberWithLongLong:num] stringValue];
}

-(NSArray*)reverseArray:(NSArray*)originArray{
    NSMutableArray* array=[NSMutableArray arrayWithCapacity:[originArray count]];
    NSEnumerator* enumerator=[originArray reverseObjectEnumerator];
    for(id element in enumerator){
        [array addObject:element];
    }
    return array;
}


@end
