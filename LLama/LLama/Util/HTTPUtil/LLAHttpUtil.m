//
//  LLAHttpUtil.m
//  LLama
//
//  Created by WanDa on 16/1/5.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAHttpUtil.h"
#import "LLAHttpResponseData.h"
#import "LLASaveUserDefaultUtil.h"
#import "YYShowAlertUtil.h"

#import "LLAUser.h"
#import "LLAChangeRootControllerUtil.h"

static NSString *const httpBaseURL = @"https://api.hillama.com";

@implementation LLAHttpUtil

+ (NSURLSessionTask *)httpPostWithUrl:(NSString *)url
                                param:(NSDictionary *)paramDict
                             progress:(HttpProgressBlock) progressBlock
                        responseBlock:(HttpSuccessBlock)responseBlock
                            exception:(HttpExceptionBlock) exceptionBlock
                               failed:(HttpFailedBlock) failedBlock {
    
    return [self httpPostWithUrl:url
                           param:paramDict
                       bodyBlock:NULL
                        progress:progressBlock
                   responseBlock:responseBlock
                       exception:exceptionBlock
                          failed:failedBlock];
}

+ (NSURLSessionTask *) httpPostWithUrl:(NSString *)url
                                 param:(NSDictionary *)paramDict
                         responseBlock:(HttpSuccessBlock)responseBlock
                             exception:(HttpExceptionBlock)exceptionBlock
                                failed:(HttpFailedBlock)failedBlock {
    
    return [self httpPostWithUrl:url
                           param:paramDict
                       bodyBlock:NULL
                        progress:NULL
                   responseBlock:responseBlock
                       exception:exceptionBlock
                          failed:failedBlock];
}


//
+ (NSURLSessionTask *)httpPostWithUrl:(NSString *)url
                                      param:(NSDictionary *)params
                                  bodyBlock:(void (^)(id <AFMultipartFormData> formData)) bodyBlock
                                   progress:(HttpProgressBlock) progressBlock
                              responseBlock:(HttpSuccessBlock)responseBlock
                                  exception:(HttpExceptionBlock)exceptionBlock
                                     failed:(HttpFailedBlock)failedBlock {
    NSString *fullUrl = [self fullURLString:url];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:[self publicParams]];
    [paramsDic addEntriesFromDictionary:params];
    
    return [self sendPostWithUrl:fullUrl
                           param:paramsDic
                       bodyBlock:bodyBlock
                        progress:progressBlock
                   responseBlock:responseBlock
                       exception:exceptionBlock
                          failed:failedBlock];
}


//send
+ (NSURLSessionTask *) sendPostWithUrl:(NSString *) url
                                       param:(NSDictionary *) params
                                   bodyBlock:(void (^)(id <AFMultipartFormData> formData)) bodyBlock
                                    progress:(HttpProgressBlock) progressBlock
                               responseBlock:(HttpSuccessBlock)responseBlock
                                   exception:(HttpExceptionBlock)exceptionBlock
                                      failed:(HttpFailedBlock)failedBlock {
    
    AFHTTPSessionManager *manager = [self defaultManager];
    
    if (progressBlock) {
        
        [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            progressBlock((NSUInteger)bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
        }];
    }
    
    NSURLSessionDataTask *dataTask = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (bodyBlock) {
            bodyBlock(formData);
        }
    }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        LLAHttpResponseData *data = [LLAHttpResponseData parseJsonWithDic:responseObject];
        if (data && data.responseCode == LLAHttpResonseCode_RequestSuccess) {
            if (responseBlock)
                responseBlock(data.responseData);
        }else {
            if (data.responseCode == LLAHttpResonseCode_TokenUnavailable) {
                //show ohter login
                
                //
                [LLAUser logout];
                //change root view controller
                
                [LLAChangeRootControllerUtil changeToLoginViewController];
                
                if ([UIApplication sharedApplication].keyWindow) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"你的帐号在别处登录，请重新登录" delegate:nil cancelButtonTitle:@"重新登录" otherButtonTitles:nil];
                    [alertView show];
                }
                
                
                
                
            }else {
            //
                if (exceptionBlock)
                    exceptionBlock(data.responseCode,data.responseMessage);

            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        if (failedBlock)
            failedBlock(task,error);
    }];
    
    return dataTask;
}

//

+ (NSString *) fullURLString:(NSString *) url {
    return [httpBaseURL stringByAppendingPathComponent:url];
}

+ (NSDictionary *) publicParams {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    return dict;
}

+ (AFHTTPSessionManager *) defaultManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
//    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/octet-stream",@"text/xml",@"text/html",@"image/jpeg",@"text/plain",@"application/json",@"text/json",@"text/javascript",@"audio/amr", nil];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    [manager.requestSerializer setValue:[LLASaveUserDefaultUtil userAuthToken] forHTTPHeaderField:@"auth"];
        return manager;
}


@end
