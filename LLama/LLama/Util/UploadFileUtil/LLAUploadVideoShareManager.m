//
//  LLAUploadVideoShareManager.m
//  LLama
//
//  Created by Live on 16/1/31.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUploadVideoShareManager.h"

#import "LLAUploadFileUtil.h"
#import "LLAHttpUtil.h"
#import "LLAUser.h"

@implementation LLAUploadVideoShareManager

@synthesize uploadScriptVideoObserver;
@synthesize uploadUserVideoObserver;

+ (instancetype) shareManager {
    
    static LLAUploadVideoShareManager *shareManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareManager = [[[self class] alloc] init];
    });
    
    return shareManager;
    
}

- (void) uploadScriptVideoWithScriptId:(NSString *) scriptId image:(UIImage *) thumbImage videoURL:(NSURL *) videoFileURL {
    
    //first upload image , then upload video
    
    if (uploadScriptVideoObserver && [uploadScriptVideoObserver respondsToSelector:@selector(uploadVideoDidStart)]) {
        [uploadScriptVideoObserver uploadVideoDidStart];
    }
    
    [LLAUploadFileUtil llaUploadWithFileType:LLAUploadFileType_Image file:thumbImage tokenBlock:NULL uploadProgress:NULL complete:^(LLAUploadFileResponseCode responseCode, NSString *uploadToken, NSString *uploadImageKey, NSDictionary *respDic) {
        
        if (responseCode >=0) {
            
            //upload video
            [LLAUploadFileUtil llaUploadWithFileType:LLAUploadFileType_Video file:videoFileURL tokenBlock:NULL uploadProgress:^(NSString *uploadVideoKey, float percent) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (uploadScriptVideoObserver && [uploadScriptVideoObserver respondsToSelector:@selector(uploadVideoProgressChange:)]) {
                        [uploadScriptVideoObserver uploadVideoProgressChange:percent];
                    }
                });
                
                
            } complete:^(LLAUploadFileResponseCode responseCode, NSString *uploadToken, NSString *uploadVideoKey, NSDictionary *respDic) {
                
                if (responseCode >= 0) {
                    //request url
                    
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    [params setValue:scriptId forKey:@"playId"];
                    [params setValue:uploadVideoKey forKey:@"key"];
                    [params setValue:uploadImageKey forKey:@"videoThumb"];
                    
                    [LLAHttpUtil httpPostWithUrl:@"/play/uploadVideo" param:params responseBlock:^(id responseObject) {
                        if (uploadScriptVideoObserver && [uploadScriptVideoObserver respondsToSelector:@selector(uploadVideodidSuccess)]) {
                            [uploadScriptVideoObserver uploadVideodidSuccess];
                        }
                    } exception:^(NSInteger code, NSString *errorMessage) {
                        if (uploadScriptVideoObserver && [uploadScriptVideoObserver respondsToSelector:@selector(uploadVideoDidFailed)]) {
                            [uploadScriptVideoObserver uploadVideoDidFailed];
                        }
                    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
                        if (uploadScriptVideoObserver && [uploadScriptVideoObserver respondsToSelector:@selector(uploadVideoDidFailed)]) {
                            [uploadScriptVideoObserver uploadVideoDidFailed];
                        }
                    }];
                
                }else {
                    if (uploadScriptVideoObserver && [uploadScriptVideoObserver respondsToSelector:@selector(uploadVideoDidFailed)]) {
                        [uploadScriptVideoObserver uploadVideoDidFailed];
                    }
                }
                
            }];
            
        
        }else {
            if (uploadScriptVideoObserver && [uploadScriptVideoObserver respondsToSelector:@selector(uploadVideoDidFailed)]) {
                [uploadScriptVideoObserver uploadVideoDidFailed];
            }
        }
        
    }];
    
}

- (void) uploadUserVideoWithImage:(UIImage *) thumbImage videoURL:(NSURL *) videoFileURL {
    
    //first upload image , then upload video
    
    if (uploadUserVideoObserver && [uploadUserVideoObserver respondsToSelector:@selector(uploadVideoDidStart)]) {
        [uploadUserVideoObserver uploadVideoDidStart];
    }
    
    [LLAUploadFileUtil llaUploadWithFileType:LLAUploadFileType_Image file:thumbImage tokenBlock:NULL uploadProgress:NULL complete:^(LLAUploadFileResponseCode responseCode, NSString *uploadToken, NSString *uploadImageKey, NSDictionary *respDic) {
        
        if (responseCode >=0) {
            
            //upload video
            [LLAUploadFileUtil llaUploadWithFileType:LLAUploadFileType_Video file:videoFileURL tokenBlock:NULL uploadProgress:^(NSString *uploadVideoKey, float percent) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (uploadUserVideoObserver && [uploadUserVideoObserver respondsToSelector:@selector(uploadVideoProgressChange:)]) {
                        [uploadUserVideoObserver uploadVideoProgressChange:percent];
                    }

                });
                
            } complete:^(LLAUploadFileResponseCode responseCode, NSString *uploadToken, NSString *uploadVideoKey, NSDictionary *respDic) {
                
                if (responseCode >= 0) {
                    //request url
                    
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    [params setValue:uploadVideoKey forKey:@"myVideoKey"];
                    [params setValue:uploadImageKey forKey:@"videoThumb"];
                    
                    [LLAHttpUtil httpPostWithUrl:@"/user/updateUserInfo" param:params responseBlock:^(id responseObject) {
                        if (uploadUserVideoObserver && [uploadUserVideoObserver respondsToSelector:@selector(uploadVideodidSuccess)]) {
                            [uploadUserVideoObserver uploadVideodidSuccess];
                        }
                        
                        //
                        LLAUser *me = [LLAUser parseJsonWidthDic:[responseObject valueForKey:@"user"]];
                        me.isLogin = YES;
                        [LLAUser updateUserInfo:me];
                        
                    } exception:^(NSInteger code, NSString *errorMessage) {
                        if (uploadUserVideoObserver && [uploadUserVideoObserver respondsToSelector:@selector(uploadVideoDidFailed)]) {
                            [uploadUserVideoObserver uploadVideoDidFailed];
                        }
                    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
                        if (uploadUserVideoObserver && [uploadUserVideoObserver respondsToSelector:@selector(uploadVideoDidFailed)]) {
                            [uploadUserVideoObserver uploadVideoDidFailed];
                        }
                    }];
                    
                    
                }else {
                    if (uploadUserVideoObserver && [uploadUserVideoObserver respondsToSelector:@selector(uploadVideoDidFailed)]) {
                        [uploadUserVideoObserver uploadVideoDidFailed];
                    }
                }
                
            }];
            
            
        }else {
            if (uploadUserVideoObserver && [uploadUserVideoObserver respondsToSelector:@selector(uploadVideoDidFailed)]) {
                [uploadUserVideoObserver uploadVideoDidFailed];
            }
        }
        
    }];
    
    
}



@end
