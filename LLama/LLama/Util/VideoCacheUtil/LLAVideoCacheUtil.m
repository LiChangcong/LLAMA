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

@end
