//
//  LLAEditVideoViewController.h
//  LLama
//
//  Created by Live on 16/1/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLACustomNavigationBarViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface LLAEditVideoViewController : LLACustomNavigationBarViewController

- (instancetype) initWithAVAsset:(AVAsset *) asset;

@end
