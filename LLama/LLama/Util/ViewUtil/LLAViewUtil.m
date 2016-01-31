//
//  LLAViewUtil.m
//  LLama
//
//  Created by WanDa on 16/1/8.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAViewUtil.h"
#import "LLALoadingView.h"

static const CGFloat defaultDuration = 1.0;

static const CGFloat loveSuccessDefaultDuration = 0.4;

@implementation LLAViewUtil

+ (MBProgressHUD *) showAlter:(UIView *)view withText:(NSString *)text {
    return [self showAlter:view withText:text withOffset:0 duration:defaultDuration];
}

+ (MBProgressHUD *) showAlter:(UIView *)view withText:(NSString *)text withOffset:(float)offset{
    return [self showAlter:view withText:text withOffset:offset duration:defaultDuration];
}

+ (MBProgressHUD *) showAlter:(UIView *)view withText:(NSString *)text withOffset:(float)offset duration:(CGFloat)duration {
    
    if(view == nil || text.length < 1){
        return nil;
    }
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = text;
    HUD.margin = 10.f;
    HUD.yOffset = offset;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:duration];
    
    return HUD;

}

//loading View

+ (LLALoadingView *) addLLALoadingViewToView:(UIView *)view {
    
    if (!view)
        return nil;
    
    LLALoadingView *loadinView = [[LLALoadingView alloc] initWithView:view];
    [view addSubview:loadinView];
    
    return loadinView;
}

//
+ (void) showLoveSuccessAnimationInView:(UIView *)inView fromView:(UIView *)fromView duration:(CGFloat)duration compeleteBlock:(void (^)(BOOL))complete{
    if (!inView || !fromView) {
        return;
    }
    
    CGFloat animationDuration = duration;
    
    if (animationDuration <= 0) {
        animationDuration = loveSuccessDefaultDuration;
    }
    fromView.transform = CGAffineTransformMakeScale(1.8,1.8);
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        fromView.transform = CGAffineTransformMakeScale(1.8, 1.8);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            fromView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            if (complete) {
                complete(finished);
            }
        }];
    }];
    
}

@end
