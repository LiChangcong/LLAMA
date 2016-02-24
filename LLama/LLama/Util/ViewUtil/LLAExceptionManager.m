//
//  LLAExceptionManager.m
//  LLama
//
//  Created by Live on 16/2/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAExceptionManager.h"
#import "LLAUser.h"
#import "LLAChangeRootControllerUtil.h"

@interface LLAExceptionManager()<UIAlertViewDelegate>
{
    BOOL isShowingTokenExpired;
}

@end

@implementation LLAExceptionManager

+ (instancetype) shareManager {
    static LLAExceptionManager *shareManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareManager = [[[self class] alloc] init];
    });
    
    return shareManager;
}

- (void) showTokenExpiredView {
    
    if (!isShowingTokenExpired) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你的帐号已在别处登录，请重新登录" message:@"" delegate:self cancelButtonTitle:@"重新登录" otherButtonTitles: nil];
        [alert show];
        isShowingTokenExpired = YES;
    }
}

#pragma mark - UIAlertViewDelegate

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    isShowingTokenExpired = NO;
    //
    [LLAUser logout];
    //change root view controller
    [LLAChangeRootControllerUtil changeToLoginViewController];

}

@end
