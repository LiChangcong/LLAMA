//
//  LLAMessageReceivedPraiseItemInfo.h
//  LLama
//
//  Created by Live on 16/2/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"

#import "LLAUser.h"

@interface LLAMessageReceivedPraiseItemInfo : MTLModel

@property(nonatomic , strong) LLAUser *authorUser;

@property(nonatomic , assign) long long editTimeInterval;

@property(nonatomic , copy) NSString *editTimeString;

@property(nonatomic , copy) NSString *infoImageURL;

@property(nonatomic , copy) NSString *manageContent;

@end
