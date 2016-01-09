//
//  LLAQiNiuUploadFileManager.h
//  LLama
//
//  Created by Live on 16/1/9.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLAUploadFileHeader.h"

@interface LLAQiNiuUploadFileManager : NSObject

+ (instancetype) shareManager;

- (void) qiNiuUploadFileWithData:(NSData *) data
                             key:(NSString *)keyString
                           token:(NSString *)uploadToken
                        progress:(LLAUploadProgressBlock) progress
                        complete:(LLAUploadCompleteBlock) complete;

@end
