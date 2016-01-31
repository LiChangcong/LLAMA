//
//  LLAPayUserViewController.h
//  LLama
//
//  Created by Live on 16/1/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLACommonViewController.h"

@class LLAPayUserPayInfo;

@protocol LLAPayUserViewControllerDelegate <NSObject>

- (void) refreshData;

@end

@interface LLAPayUserViewController : LLACommonViewController

@property(nonatomic , weak) id<LLAPayUserViewControllerDelegate> delegate;

- (instancetype) initWithPayInfo:(LLAPayUserPayInfo *) info;

@end
