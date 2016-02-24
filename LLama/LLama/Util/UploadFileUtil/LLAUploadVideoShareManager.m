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

#import "LLAUploadVideoTaskInfo.h"
#import "LLAUploadVideoObserverInfo.h"

@interface LLAUploadVideoShareManager()
{
    //operation array
    NSMutableArray <LLAUploadVideoTaskInfo *> *scriptVideoTaskArray;
    NSMutableArray <LLAUploadVideoTaskInfo *>*userVideoTaskArray;
    
    //observers array
    NSMutableArray<LLAUploadVideoObserverInfo *> *scriptVideoObserverArray;
    NSMutableArray<LLAUploadVideoObserverInfo *> *userVideoObserverArray;
    
    //
    BOOL isScriptVideoUploading;
    BOOL isUserVideoUploading;
    
}

@end

@implementation LLAUploadVideoShareManager

+ (instancetype) shareManager {
    
    static LLAUploadVideoShareManager *shareManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareManager = [[[self class] alloc] init];
    });
    
    return shareManager;
    
}

- (instancetype) init {
    
    self = [super init];
    if (self) {
        
        scriptVideoTaskArray = [NSMutableArray array];
        userVideoTaskArray = [NSMutableArray array];
        //
        scriptVideoObserverArray = [NSMutableArray array];
        userVideoObserverArray = [NSMutableArray array];
        
    }
    return self;
    
}

#pragma mark -

- (void) uploadScriptVideoWithScriptId:(NSString *) scriptId image:(UIImage *) thumbImage videoURL:(NSURL *) videoFileURL {
    
    //first upload image , then upload video
    
    [self dispatchUploadFailedWithType:videoUploadType_ScriptVideo];
    
    __weak typeof(self) weakSelf = self;
    
    isScriptVideoUploading = YES;

    [LLAUploadFileUtil llaUploadWithFileType:LLAUploadFileType_Image file:thumbImage tokenBlock:NULL uploadProgress:NULL complete:^(LLAUploadFileResponseCode responseCode, NSString *uploadToken, NSString *uploadImageKey, NSDictionary *respDic) {
        
        if (responseCode >=0) {
            
            //upload video
            [LLAUploadFileUtil llaUploadWithFileType:LLAUploadFileType_Video file:videoFileURL tokenBlock:NULL uploadProgress:^(NSString *uploadVideoKey, float percent) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf dispatchUploadProgressChange:percent type:videoUploadType_ScriptVideo];
                });
                
                
            } complete:^(LLAUploadFileResponseCode responseCode, NSString *uploadToken, NSString *uploadVideoKey, NSDictionary *respDic) {
                
                if (responseCode >= 0) {
                    //request url
                    
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    [params setValue:scriptId forKey:@"playId"];
                    [params setValue:uploadVideoKey forKey:@"key"];
                    [params setValue:uploadImageKey forKey:@"videoThumb"];
                    
                    [LLAHttpUtil httpPostWithUrl:@"/play/uploadVideo" param:params responseBlock:^(id responseObject) {
                    
                        [weakSelf dispatchUploadSuccessWithType:videoUploadType_ScriptVideo];
                        isScriptVideoUploading = NO;
                        [weakSelf doneScriptUploadTask];
                    
                    } exception:^(NSInteger code, NSString *errorMessage) {
                    
                        [weakSelf dispatchUploadFailedWithType:videoUploadType_ScriptVideo];
                        isScriptVideoUploading = NO;
                        [weakSelf doneScriptUploadTask];
                        
                    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
                        
                        [weakSelf dispatchUploadFailedWithType:videoUploadType_ScriptVideo];                    }];
                    isScriptVideoUploading = NO;
                    [weakSelf doneScriptUploadTask];
                
                }else {
                    
                    [weakSelf dispatchUploadFailedWithType:videoUploadType_ScriptVideo];
                    isScriptVideoUploading = NO;
                    [weakSelf doneScriptUploadTask];
                    
                }
                
            }];
            
        
        }else {
            [weakSelf dispatchUploadFailedWithType:videoUploadType_ScriptVideo];
            
            isScriptVideoUploading = NO;
            [weakSelf doneScriptUploadTask];
        }
        
    }];
    
}

