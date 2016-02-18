//
//  LLAUploadVideoProgressView.h
//  LLama
//
//  Created by Live on 16/1/31.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLAUploadVideoObserverProtocol.h"
#import "LLAUploadVideoShareManager.h"

extern CGFloat LLAUploadVideoProgressViewHeight;

@class LLAUploadVideoProgressView;

@protocol LLAUploadVideoProgressViewDelegate <NSObject>

- (void) uploadVideoFinished:(LLAUploadVideoProgressView *) progressView;

- (void) uploadVideoFailed:(LLAUploadVideoProgressView *) progressView;

@end

@interface LLAUploadVideoProgressView : UIView<LLAUploadVideoObserverProtocol>

@property(nonatomic , weak) id<LLAUploadVideoProgressViewDelegate> delegate;

- (instancetype) initWithViewType:(videoUploadType) type;

@end
