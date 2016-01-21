//
//  LLAVideoCacheUtil.m
//  LLama
//
//  Created by Live on 16/1/20.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAVideoCacheUtil.h"
#import <AVFoundation/AVFoundation.h>

#import "LLAVideoInfo.h"

@implementation LLAVideoCacheUtil

+ (instancetype) shareInstance {
    
    static LLAVideoCacheUtil *shareInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareInstance = [[[self class] alloc] init];
    });
    
    return shareInstance;
}

- (instancetype) init {
    
    self = [super init];
    if (self) {
    
    }
    
    return self;
}

- (void) cacheVideoFromPlayerItem:(AVPlayerItem *)playerItem videoInfo:(LLAVideoInfo *)videoInfo {
    
    if (!playerItem || videoInfo.videoPlayURL.length < 1) {
        return ;
    }
    
    //first check is caching,not do it now
    
    //
    //AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]   initWithAsset:playerItem.asset presetName:AVAssetExportPresetHighestQuality];
   // AVURLAsset *urlAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:videoInfo.videoPlayURL]];
    
//    [urlAsset loadValuesAsynchronouslyForKeys:@[@"tracks"] completionHandler:^{
//        
//        AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:urlAsset presetName:AVAssetExportPresetLowQuality];
//        
//        exportSession.outputFileType = AVFileTypeMPEG4;
//        
//        
//        //cache url
//        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
//        NSString *ourDocumentPath = [documentPaths objectAtIndex:0];
//        NSFileManager *defaultManager = [NSFileManager defaultManager];
//        NSString *adVideoCachPath = [ourDocumentPath stringByAppendingPathComponent:@"adVideoCache"];
//        if (![defaultManager fileExistsAtPath:adVideoCachPath]){
//            [defaultManager createDirectoryAtPath:adVideoCachPath withIntermediateDirectories:YES attributes:nil error:nil];
//        }
//        
//        NSString *filePath = [adVideoCachPath stringByAppendingFormat:@"/%@",@"testVideo.mpeg4"];
//        if (![defaultManager fileExistsAtPath:filePath]) {
//            [defaultManager createFileAtPath:filePath contents:nil attributes:nil];
//        }
//        
//        //NSURL *cacheURL = [NSURL fileURLWithPath:filePath];
//        
//        NSURL *exportUrl = [NSURL fileURLWithPath:[ourDocumentPath stringByAppendingPathComponent:@"export.m4a"]];
//        
//        [[NSFileManager defaultManager] createFileAtPath:[exportUrl path] contents:nil attributes:nil];
//        
//        
//        exportSession.outputURL = exportUrl;
//        //
//        [exportSession exportAsynchronouslyWithCompletionHandler:^{
//            NSLog(@"exportSession.Status:%ld",exportSession.status);
//            if (exportSession.status == AVAssetExportSessionStatusFailed) {
//                NSError *error = exportSession.error;
//                NSLog(@"failed with error:%@",exportSession.error);
//            }
//        }];
//
//    }];
    
    
    
    
}

@end
