//
//  LLASyncUserInfoManager.m
//  LLama
//
//  Created by Live on 16/3/4.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLASyncUserInfoManager.h"

#import "LLAInstantMessageStorageUtil.h"
#import "LLAHttpUtil.h"

@interface LLASyncUserInfoManager()
{
    NSTimer *timer;
}

@end

@implementation LLASyncUserInfoManager

+ (instancetype) shareManager {
    static LLASyncUserInfoManager *shareManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareManager = [[[self class] alloc] init];
    });
    
    return shareManager;
    
}

- (instancetype) init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)didBecomeActive:(NSNotification *)notification{
    //开启定时器
    [timer setFireDate:[NSDate distantPast]];
}

-(void)enterForeground:(NSNotification *)notification{
    //关闭定时器
    [timer setFireDate:[NSDate distantFuture]];
}


- (void) pollingSyncUserInfo {
    timer = [NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(syncUserInfo) userInfo:nil repeats:YES];
    [timer fire];
}

-(void)syncUserInfo{
    NSArray *userInfo = [[LLAInstantMessageStorageUtil shareInstance] getOldestUserInfo];
    
    if (userInfo.count >0){
        NSMutableString *userIDString = [[NSMutableString alloc] init];
        for (int i=0;i<userInfo.count;i++){
            LLAUser *curUser = [userInfo objectAtIndex:i];
            [userIDString appendString:curUser.userIdString];
            if (i!=userInfo.count-1){
                [userIDString appendString:@","];
            }
        }
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
        [paramDic setValue:userIDString forKey:@"ids"];
        //[paramDic setValue:[NSNumber numberWithInteger:userInfo.count] forKey:@"length"];
        
        [LLAHttpUtil httpPostWithUrl:@"/play/createPlay" param:paramDic responseBlock:^(id responseObject) {
            
            for (NSDictionary *dic in responseObject){
                [LLAUser setIsSimpleUserModel:YES];
                LLAUser *user = [LLAUser parseJsonWidthDic:dic];
                
                [[LLAInstantMessageStorageUtil shareInstance] updateUserInfoWithUser:user];
            }
            
        } exception:NULL failed:NULL];
    }
}


@end
