//
//  LLACaptureVideoClipInfo.h
//  LLama
//
//  Created by Live on 16/1/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "MTLModel.h"

@interface LLACaptureVideoClipInfo : MTLModel

@property(nonatomic , assign) CGFloat videoClipDuration;

@property(nonatomic , weak) UIView *sepLineView;

@property(nonatomic , weak) UIView *progressView;

@property(nonatomic , assign) BOOL shouldDelete;

@end
