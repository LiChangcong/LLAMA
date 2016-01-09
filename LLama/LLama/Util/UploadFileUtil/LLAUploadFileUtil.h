//
//  LLAUploadFileUtil.h
//  LLama
//
//  Created by Live on 16/1/9.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLAQiNiuUploadFileManager.h"

@interface LLAUploadFileUtil : NSObject

+ (void) llaUploadWithFileType:(LLAUploadFileType) fileType
                          file:(id) fileForUpload
                    tokenBlock:(LLAUploadTokenBlock) tokenBlock
                uploadProgress:(LLAUploadProgressBlock) progress
                      complete:(LLAUploadCompleteBlock) complete;

+ (NSString *) llaUploadResponseCodeToDescription:(LLAUploadFileResponseCode) code;

@end
