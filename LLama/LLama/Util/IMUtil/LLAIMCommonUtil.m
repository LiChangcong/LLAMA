//
//  LLAIMCommonUtil.m
//  LLama
//
//  Created by Live on 16/3/4.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAIMCommonUtil.h"

#import "LLAUser.h"
#import "LLAIMConversation.h"

@implementation LLAIMCommonUtil

+ (LLAUser *) findTheOtherWithConversation:(LLAIMConversation *)conversation mainUser:(LLAUser *)mainUser {
    
    for (LLAUser *user in conversation.members) {
        if (![user isEqual:mainUser]) {
            return user;
        }
    }
    
    return nil;
}

@end
