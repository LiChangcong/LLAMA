//
//  UIViewController+IsVisible.m
//  LLama
//
//  Created by Live on 16/1/31.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "UIViewController+IsVisible.h"

@implementation UIViewController (IsVisible)

- (BOOL) isVisible {
    return [self isViewLoaded] && self.view.window;
}

@end
