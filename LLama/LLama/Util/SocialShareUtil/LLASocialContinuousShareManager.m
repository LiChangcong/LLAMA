//
//  LLASocialContinuousManager.m
//  LLama
//
//  Created by Live on 16/2/26.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLASocialContinuousShareManager.h"
#import "LLASocialShareUtil.h"

#import "LLAShareInfo.h"
#import "LLAHttpUtil.h"

@interface LLASocialContinuousShareManager()
{
    NSMutableArray * sharePlatformsArray;
    LLAShareRequestInfo *requestInfo;

}

@property(nonatomic , copy) LLASocialShareStateChangeHandler completeHandler;

@end

@implementation LLASocialContinuousShareManager

@synthesize completeHandler;

+ (instancetype) shareManager {
    
    static LLASocialContinuousShareManager *shareManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareManager = [[[self class] alloc] init];
    });
    
    return shareManager;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        sharePlatformsArray = [NSMutableArray arrayWithCapacity:4];
    }
    return self;
}

#pragma mark -

- (void) shareToPlatforms:(NSArray *)platformsArray
               requetInfo:(LLAShareRequestInfo *)shareRequestInfo
       stateChangeHandler:(LLASocialShareStateChangeHandler)stateChangeHandler {
    
    if (platformsArray.count < 1 || !shareRequestInfo) {
        
        stateChangeHandler(LLASocialShareResponseState_Failed,@"错误的数据格式",nil);
        
    }
    
    [sharePlatformsArray removeAllObjects];
    
    requestInfo = shareRequestInfo;
    
    [sharePlatformsArray addObjectsFromArray:platformsArray];
    
    completeHandler = stateChangeHandler;

    //do share
    [self continuousShare];
}

- (void) continuousShare {
    
    LLASocialSharePlatform currentPlatform = [[sharePlatformsArray firstObject] integerValue];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:requestInfo.paramsDic];
    if (currentPlatform == LLASocialSharePlatform_SinaWeiBo) {
        [params setValue:@"WB" forKey:@"type"];
    }else {
        [params setValue:@"TX" forKey:@"type"];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [LLAHttpUtil httpPostWithUrl:requestInfo.urlString param:params responseBlock:^(id responseObject) {
        
        LLAShareInfo *shareInfo = [LLAShareInfo parseJsonWithDic:responseObject];
        
        //share
        
        [[LLASocialShareUtil shareManager] shareWithShareInfo:shareInfo platform:currentPlatform completion:^(LLASocialShareResponseState state, NSString *message, NSError *error) {
            if (completeHandler) {
                completeHandler(state,message,error);
            }
            
            [weakSelf doNextShare];
        }];
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        if (completeHandler){
            completeHandler(LLASocialShareResponseState_Failed,errorMessage,nil);
        }
        
        [weakSelf doNextShare];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        if (completeHandler){
            completeHandler(LLASocialShareResponseState_Failed,error.localizedDescription,error);
        }
        
        [weakSelf doNextShare];
    }];
}

- (void) doNextShare {
    //remove first
    if (sharePlatformsArray.count > 0) {
        [sharePlatformsArray removeObjectAtIndex:0];
    }
    
    //then if has other platfroms do share
    if (sharePlatformsArray.count > 0) {
        [self continuousShare];
    }else {
        requestInfo = nil;
        completeHandler = nil;
    }
    
}

@end
