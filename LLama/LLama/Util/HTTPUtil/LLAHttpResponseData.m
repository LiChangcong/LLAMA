//
//  LLAHttpResponseData.m
//  LLama
//
//  Created by WanDa on 16/1/5.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAHttpResponseData.h"

@implementation LLAHttpResponseData

+ (instancetype) parseJsonWithDic:(NSDictionary *) data {
    
    return [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:data error:nil];
}

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    
    return @{@"responseCode":@"code",
             @"responseData":@"data",
             @"responseMessage":@"desc"};
}

@end
