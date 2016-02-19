//
//  LLAVideoCacheUtil.h
//  LLama
//
//  Created by Live on 16/1/20.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVPlayerItem;
@class LLAVideoInfo;

@interface LLAVideoCacheUtil : NSObject

+ (instancetype) shareInstance;

- (void) cacheVideoWithURL:(NSURL *) videoURL;

- (NSURL *) cacheURLForVideoURL:(NSURL *) videoURL;

- (NSInteger) videoCacheSize;

- (void) clearCache;

@end
