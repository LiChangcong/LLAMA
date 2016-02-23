//
//  LLAEditVideoProgressView.h
//  LLama
//
//  Created by Live on 16/1/28.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

extern const CGFloat editVideo_progressViewHeight;

@class LLAEditVideoProgressView;

@protocol LLAEditVideoProgressViewDelegate <NSObject>

@optional

- (void) progressView:(LLAEditVideoProgressView *) progressView didChangeBeginRatio:(CGFloat) beginRatio;
- (void) progressView:(LLAEditVideoProgressView *) progressView didEndEditBeginRatio:(CGFloat) beginRatio;

- (void) progressView:(LLAEditVideoProgressView *) progressView didChangeEndRatio:(CGFloat) endRatio;
- (void) progressView:(LLAEditVideoProgressView *) progressView didEndEditEndRatio:(CGFloat) endRatio;

@end

@interface LLAEditVideoProgressView : UIView

@property(nonatomic , weak) id<LLAEditVideoProgressViewDelegate> delegate;

@property(nonatomic , readonly ,weak) AVAsset *editAsset;

@property(nonatomic , assign) NSInteger numberOfThumbImages;

@property(nonatomic , readonly) CGFloat editBeginRatio;
@property(nonatomic , readonly) CGFloat editEndRatio;

- (instancetype) initWithAsset:(AVAsset *) asset;

@end
