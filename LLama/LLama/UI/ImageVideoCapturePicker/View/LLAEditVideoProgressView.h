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

@interface LLAEditVideoProgressView : UIView

@property(nonatomic , readonly ,weak) AVAsset *editAsset;

@property(nonatomic , assign) NSInteger numberOfThumbImages;

@property(nonatomic , readonly) CGFloat editBeginRatio;
@property(nonatomic , readonly) CGFloat editEndRatio;

- (instancetype) initWithAsset:(AVAsset *) asset;

@end
