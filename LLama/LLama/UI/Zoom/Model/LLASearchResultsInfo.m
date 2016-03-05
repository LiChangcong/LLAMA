//
//  LLASearchResultsInfo.m
//  LLama
//
//  Created by tommin on 16/3/5.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLASearchResultsInfo.h"

@implementation LLASearchResultsInfo


+ (LLASearchResultsInfo *) parseJsonWithDic:(NSDictionary *) data
{
    return [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:data error:nil];

}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"searchResultUsersDataList":@"users",
             @"searchResultVideosdataList":@"plays"
             };
}

+ (NSValueTransformer *)searchResultUsersDataListJSONTransformer {
    [LLAUser setIsSimpleUserModel:NO];
    [LLAUser setIsSearchModel:YES];
    return [MTLJSONAdapter arrayTransformerWithModelClass:[LLAUser class]];
}

+ (NSValueTransformer *)searchResultVideosdataListJSONTransformer {

    return [MTLJSONAdapter arrayTransformerWithModelClass:[LLAHallVideoItemInfo class]];
}

- (instancetype) initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self) {
        if (!self.searchResultUsersDataList || !self.searchResultVideosdataList){
            self.searchResultUsersDataList = [NSMutableArray array];
            self.searchResultVideosdataList = [NSMutableArray array];
        }
    }
    return self;
}
@end
