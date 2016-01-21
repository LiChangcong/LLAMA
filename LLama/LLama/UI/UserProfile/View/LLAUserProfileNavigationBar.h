//
//  LLAUserProfileNavigationBar.h
//  LLama
//
//  Created by Live on 16/1/21.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLAUserProfileNavigationBar : UINavigationBar

@property(nonatomic , copy) NSString *title;

@property(nonatomic , strong) UIView *titleView;

@property(nonatomic, strong) UIBarButtonItem *leftBarButtonItem;

@property(nonatomic, copy) NSArray <UIBarButtonItem *> *leftBarButtonItems;

@property(nonatomic, strong) UIBarButtonItem *rightBarButtonItem;

@property(nonatomic, copy) NSArray <UIBarButtonItem *> *rightBarButtonItems;


- (void) makeBackgroundClear:(BOOL) clear;

@end
