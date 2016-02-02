//
//  LLAVideoInfo.m
//  LLama
//
//  Created by Live on 16/1/13.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAVideoInfo.h"

@implementation LLAVideoInfo

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{};
}

- (BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    LLAVideoInfo *videoInfo = (LLAVideoInfo *) object;
    if ([videoInfo.videoPlayURL isEqualToString:self.videoPlayURL]) {
        return YES;
    }else {
        return NO;
    }
    
}

@end
