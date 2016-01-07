//
//  LLAHttpUtil.m
//  LLama
//
//  Created by WanDa on 16/1/5.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAHttpUtil.h"
#import "LLAHttpResponseData.h"
#import "LLAThirdSDKDelegate.h"

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
    
    NSURLSessionDataTask *dataTask = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (bodyBlock) {
            bodyBlock(formData);
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progressBlock) {
            progressBlock(0,uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        LLAHttpResponseData *data = [LLAHttpResponseData parseJsonWithDic:responseObject];
        if (data && data.responseCode == 0) {
            if (responseBlock)
                responseBlock(data.responseData);
        }else {
            if (exceptionBlock)
                exceptionBlock(data.responseCode,data.responseMessage);
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

    [manager.requestSerializer setValue:[LLAThirdSDKDelegate shareInstance].tempToken forHTTPHeaderField:@"auth"];
        return manager;
}


@end
