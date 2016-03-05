//
//  LLAHotVideoInfo.m
//  LLama
//
//  Created by tommin on 16/2/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAHotVideoInfo.h"

@implementation LLAHotVideoInfo

+ (LLAHotVideoInfo *) parseJsonWidthDic:(NSDictionary *)data
{
//    return [MTLJSONAdapter modelsOfClass:[self class] fromJSONArray:data error:nil];
    return [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:data error:nil];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"fee":@"fee",
             @"videoid":@"id",
             @"videoThumb":@"videoThumb",
             @"zan":@"zan"
             };
}
@end
