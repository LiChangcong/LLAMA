//
//  LLAShareInfo.m
//  LLama
//
//  Created by Live on 16/2/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAShareInfo.h"

@implementation LLAShareInfo

+ (instancetype) parseJsonWithDic:(NSDictionary *)data {
    return [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:data error:nil];
}

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{@"shareTitle":@"title",
             @"shareContent":@"desc",
             @"shareImageURLString":@"image",
             @"shareWebURLString":@"url",};
}

@end
