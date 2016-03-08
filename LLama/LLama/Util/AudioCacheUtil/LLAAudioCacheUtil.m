//
//  LLAAudioCacheUtil.m
//  LLama
//
//  Created by Live on 16/3/7.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAAudioCacheUtil.h"

#import "AFNetworking.h"

#import <AVFoundation/AVFoundation.h>
#import <CommonCrypto/CommonDigest.h>

#import "LLAAudioCachingInfo.h"

static NSString *const audioCacheDirectory = @"audioCache";
static const NSInteger maxCacheCount = 200;

@interface LLAAudioCacheUtil()
{
    NSMutableArray <LLAAudioCachingInfo *> *cachingAudioArray;
}

@end

@implementation LLAAudioCacheUtil

+ (instancetype) shareInstance {
    
    static LLAAudioCacheUtil *shareInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareInstance = [[[self class] alloc] init];
    });
    
    return shareInstance;
}

- (instancetype) init {
    
    self = [super init];
    if (self) {
        cachingAudioArray = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - 

- (void) cacheAudioWithURL:(NSURL *) audioURL {
    if (audioURL.isFileURL || !audioURL) {
        return;
    }
    
    NSString *key = [self urlToCacheKey:audioURL];
    
    //is downloading
    
    if (![self isCachingVideoWithKey:key]) {
        
        //
        [self downloadAudio:audioURL cacheKey:key];
        
    }
}

- (void) downloadAudio:(NSURL *) audioURL cacheKey:(NSString *)key{
    
    if (!audioURL || key.length < 1) {
        return;
    }
    
    NSFileManager *fileManager =[NSFileManager defaultManager];
    
    NSString *filePath = [self filePathForKey:key];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        return;
    }
    
    [self manageAudioCache];
    
    //
    LLAAudioCachingInfo *cacheInfo = [LLAAudioCachingInfo new];
    cacheInfo.cachingKey = key;
    
    [cachingAudioArray addObject:cacheInfo];
    
    //
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:audioURL];
    
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
        
        [cachingAudioArray removeObject:cacheInfo];
        
        if (!error) {
            //success
            //            if (successBlock){
            //                successBlock(filePath.path);
            //            }
            //
            [[NSNotificationCenter defaultCenter] postNotificationName:LLA_AUDIO_CACHE_DOWNLOAD_AUDIO_FINISH_NOTIFICATION object:audioURL];
        }else {
            //failed
            //            if (failedBlock) {
            //                failedBlock(filePath.path,error);
            //            }
        }
    }];
    
    [downloadTask resume];
}


- (NSURL *) cacheURLForAudioURL:(NSURL *) audioURL{
    
    if (!audioURL) {
        return nil;
    }
    
    if (audioURL.isFileURL) {
        return audioURL;
    }
    
    NSString *key = [self urlToCacheKey:audioURL];
    
    if ([self isCachingVideoWithKey:key]) {
        return audioURL;
    }
    
    NSFileManager *fileManager =[NSFileManager defaultManager];
    
    NSString *filePath = [self filePathForKey:key];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        return [NSURL fileURLWithPath:filePath];
    }else {
        return audioURL;
    }
    
}

- (BOOL) isCachedForAudioURL:(NSURL *)url {
    
    NSURL *newURL = [self cacheURLForAudioURL:url];
    
    if (newURL.isFileURL) {
        return YES;
    }else {
        return NO;
    }
    
}

#pragma mark -

-(NSString *) filePathForKey:(NSString *)key{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *ourDocumentPath = [documentPaths objectAtIndex:0];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSString *adVideoCachPath = [ourDocumentPath stringByAppendingPathComponent:audioCacheDirectory];
    if (![defaultManager fileExistsAtPath:adVideoCachPath]){
        [defaultManager createDirectoryAtPath:adVideoCachPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [adVideoCachPath stringByAppendingFormat:@"/%@.amr",key];
}

- (BOOL) isCachingVideoWithKey:(NSString *) key {
    
    for (LLAAudioCachingInfo *info in cachingAudioArray) {
        if ([info.cachingKey isEqualToString:key]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSString *) urlToCacheKey:(NSURL *) audioURL {
    return [self md5:audioURL.absoluteString];
}

- (void) saveAmrFile:(NSString *)amrFilePath forURL:(NSURL *)url {
    
    if (amrFilePath.length < 1 || !url) {
        return;
    }
    
    NSString *key = [self urlToCacheKey:url];
    NSString *newFilePath = [self filePathForKey:key];
    
    [[NSFileManager defaultManager] moveItemAtPath:amrFilePath toPath:newFilePath error:nil];
    
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


#pragma mark - 

- (void) manageAudioCache {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDate *oldestDate = [NSDate date];
    NSString *removeFilePath = nil;
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *ourDocumentPath = [documentPaths objectAtIndex:0];
    NSString *mainPath = [ourDocumentPath stringByAppendingPathComponent:audioCacheDirectory];
    
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

- (NSInteger) audioCacheSize {
    
    __block NSUInteger size = 0;
    
    NSFileManager *fileManager =[NSFileManager defaultManager];
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *ourDocumentPath = [documentPaths objectAtIndex:0];
    
    NSString *diskCachePath = [ourDocumentPath stringByAppendingPathComponent:audioCacheDirectory];
    
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
    
    NSString *diskCachePath = [ourDocumentPath stringByAppendingPathComponent:audioCacheDirectory];
    
    [fileManager removeItemAtPath:diskCachePath error:nil];

    
}

#pragma mark - 

+ (BOOL) isFilePathURLString:(NSString *)urlString {
    if (urlString.length < 1) {
        return NO;
    }
    
    if ([urlString hasPrefix:@"http://"] || [urlString hasPrefix:@"https://"]) {
        return NO;
    }else {
        return YES;
    }
    
}

@end
