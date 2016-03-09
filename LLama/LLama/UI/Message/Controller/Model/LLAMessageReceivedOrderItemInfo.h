//
//  LLAMessageReceivedOderItemInfo.h
//  LLama
//
//  Created by Live on 16/2/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"

#import "LLAUser.h"

@interface LLAMessageReceivedOrderItemInfo : MTLModel<MTLJSONSerializing>

@property(nonatomic , copy) NSString *itemIdString;

@property(nonatomic , strong) LLAUser *authorUser;

@property(nonatomic , assign) long long editTimeInterval;

@property(nonatomic , copy) NSString *editTimeString;

@property(nonatomic , copy) NSString *infoImageURL;

@property(nonatomic , copy) NSString *manageContent;

@property(nonatomic , copy) NSString *scriptIdString;


+ (instancetype) parseJsonWithDic:(NSDictionary *)data;

@end
