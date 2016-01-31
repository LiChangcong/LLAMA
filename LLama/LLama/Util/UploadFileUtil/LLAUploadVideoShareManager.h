//
//  LLAUploadVideoShareManager.h
//  LLama
//
//  Created by Live on 16/1/31.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LLAUploadVideoObserverProtocol.h"

@interface LLAUploadVideoShareManager : NSObject

+ (instancetype) shareManager;

@property(nonatomic , weak) id<LLAUploadVideoObserverProtocol> uploadScriptVideoObserver;

@property(nonatomic , weak) id<LLAUploadVideoObserverProtocol> uploadUserVideoObserver;

- (void) uploadScriptVideoWithScriptId:(NSString *) scriptId image:(UIImage *) thumbImage videoURL:(NSURL *) videoFileURL;

- (void) uploadUserVideoWithImage:(UIImage *) thumbImage videoURL:(NSURL *) videoFileURL;

@end
