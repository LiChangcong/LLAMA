//
//  LLAMessageCountManager.h
//  LLama
//
//  Created by Live on 16/3/8.
//  Copyright © 2016年 heihei. All rights reserved.
//

#define  LLA_UNREAD_MESSAGE_COUNT_CHANGED_NOTIFICATION @"LLA_UNREAD_MESSAGE_COUNT_CHANGED_NOTIFICATION"

#import <Foundation/Foundation.h>

@interface LLAMessageCountManager : NSObject

+ (instancetype) shareManager;

- (void) beginFetchCount;

//

- (NSInteger) totalUnreadCount;

- (NSInteger) getUnreadPraiseNum;
- (void) resetUnreadPraiseNum;

- (NSInteger) getUnreadCommentNum;
- (void) resetUnreadCommnetNum;

- (NSInteger) getUnreadOrderNum;
- (void) resetUnreadOrderNum;

- (NSInteger) getUnreadIMNum;
- (void) unReadIMNumChanged;

@end
