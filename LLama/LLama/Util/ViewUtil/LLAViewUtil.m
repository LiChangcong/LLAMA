//
//  LLAViewUtil.m
//  LLama
//
//  Created by WanDa on 16/1/8.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAViewUtil.h"
#import "MBProgressHUD.h"

static const CGFloat defaultDuration = 1.0;

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

@end
