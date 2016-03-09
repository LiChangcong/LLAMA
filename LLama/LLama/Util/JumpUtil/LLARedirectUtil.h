//
//  LLARedirctUtil.h
//  LLama
//
//  Created by Live on 16/2/18.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,LLARedirectType){
    LLARedirectType_None = 0,
    LLARedirectType_HomeHall = 1,
    LLARedirectType_UserProfile = 2,
    LLARedirectType_MessageCenter = 3,
};

@interface LLARedirectUtil : NSObject

+ (instancetype) shareInstance;

- (void) redirectWithNewType:(LLARedirectType) newType;

- (void) doRedirect;

@end
