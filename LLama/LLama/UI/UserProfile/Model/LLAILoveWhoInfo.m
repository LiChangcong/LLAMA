//
//  LLAILoveWhoInfo.m
//  LLama
//
//  Created by tommin on 16/2/1.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAILoveWhoInfo.h"

@implementation LLAILoveWhoInfo

+ (LLAILoveWhoInfo *) parseJsonWithDic:(NSDictionary *)data {
    return [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:data error:nil];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"currentPage":@"pageNumber",
             @"pageSize":@"size",
             @"dataList":@"content",
             @"isFirstPage":@"first",
             @"isLastPage":@"last",
             @"totalPageNumbers":@"totalPages",
             @"totalDataNumbers":@"totalElements"};
}

//+ (NSValueTransformer *)dataListJSONTransformer {
//    return [MTLJSONAdapter arrayTransformerWithModelClass:[LLAWhoLoveMeUser class]];
//}

+ (NSValueTransformer *)dataListJSONTransformer {
    [LLAUser setIsSimpleUserModel:YES];
    return [MTLJSONAdapter arrayTransformerWithModelClass:[LLAUser class]];
}

- (instancetype) initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self) {
        if (!self.dataList){
            self.dataList = [NSMutableArray array];
        }
    }
    return self;
}

@end
