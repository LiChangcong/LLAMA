//
//  LLAPayUserPayInfo.h
//  LLama
//
//  Created by Live on 16/1/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"
#import "LLAUser.h"

@interface LLAPayUserPayInfo : MTLModel

@property(nonatomic , strong) LLAUser *payToUser;

@property(nonatomic , assign) CGFloat payMoney;

@end
