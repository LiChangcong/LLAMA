//
//  LLAChatInpuFunctionView.h
//  LLama
//
//  Created by Live on 16/2/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAChatInpuFunctionView;

@protocol LLAChatInpuFunctionViewDelegate <NSObject>

- (void) recordVoiceWithFunctionView:(LLAChatInpuFunctionView *) functionView;

- (void) pickImageWithFunctionView:(LLAChatInpuFunctionView *) functionView;

- (void) takePhotoWithFunctionView:(LLAChatInpuFunctionView *) functionView;

- (void) showEmojiWithFunctionView:(LLAChatInpuFunctionView *) functionView;

@end

@interface LLAChatInpuFunctionView : UIView

@property(nonatomic , weak) id<LLAChatInpuFunctionViewDelegate> delegate;

+ (CGFloat) calculateHeight;

@end
