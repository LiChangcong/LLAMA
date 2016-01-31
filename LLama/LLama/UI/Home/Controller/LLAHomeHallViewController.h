//
//  LLAHomeHallViewController.h
//  LLama
//
//  Created by Live on 16/1/12.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLACommonViewController.h"

@protocol LLAHomeHallViewControllerDelegate <NSObject>

- (BOOL) shouldPlayVideo;

@end

@interface LLAHomeHallViewController : LLACommonViewController

@property(nonatomic , weak) id<LLAHomeHallViewControllerDelegate> delegate;

- (void) stopAllVideo;

- (void) startPlayVideo;

@end
