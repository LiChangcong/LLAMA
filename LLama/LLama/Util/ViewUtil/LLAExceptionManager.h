//
//  LLAExceptionManager.h
//  LLama
//
//  Created by Live on 16/2/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLAExceptionManager : NSObject

+ (instancetype) shareManager;

- (void) showTokenExpiredView;

@end
