//
//  LLAIMCommonUtil.h
//  LLama
//
//  Created by Live on 16/3/4.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LLAUser;
@class LLAIMConversation;


@interface LLAIMCommonUtil : NSObject

+ (LLAUser *) findTheOtherWithConversation:(LLAIMConversation *) conversation mainUser:(LLAUser *) mainUser;

+(void) pushToChatViewController:(UINavigationController *) navigationController conversation:(LLAIMConversation *) conv;

@end
