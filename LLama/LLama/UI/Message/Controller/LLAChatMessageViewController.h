//
//  LLAChatMessageViewController.h
//  LLama
//
//  Created by Live on 16/3/1.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLACommonViewController.h"

@class LLAIMConversation;

@interface LLAChatMessageViewController : LLACommonViewController

- (instancetype) initWithConversation:(LLAIMConversation *) conversation;

@end
