//
//  LLAAccountSecuritySectionTwo.m
//  LLama
//
//  Created by tommin on 16/1/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAAccountSecuritySectionTwo.h"

@implementation LLAAccountSecuritySectionTwo

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.icon = dict[@"icon"];
        self.on = dict[@"on"];
    }
    return self;
}

+ (instancetype)accountSecuritySectionTwoWithDict:(NSDictionary *)dict
{
    // 这里要用self
    return [[self alloc] initWithDict:dict];
}

@end
