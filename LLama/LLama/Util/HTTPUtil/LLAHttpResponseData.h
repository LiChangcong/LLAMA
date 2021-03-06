//
//  LLAHttpResponseData.h
//  LLama
//
//  Created by WanDa on 16/1/5.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle.h"

@interface LLAHttpResponseData : MTLModel<MTLJSONSerializing>

@property(nonatomic , assign) NSInteger responseCode;

@property(nonatomic , strong) id responseData;

@property(nonatomic , copy) NSString *responseMessage;

+ (instancetype) parseJsonWithDic:(NSDictionary *) data;

@end
