//
//  LLAMessageReceivedOrderMainInfo.m
//  LLama
//
//  Created by Live on 16/3/8.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAMessageReceivedOrderMainInfo.h"

@implementation LLAMessageReceivedOrderMainInfo

+ (instancetype) parseJsonWithDic:(NSDictionary *)data {
    
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

+ (NSValueTransformer *)dataListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[LLAMessageReceivedOrderItemInfo class]];
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
