//
//  LLALoadingView.h
//  LLama
//
//  Created by Live on 16/1/9.
//  Copyright © 2016年 heihei. All rights reserved.
//


#import <MBProgressHUD/MBProgressHUD.h>

/****
 define custom Loading View
 
 it is easy to Change when needed
 
 ****/

@interface LLALoadingView : MBProgressHUD

- (instancetype) initWithView:(UIView *)view;

@end
