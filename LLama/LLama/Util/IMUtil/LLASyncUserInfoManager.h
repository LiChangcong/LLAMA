//
//  LLASyncUserInfoManager.h
//  LLama
//
//  Created by Live on 16/3/4.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLASyncUserInfoManager : NSObject

+ (instancetype) shareManager;

- (void) pollingSyncUserInfo;

@end
