//
//  LLACaptureVideoProgressView.h
//  LLama
//
//  Created by Live on 16/1/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLACaptureVideoClipInfo;

@interface LLACaptureVideoProgressView : UIView

@property(nonatomic , assign) CGFloat minSecond;
@property(nonatomic , assign) CGFloat maxSecond;

//@property(nonatomic , readonly) NSMutableArray<LLACaptureVideoClipInfo *> *videoClipArray;

- (void) startBlinkIndicator;

- (void) stopBlinkIndicator;

- (void) addVideoClipInfo;

- (void) updateLastVideoClipInfoWithNewDuration:(CGFloat) duration;

- (void) deleteVideoClipInfo:(void(^)(BOOL hasDelete)) callback;

@end
