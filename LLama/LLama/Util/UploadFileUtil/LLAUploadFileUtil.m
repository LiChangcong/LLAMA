//
//  LLAUploadFileUtil.m
//  LLama
//
//  Created by Live on 16/1/9.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUploadFileUtil.h"
#import "LLAHttpUtil.h"

@implementation LLAUploadFileUtil

//

+ (void) llaUploadWithFileType:(LLAUploadFileType) fileType
                          file:(id) fileForUpload
                    tokenBlock:(LLAUploadTokenBlock) tokenBlock
                uploadProgress:(LLAUploadProgressBlock) progress
                      complete:(LLAUploadCompleteBlock) complete {
    
    // get uploadKey and token from server
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (fileType == LLAUploadFileType_Text) {
        [params setValue:@(0) forKey:@"type"];
    }else if (fileType == LLAUploadFileType_Image) {
        [params setValue:@(1) forKey:@"type"];
    }else if (fileType == LLAUploadFileType_Video) {
        [params setValue:@(2) forKey:@"type"];
    }
    
    [LLAHttpUtil httpPostWithUrl:@"/qiniuauth/getUploadToken" param:params responseBlock:^(id responseObject) {
        
        NSString *uploadToken = [responseObject valueForKey:@"uploadToken"];
        NSString *fileKey = [responseObject valueForKey:@"key"];
        
        if (!uploadToken || !fileKey) {
            if (complete)
                complete(LLAUploadFileResponseCode_InvalidArgument,nil,nil,nil);
        }else {
            
            NSData *uploadData = nil;
            
            if (fileType == LLAUploadFileType_Text) {
                
            }else if (fileType == LLAUploadFileType_Image) {
                
                if ([fileForUpload isKindOfClass:[NSData class]]) {
                    uploadData = [fileForUpload copy];
                }else if ([fileForUpload isKindOfClass:[UIImage class]]) {
                    uploadData = UIImageJPEGRepresentation((UIImage*)fileForUpload, 0.8);
                    if (!uploadData) {
                        uploadData = UIImagePNGRepresentation((UIImage *)fileForUpload);
                    }
                    
                    if (!uploadData) {
                        complete(LLAUploadFileResponseCode_ZeroDataSize,nil,nil,nil);
                        return ;
                    }
                }
                
            }else if (fileType == LLAUploadFileType_Video) {
                //video
                if ([fileForUpload isKindOfClass:[NSURL class]]) {
                    [[LLAQiNiuUploadFileManager shareManager] qiNiuUploadFileWithURL:fileForUpload key:fileKey token:uploadToken progress:progress complete:complete];
                }else {
                    //data
                }
            }
            
            // use qiniu to upload
            if (uploadData && fileType != LLAUploadFileType_Video)
                [[LLAQiNiuUploadFileManager shareManager] qiNiuUploadFileWithData:uploadData key:fileKey token:uploadToken progress:progress complete:complete];
        }
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        if (complete)
            complete(0,nil,nil,nil);
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        if (complete)
            complete(0,nil,nil,nil);
    }];
    
    
}

//

+ (NSString *) llaUploadResponseCodeToDescription:(LLAUploadFileResponseCode) code {
    
    NSString *responseString = @"未知错误";
    
    switch (code) {
        case LLAUploadFileResponseCode_FileError:
            responseString = @"读取文件错误";
            break;
        case LLAUploadFileResponseCode_InvalidArgument:
            responseString = @"参数错误";
            break;
        case LLAUploadFileResponseCode_NetworkError:
            responseString = @"网络错误";
            break;
        case LLAUploadFileResponseCode_InvalidToken:
            responseString = @"错误的Token";
            break;
        case LLAUploadFileResponseCode_RequestCancelled:
            responseString = @"取消上传";
            break;
        case LLAUploadFileResponseCode_ZeroDataSize:
            responseString = @"上传文件为空";
            break;
        default:
            break;
    }
    
    return responseString;
    
}

@end
