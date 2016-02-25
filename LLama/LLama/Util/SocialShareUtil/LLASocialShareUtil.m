//
//  LLASocialShareUtil.m
//  LLama
//
//  Created by Live on 16/2/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLASocialShareUtil.h"
#import "LLAShareRequestInfo.h"
#import "LLASocialShareView.h"
#import "LLASocialSharePlatformItem.h"
#import "LLAHttpUtil.h"
#import "LLAShareInfo.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"


#import <WXApi.h>
#import <TencentOpenAPI/QQApiInterface.h>

static NSString * const shareFailedDesc = @"分享失败";
static NSString * const shareSuccessDesc = @"分享成功";
static NSString * const shareCancelDesc = @"分享取消";

@implementation LLASocialShareUtil

+ (void) shareWithRequestInfo:(LLAShareRequestInfo *)requestInfo
                        title:(NSString *) title
                reportHandler:(LLASocialReportHandler)reportHandler
           stateChangeHandler:(LLASocialShareStateChangeHandler)stateChangeHandler {
    
    if (!requestInfo || requestInfo.urlString.length < 1) {
        if (stateChangeHandler){
            stateChangeHandler(LLASocialShareResponseState_Failed,shareFailedDesc,nil);
        }
    }
    
    NSArray *platforms = [self defaultPlatforms];
    //show
    LLASocialShareView *shareView = [[LLASocialShareView alloc] initWithPlatforms:platforms title:title hasReport:reportHandler != nil];
    shareView.completeHandler = ^(NSInteger index) {
    
        if (stateChangeHandler) {
            stateChangeHandler(LLASocialShareResponseState_Begin,nil,nil);
        }
        //request share information
        LLASocialSharePlatformItem *item = [platforms objectAtIndex:index];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params addEntriesFromDictionary:requestInfo.paramsDic];
        if (item.platform == LLASocialSharePlatform_SinaWeiBo) {
            [params setValue:@"WB" forKey:@"type"];
        }else {
            [params setValue:@"TX" forKey:@"type"];
        }
        
        __weak typeof(self) weakSelf = self;
        
        [LLAHttpUtil httpPostWithUrl:requestInfo.urlString param:params responseBlock:^(id responseObject) {
            
            LLAShareInfo *shareInfo = [LLAShareInfo parseJsonWithDic:responseObject];
            
            //share
            [weakSelf shareWithShareInfo:shareInfo platform:item.platform completion:stateChangeHandler];
        
        } exception:^(NSInteger code, NSString *errorMessage) {
            if (stateChangeHandler){
                stateChangeHandler(LLASocialShareResponseState_Failed,errorMessage,nil);
            }
        } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
            if (stateChangeHandler){
                stateChangeHandler(LLASocialShareResponseState_Failed,error.localizedDescription,error);
            }

        }];
        
    };
    shareView.reportHandler = ^{
        if (reportHandler)
            reportHandler();
    };
    
    [shareView show];
}

+ (NSArray<LLASocialSharePlatformItem *> *) defaultPlatforms {
    
    NSMutableArray<LLASocialSharePlatformItem*> *platforms = [NSMutableArray array];
    
    if ([WXApi isWXAppInstalled]) {
        [platforms addObject:[LLASocialSharePlatformItem weChatSessionItem]];
        [platforms addObject:[LLASocialSharePlatformItem weChatTimeLineItem]];
    }
    
    [platforms addObject:[LLASocialSharePlatformItem sinaWeiboItem]];
    
    if ([QQApiInterface isQQInstalled]) {
        [platforms addObject:[LLASocialSharePlatformItem qqFriendItem]];
        [platforms addObject:[LLASocialSharePlatformItem qqZoneItem]];
    }
    
    
    return platforms;
}

+ (void) shareWithShareInfo:(LLAShareInfo *) shareInfo platform:(LLASocialSharePlatform) platform completion:(LLASocialShareStateChangeHandler) completion{
    if (!shareInfo) {
        completion(LLASocialShareResponseState_Failed,@"错误的分享数据",nil);
    }
    
    //
    [UMSocialData defaultData].urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:shareInfo.shareImageURLString];
    
    NSString *umSharePlatform = nil;
    
    if (platform == LLASocialSharePlatform_WechatSession) {
        
        umSharePlatform = UMShareToWechatSession;
        
        [[UMSocialData defaultData].extConfig.wechatSessionData setTitle:shareInfo.shareTitle];
        [[UMSocialData defaultData].extConfig.wechatSessionData setUrl:shareInfo.shareWebURLString];
        
    }else if (platform == LLASocialSharePlatform_WechatTimeLine) {
        
        umSharePlatform = UMShareToWechatTimeline;
        
        [[UMSocialData defaultData].extConfig.wechatTimelineData setTitle:shareInfo.shareTitle];
        [[UMSocialData defaultData].extConfig.wechatTimelineData setUrl:shareInfo.shareWebURLString];
        
    }else if (platform == LLASocialSharePlatform_QQFriend) {
        
        umSharePlatform = UMShareToQQ;
        
        [[UMSocialData defaultData].extConfig.qqData setTitle:shareInfo.shareTitle];
        [[UMSocialData defaultData].extConfig.qqData setUrl:shareInfo.shareWebURLString];

        
    }else if (platform == LLASocialSharePlatform_QQZone) {
        
        umSharePlatform = UMShareToQzone;
        
        [[UMSocialData defaultData].extConfig.qzoneData setTitle:shareInfo.shareTitle];
        [[UMSocialData defaultData].extConfig.qzoneData setUrl:shareInfo.shareWebURLString];
        
    }else {
        //sina weibo
        umSharePlatform = UMShareToSina;
    }
    
    //share
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[umSharePlatform] content:shareInfo.shareContent image:nil location:nil urlResource:[UMSocialData defaultData].urlResource presentedController:nil completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            if (completion){
                completion(LLASocialShareResponseState_Success,shareSuccessDesc,nil);
            }
        }else if(response.responseCode == UMSResponseCodeCancel) {
            if (completion){
                completion(LLASocialShareResponseState_Cancel,shareCancelDesc,response.error);
            }
        }else {
            if (completion){
                completion(LLASocialShareResponseState_Failed,shareFailedDesc,response.error);
            }
        }
    }];
}

@end
