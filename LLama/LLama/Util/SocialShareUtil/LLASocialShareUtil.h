//
//  LLASocialShareUtil.h
//  LLama
//
//  Created by Live on 16/2/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLASocialShareHeader.h"
#import "LLAShareRequestInfo.h"
#import "LLAShareInfo.h"

@interface LLASocialShareUtil : NSObject

+ (instancetype) shareManager;

- (void) shareWithRequestInfo:(LLAShareRequestInfo *) requestInfo
                        title:(NSString *) title
                reportHandler:(LLASocialReportHandler) reportHandler
           stateChangeHandler:(LLASocialShareStateChangeHandler) stateChangeHandler;

- (void) shareWithShareInfo:(LLAShareInfo *) shareInfo platform:(LLASocialSharePlatform) platform completion:(LLASocialShareStateChangeHandler) completion;


@end
