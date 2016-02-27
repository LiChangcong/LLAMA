//
//  LLAMessageCenterSystemMsgInfo.h
//  LLama
//
//  Created by Live on 16/2/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"

typedef NS_ENUM(NSInteger,LLASystemMessageType){
    LLASystemMessageType_BePraised = 0,
    LLASystemMessageType_BeCommented = 1,
    LLASystemMessageType_Order = 2,
};

@interface LLAMessageCenterSystemMsgInfo : MTLModel

@property(nonatomic , copy) NSString *iconImageURLString;

@property(nonatomic , copy) NSString *titleString;

@property(nonatomic , assign) NSInteger unreadNum;

@property(nonatomic , assign) LLASystemMessageType messageType;

@end