- (void) uploadUserVideoWithImage:(UIImage *) thumbImage videoURL:(NSURL *) videoFileURL {
    
    //first upload image , then upload video
    
    [self dispatchStartUploadWithType:videoUploadType_UserVideo];
    
    __weak typeof(self) weakSelf = self;
    isUserVideoUploading = YES;
    
    [LLAUploadFileUtil llaUploadWithFileType:LLAUploadFileType_Image file:thumbImage tokenBlock:NULL uploadProgress:NULL complete:^(LLAUploadFileResponseCode responseCode, NSString *uploadToken, NSString *uploadImageKey, NSDictionary *respDic) {
        
        if (responseCode >=0) {
            
            //upload video
            [LLAUploadFileUtil llaUploadWithFileType:LLAUploadFileType_Video file:videoFileURL tokenBlock:NULL uploadProgress:^(NSString *uploadVideoKey, float percent) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf dispatchUploadProgressChange:percent type:videoUploadType_UserVideo];
                });
                
            } complete:^(LLAUploadFileResponseCode responseCode, NSString *uploadToken, NSString *uploadVideoKey, NSDictionary *respDic) {
                
                if (responseCode >= 0) {
                    //request url
                    
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    [params setValue:uploadVideoKey forKey:@"myVideoKey"];
                    [params setValue:uploadImageKey forKey:@"videoThumb"];
                    
                    [LLAHttpUtil httpPostWithUrl:@"/user/updateUserInfo" param:params responseBlock:^(id responseObject) {
                        
                        [weakSelf dispatchUploadSuccessWithType:videoUploadType_UserVideo];
                        
                        isUserVideoUploading = NO;
                        [weakSelf doneUserUploadTask];
                        
                        //
                        LLAUser *me = [LLAUser parseJsonWidthDic:[responseObject valueForKey:@"user"]];
                        me.isLogin = YES;
                        [LLAUser updateUserInfo:me];
                        
                    } exception:^(NSInteger code, NSString *errorMessage) {
                        [weakSelf dispatchUploadFailedWithType:videoUploadType_UserVideo];
                        isUserVideoUploading = NO;
                        [weakSelf doneUserUploadTask];
                        
                    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
                        
                        [weakSelf dispatchUploadFailedWithType:videoUploadType_UserVideo];                    }];
                    isUserVideoUploading = NO;
                    [weakSelf doneUserUploadTask];
                    
                }else {
                    [weakSelf dispatchUploadFailedWithType:videoUploadType_UserVideo];
                    isUserVideoUploading = NO;
                    [weakSelf doneUserUploadTask];
                }
                
            }];
            
            
        }else {
            
            [weakSelf dispatchUploadFailedWithType:videoUploadType_UserVideo];
            isUserVideoUploading = NO;
            [weakSelf doneUserUploadTask];
            
        }
        
    }];
    
    
}

#pragma mark - add task

- (void) addScriptVideoTaskWithScriptId:(NSString *) scriptId image:(UIImage *) thumbImage videoURL:(NSURL *) videoFileURL {
    //
    LLAUploadVideoTaskInfo *taskInfo = [LLAUploadVideoTaskInfo new];
    taskInfo.manaIdString  = scriptId;
    taskInfo.coverImage = thumbImage;
    taskInfo.videoPathURL = videoFileURL;
    
    [scriptVideoTaskArray addObject:taskInfo];
    
    //triger task
    
    [self doScriptUploadTask];

}

- (void) addUserVideoTashWithThumbImage:(UIImage *) thumbImage videoFileURL:(NSURL *) videoFileURL {
    
    LLAUploadVideoTaskInfo *taskInfo = [LLAUploadVideoTaskInfo new];
    taskInfo.manaIdString  = nil;
    taskInfo.coverImage = thumbImage;
    taskInfo.videoPathURL = videoFileURL;
    
    [userVideoTaskArray addObject:taskInfo];
    
    //triger task
    [self doUserUploadTask];
}

//
- (void) doScriptUploadTask {
    
    if (isScriptVideoUploading || scriptVideoTaskArray.count < 1) {
        return;
    }else {
        
        LLAUploadVideoTaskInfo *taskInfo = [scriptVideoTaskArray firstObject];
        
        [self uploadScriptVideoWithScriptId:taskInfo.manaIdString image:taskInfo.coverImage videoURL:taskInfo.videoPathURL];
        
    }
}

- (void) doUserUploadTask {
    if (isUserVideoUploading || userVideoTaskArray.count < 1) {
        return;
    }else {
        //
        LLAUploadVideoTaskInfo *taskInfo = [userVideoTaskArray firstObject];
        
        [self uploadUserVideoWithImage:taskInfo.coverImage videoURL:taskInfo.videoPathURL];
    }
}

/**
 *fail or success
 **/

