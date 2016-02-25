//
//  LLAShareInfo.h
//  LLama
//
//  Created by Live on 16/2/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle.h"
@interface LLAShareInfo : MTLModel<MTLJSONSerializing>

@property(nonatomic , copy) NSString *shareTitle;

@property(nonatomic , copy) NSString *shareContent;

@property(nonatomic , copy) NSString *shareImageURLString;

@property(nonatomic , copy) NSString *shareWebURLString;

+ (instancetype) parseJsonWithDic:(NSDictionary *) data;

@end
