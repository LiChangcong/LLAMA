//
//  LLAQiNiuUploadFileManager.m
//  LLama
//
//  Created by Live on 16/1/9.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAQiNiuUploadFileManager.h"
#import <QiniuSDK.h>

@interface LLAQiNiuUploadFileManager()
{
    QNUploadManager *qiNiuUploadManager;
}

@end

@implementation LLAQiNiuUploadFileManager

+ (instancetype) shareManager {
    
    static LLAQiNiuUploadFileManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    
    return manager;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        qiNiuUploadManager = [[QNUploadManager alloc] init];
    }
    return self;
}

- (void) qiNiuUploadFileWithData:(NSData *) data
                             key:(NSString *)keyString
                           token:(NSString *)uploadToken
                        progress:(LLAUploadProgressBlock) progress
                        complete:(LLAUploadCompleteBlock) complete {

    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithProgressHandler:^(NSString *key, float percent) {
        if (progress){
            progress(key,percent);
        }
    }];
    
    [qiNiuUploadManager putData:data key:keyString token:uploadToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
            if (complete)
                complete(info.statusCode,uploadToken,key,resp);
        
    } option:uploadOption];
    

}


@end
