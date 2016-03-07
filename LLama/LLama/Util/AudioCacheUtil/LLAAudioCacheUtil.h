//
//  LLAAudioCacheUtil.h
//  LLama
//
//  Created by Live on 16/3/7.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"

#define LLA_AUDIO_CACHE_DOWNLOAD_AUDIO_FINISH_NOTIFICATION @"LLA_AUDIO_CACHE_DOWNLOAD_AUDIO_FINISH_NOTIFICATION"

@interface LLAAudioCacheUtil : MTLModel

+ (instancetype) shareInstance;

- (void) cacheAudioWithURL:(NSURL *) audioURL;

- (NSURL *) cacheURLForAudioURL:(NSURL *) audioURL;

- (BOOL) isCachedForAudioURL:(NSURL *) url;

- (void) saveAmrFile:(NSString *) amrFilePath forURL:(NSURL *) url;

//

- (NSInteger) audioCacheSize;

- (void) clearCache;

//

+ (BOOL) isFilePathURLString:(NSString *) urlString;

@end
