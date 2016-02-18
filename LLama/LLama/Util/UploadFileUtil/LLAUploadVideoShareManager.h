//
//  LLAUploadVideoShareManager.h
//  LLama
//
//  Created by Live on 16/1/31.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LLAUploadVideoObserverProtocol.h"

typedef NS_ENUM(NSInteger , videoUploadType) {
    videoUploadType_ScriptVideo = 0,
    videoUploadType_UserVideo = 1,
};

@interface LLAUploadVideoShareManager : NSObject

+ (instancetype) shareManager;

- (void) addScriptVideoTaskWithScriptId:(NSString *) scriptId image:(UIImage *) thumbImage videoURL:(NSURL *) videoFileURL;

- (void) addUserVideoTashWithThumbImage:(UIImage *) thumbImage videoFileURL:(NSURL *) videoFileURL;

/**
 *observer
 *
 **/

//script Video observer

- (void) addScriptVideoUploadObserver:(id<LLAUploadVideoObserverProtocol>) observer;

- (void) removeScriptVideoUploadObserver:(id<LLAUploadVideoObserverProtocol> ) observer;

//user Video Observer

- (void) addUserVideoUploadObserver:(id<LLAUploadVideoObserverProtocol> ) observer;
- (void) removeUserVideoUploadObserver:(id<LLAUploadVideoObserverProtocol> ) observer;

@end
