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

@interface LLASocialShareUtil : NSObject

+ (void) shareWithRequestInfo:(LLAShareRequestInfo *) requestInfo
                        title:(NSString *) title
                reportHandler:(LLASocialReportHandler) reportHandler
           stateChangeHandler:(LLASocialShareStateChangeHandler) stateChangeHandler;


@end