- (void) doneScriptUploadTask {
    
    isScriptVideoUploading = NO;
    
    if (scriptVideoTaskArray.count > 0) {
        //
        
        LLAUploadVideoTaskInfo *task = [scriptVideoTaskArray firstObject];
        if (task.videoPathURL)
            [[NSFileManager defaultManager] removeItemAtURL:task.videoPathURL error:nil];
        
        [scriptVideoTaskArray removeObjectAtIndex:0];
        
    }
    
    [self doScriptUploadTask];
}

- (void) doneUserUploadTask {
    
    isUserVideoUploading = NO;
    
    if (userVideoTaskArray.count > 0) {
        
        LLAUploadVideoTaskInfo *task = [userVideoTaskArray firstObject];
        if (task.videoPathURL)
            [[NSFileManager defaultManager] removeItemAtURL:task.videoPathURL error:nil];
        
        [userVideoTaskArray removeObjectAtIndex:0];
    }
    
    [self doUserUploadTask];
    
}

#pragma mark - add , remover observer

//script Video observer

- (void) addScriptVideoUploadObserver:(id<LLAUploadVideoObserverProtocol>) observer {
    
    if (observer) {
    
        LLAUploadVideoObserverInfo * observerInfo = [LLAUploadVideoObserverInfo new];
        observerInfo.observer = observer;
        
        [scriptVideoObserverArray addObject:observerInfo];
    }
    
}

- (void) removeScriptVideoUploadObserver:(id<LLAUploadVideoObserverProtocol> ) observer {
    
    for (LLAUploadVideoObserverInfo *observerInfo in scriptVideoObserverArray) {
        if (observerInfo.observer == observer) {
            [scriptVideoObserverArray removeObject:observerInfo];
            break;
        }
    }
}

//user Video Observer

- (void) addUserVideoUploadObserver:(id<LLAUploadVideoObserverProtocol> ) observer {
    if (observer) {
        
        LLAUploadVideoObserverInfo * observerInfo = [LLAUploadVideoObserverInfo new];
        observerInfo.observer = observer;
        
        [userVideoObserverArray addObject:observerInfo];
    }

}
- (void) removeUserVideoUploadObserver:(id<LLAUploadVideoObserverProtocol> ) observer {
    
    for (LLAUploadVideoObserverInfo *observerInfo in userVideoObserverArray) {
        if (observerInfo.observer == observer) {
            [userVideoObserverArray removeObject:observerInfo];
            break;
        }
    }

}

#pragma mark - dispatch upload info

- (void) dispatchStartUploadWithType:(videoUploadType) type {
    
    NSArray *observerArray = [self observerArrayWithType:type];
    
    for (LLAUploadVideoObserverInfo *observerInfo in observerArray) {
        if (observerInfo.observer && [observerInfo.observer respondsToSelector:@selector(uploadVideoDidStart)]) {
            [observerInfo.observer uploadVideoDidStart];
        }
    }
    
}

- (void) dispatchUploadProgressChange:(CGFloat) progress type:(videoUploadType) type {
    
    NSArray *observerArray = [self observerArrayWithType:type];
    
    for (LLAUploadVideoObserverInfo *observerInfo in observerArray) {
        if (observerInfo.observer && [observerInfo.observer respondsToSelector:@selector(uploadVideoProgressChange:)]) {
            [observerInfo.observer uploadVideoProgressChange:progress];
        }
    }

    
}

- (void) dispatchUploadSuccessWithType:(videoUploadType) type {
    
    NSArray *observerArray = [self observerArrayWithType:type];
    
    for (LLAUploadVideoObserverInfo *observerInfo in observerArray) {
        if (observerInfo.observer && [observerInfo.observer respondsToSelector:@selector(uploadVideodidSuccess)]) {
            [observerInfo.observer uploadVideodidSuccess];
        }
    }

    
}

- (void) dispatchUploadFailedWithType:(videoUploadType) type {
    
    NSArray *observerArray = [self observerArrayWithType:type];
    
    for (LLAUploadVideoObserverInfo *observerInfo in observerArray) {
        if (observerInfo.observer && [observerInfo.observer respondsToSelector:@selector(uploadVideoDidFailed)]) {
            [observerInfo.observer uploadVideoDidFailed];
        }
    }

    
}

- (NSArray *) observerArrayWithType:(videoUploadType) type {
    if (type == videoUploadType_ScriptVideo) {
        return scriptVideoObserverArray;
    }else {
        return userVideoObserverArray;
    }
}

@end
