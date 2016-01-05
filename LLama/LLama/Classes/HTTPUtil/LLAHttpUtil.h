//
//  LLAHttpUtil.h
//  LLama
//
//  Created by WanDa on 16/1/5.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^HttpSuccessBlock)(id responseObject);
typedef void(^HttpExceptionBlock)(NSInteger code,NSString *errorMessage);
typedef void(^HttpFailedBlock)(NSURLSessionTask *sessionTask,NSError *error);
typedef void(^HttpBodyBlock)(id <AFMultipartFormData> formData);
typedef void(^HttpProgressBlock)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

@interface LLAHttpUtil : NSObject

//没有文件的请求

+ (NSURLSessionTask *)httpPostWithUrl:(NSString *)url
                  param:(NSDictionary *)paramDict 
               progress:(HttpProgressBlock) progressBlock
          responseBlock:(HttpSuccessBlock)responseBlock
              exception:(HttpExceptionBlock) exceptionBlock
                 failed:(HttpFailedBlock) failedBlock;

//有文件的请求

+ (NSURLSessionTask *)httpPostWithUrl:(NSString *)url
                  param:(NSDictionary *)paramDict
               progress:(HttpProgressBlock) progressBlock
              bodyBlock:(void (^)(id <AFMultipartFormData> formData)) bodyBlock
          responseBlock:(HttpSuccessBlock)responseBlock
              exception:(HttpExceptionBlock)exceptionBlock
                 failed:(HttpFailedBlock)failedBlock;

@end
