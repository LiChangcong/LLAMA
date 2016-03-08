//
//  LLAMessageCenterSystemMsgInfo.m
//  LLama
//
//  Created by Live on 16/2/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAMessageCenterSystemMsgInfo.h"

@implementation LLAMessageCenterSystemMsgInfo

+ (instancetype) parsJsonWithDic:(NSDictionary *)data {
    return [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:data error:nil];
}

+ (NSDictionary *) JSONKeyPathsByPropertyKey {

    return @{@"messageType":@"type",
             @"titleString":@"title",
             @"iconImageURLString":@"image"};
}

+ (NSValueTransformer *)messageTypeJSONTransformer {
    
    return [MTLValueTransformer mtl_valueMappingTransformerWithDictionary:@{@"ZAN":@(LLASystemMessageType_BePraised),
                                                                            @"COMMENT":@(LLASystemMessageType_BeCommented),
                                                                            @"ORDER":@(LLASystemMessageType_Order)}];
}

@end
