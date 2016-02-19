//
//  LLAVideoCacheUtil.m
//  LLama
//
//  Created by Live on 16/1/20.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAVideoCacheUtil.h"

#import "AFNetworking.h"

#import <AVFoundation/AVFoundation.h>
#import <CommonCrypto/CommonDigest.h>

#import "LLAVideoInfo.h"
#import "LLACachingVideoInfo.h"

static NSString *const videoCacheDirectory = @"videoCache";
static const NSInteger maxCacheCount = 50;

@interface LLAVideoCacheUtil()
{
    NSMutableArray <LLACachingVideoInfo *> *cachingVideoArray;
}
@end


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
        cachingVideoArray = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - 


- (NSURL *) cacheURLForVideoURL:(NSURL *)videoURL {
    
    if (videoURL.isFileURL) {
        return videoURL;
    }
    
    NSString *key = [self urlToCacheKey:videoURL];
    
    if ([self isCachingVideoWithKey:key]) {
        return videoURL;
    }
    
    NSFileManager *fileManager =[NSFileManager defaultManager];
    
    NSString *filePath = [self filePathForKey:key];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        return [NSURL fileURLWithPath:filePath];
    }else {
        return videoURL;
    }

}

- (void) cacheVideoWithURL:(NSURL *) videoURL {
    
    if (videoURL.isFileURL || !videoURL) {
        return;
    }
    
    NSString *key = [self urlToCacheKey:videoURL];

    //is downloading
    
    if (![self isCachingVideoWithKey:key]) {
        
        //
        [self downloadVideo:videoURL cacheKey:key];
        
    }
    
}

- (void) downloadVideo:(NSURL *) videoURL cacheKey:(NSString *)key{
    
    if (!videoURL || key.length < 1) {
        return;
    }
    
    NSFileManager *fileManager =[NSFileManager defaultManager];
    
    NSString *filePath = [self filePathForKey:key];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        return;
    }
    
    [self manageVideoCache];
    
    //
    LLACachingVideoInfo *cacheInfo = [LLACachingVideoInfo new];
    cacheInfo.key = key;
    
    [cachingVideoArray addObject:cacheInfo];
    
    //
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:videoURL];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        
        //progress
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (progressBlock) {
//                progressBlock(totalBytesWritten,totalBytesExpectedToWrite);
//            }
//        });
        
    }];
    
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        [fileManager removeItemAtPath:filePath error:nil];
        
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        
        [cachingVideoArray removeObject:cacheInfo];
        
        if (!error) {
            //success
//            if (successBlock){
//                successBlock(filePath.path);
//            }
        }else {
            //failed
//            if (failedBlock) {
//                failedBlock(filePath.path,error);
//            }
        }
    }];
    
    [downloadTask resume];


    
}

#pragma mark -

-(NSString *) filePathForKey:(NSString *)key{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *ourDocumentPath = [documentPaths objectAtIndex:0];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSString *adVideoCachPath = [ourDocumentPath stringByAppendingPathComponent:videoCacheDirectory];
    if (![defaultManager fileExistsAtPath:adVideoCachPath]){
        [defaultManager createDirectoryAtPath:adVideoCachPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [adVideoCachPath stringByAppendingFormat:@"/%@.mp4",key];
}


#pragma mark - 

- (BOOL) isCachingVideoWithKey:(NSString *) key {
    
    for (LLACachingVideoInfo *info in cachingVideoArray) {
        if ([info.key isEqualToString:key]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSString *) urlToCacheKey:(NSURL *) videoURL {
    return [self md5:videoURL.absoluteString];
}

#pragma mark MD5

-(NSString *)md5:(NSString *) oriString{
    const char* cStr = [oriString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr,(int)strlen(cStr), result);
    
    NSMutableString *md5String = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i=0;i<CC_MD5_DIGEST_LENGTH;i++){
        [md5String appendString:[NSString stringWithFormat:@"%02X",result[i]]];
    }
    return md5String;
}

#pragma mark - manaCache

- (void) manageVideoCache {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDate *oldestDate = [NSDate date];
    NSString *removeFilePath = nil;
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *ourDocumentPath = [documentPaths objectAtIndex:0];
    NSString *mainPath = [ourDocumentPath stringByAppendingPathComponent:videoCacheDirectory];
    
    NSArray *filesArray = [fileManager contentsOfDirectoryAtPath:mainPath error:nil];
    if ([filesArray count]<= maxCacheCount){
        return;
    }
    for (NSString *filename in filesArray){
        NSString *filePath = [mainPath stringByAppendingPathComponent:filename];
        NSDictionary *fileAttr = [fileManager attributesOfItemAtPath:filePath error:nil];
        NSDate *modifyDate = [fileAttr objectForKey:NSFileModificationDate];
        if (modifyDate > oldestDate){
            oldestDate = modifyDate;
            removeFilePath = filePath;
        }
    }
    //-remove
    if (removeFilePath){
        [fileManager removeItemAtPath:removeFilePath error:nil];
    }

}

#pragma mark - cache size

- (NSInteger) videoCacheSize {
    
    __block NSUInteger size = 0;
    
    NSFileManager *fileManager =[NSFileManager defaultManager];
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *ourDocumentPath = [documentPaths objectAtIndex:0];
    
    NSString *diskCachePath = [ourDocumentPath stringByAppendingPathComponent:videoCacheDirectory];
    
    NSDirectoryEnumerator *fileEnumerator = [fileManager enumeratorAtPath:diskCachePath];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
    }


    return size;
    
}

- (void) clearCache {
    
    NSFileManager *fileManager =[NSFileManager defaultManager];
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *ourDocumentPath = [documentPaths objectAtIndex:0];
    
    NSString *diskCachePath = [ourDocumentPath stringByAppendingPathComponent:videoCacheDirectory];
    
    [fileManager removeItemAtPath:diskCachePath error:nil];
    
}

@end
