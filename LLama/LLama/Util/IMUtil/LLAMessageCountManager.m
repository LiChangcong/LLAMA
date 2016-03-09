//
//  LLAMessageCountManager.m
//  LLama
//
//  Created by Live on 16/3/8.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAMessageCountManager.h"

#import "LLAHttpUtil.h"
#import "LLAInstantMessageStorageUtil.h"

#import "LLAUser.h"

@interface LLAMessageCountManager()
{
    NSTimer *timer;
    
    NSInteger unreadPraiseNum;
    NSInteger unreadCommentNum;
    NSInteger unreadOrderNum;
    
    NSInteger unreadIMNum;
}

@end

@implementation LLAMessageCountManager

+ (instancetype) shareManager {
    static LLAMessageCountManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    
    return manager;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void) beginFetchCount {
    
    if (timer) {
        return;
    }
    
    
    timer =  [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(fetchCount) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
}

-(void)didBecomeActive:(NSNotification *)notification{
    //开启定时器
    
    [timer setFireDate:[NSDate distantPast]];
}

-(void)enterForeground:(NSNotification *)notification{
    //关闭定时器
    [timer setFireDate:[NSDate distantFuture]];
}

- (void) fetchCount {
    
    if (![LLAUser me].isLogin) {
        return;
    }
    
    [LLAHttpUtil httpPostWithUrl:@"/message/update" param:[NSDictionary dictionary] responseBlock:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            if ([[responseObject valueForKey:@"unread"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in [responseObject valueForKey:@"unread"]) {
                    if ([[dic valueForKey:@"type"] isEqualToString:@"ZAN"]) {
                        unreadPraiseNum = [[dic valueForKey:@"num"] integerValue];
                        
                    }else if ([[dic valueForKey:@"type"] isEqualToString:@"COMMENT"]) {
                        unreadCommentNum = [[dic valueForKey:@"num"] integerValue];
                        
                    }else if ([[dic valueForKey:@"type"] isEqualToString:@"ORDER"]) {
                        unreadOrderNum = [[dic valueForKey:@"num"] integerValue];
                    }
                }
                
                [self postTotalCountChangeNotification];

            }
            
        }
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        
    }];
    
}


#pragma mark - Public

- (NSInteger) totalUnreadCount {
    NSInteger total = 0;
    total += unreadPraiseNum;
    total += unreadCommentNum;
    total += unreadOrderNum;
    total += [self getUnreadIMNum];
    
    return total;
}

- (NSInteger) getUnreadPraiseNum {
    return unreadPraiseNum;
}
- (void) resetUnreadPraiseNum {
    unreadPraiseNum = 0;
    
    //
    [self postTotalCountChangeNotification];
}

- (NSInteger) getUnreadCommentNum {
    return unreadCommentNum;
}

- (void) resetUnreadCommnetNum {
    unreadCommentNum = 0;
    
    //
    [self postTotalCountChangeNotification];
}

- (NSInteger) getUnreadOrderNum {
    return unreadOrderNum;
}

- (void) resetUnreadOrderNum {
    
    unreadOrderNum = 0;
    
    [self postTotalCountChangeNotification];
}

- (NSInteger) getUnreadIMNum {
    NSInteger num = [[LLAInstantMessageStorageUtil shareInstance] countUnread];
    return num;
}

- (void) unReadIMNumChanged {
    [self postTotalCountChangeNotification];
}

- (void) postTotalCountChangeNotification {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LLA_UNREAD_MESSAGE_COUNT_CHANGED_NOTIFICATION object:nil];
}

@end
