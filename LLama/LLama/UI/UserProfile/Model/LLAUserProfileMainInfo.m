//
//  LLAUserProfileMainInfo.m
//  LLama
//
//  Created by Live on 16/1/22.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUserProfileMainInfo.h"

@implementation LLAUserProfileMainInfo

- (instancetype) init {
    self = [super init];
    if (self) {
        self.directorVideoArray = [NSMutableArray array];
        self.actorVideoArray = [NSMutableArray array];
    }
    return self;
}

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{};
}

@end
