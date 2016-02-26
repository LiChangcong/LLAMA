//
//  LLASocialContinuousManager.h
//  LLama
//
//  Created by Live on 16/2/26.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLASocialShareHeader.h"
#import "LLAShareRequestInfo.h"

@interface LLASocialContinuousShareManager : NSObject

+ (instancetype) shareManager;

- (void) shareToPlatforms:(NSArray *) platformsArray
               requetInfo:(LLAShareRequestInfo *) requestInfo
       stateChangeHandler:(LLASocialShareStateChangeHandler) stateChangeHandler;

@end
