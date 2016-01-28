//
//  LLAAccountSecuritySectionOne.m
//  LLama
//
//  Created by tommin on 16/1/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAAccountSecuritySectionOne.h"

@implementation LLAAccountSecuritySectionOne

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        self.title = dict[@"title"];
    }
    return self;
}

+ (instancetype)accountSecuritySectionOneWithDict:(NSDictionary *)dict
{
    // 这里要用self
    return [[self alloc] initWithDict:dict];
}

@end
