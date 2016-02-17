//
//  LLAVideoPlayerView.h
//  LLama
//
//  Created by Live on 16/1/13.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAVideoInfo;

@class LLAVideoPlayerView;

@protocol LLAVideoPlayerViewDelegate <NSObject>

@optional

- (void) playerViewTappToPlay:(LLAVideoPlayerView *) playerView;

- (void) playerViewTappToPause:(LLAVideoPlayerView *)playerView;

@end

@interface LLAVideoPlayerView : UIView

@property(nonatomic , weak) id<LLAVideoPlayerViewDelegate> delegate;

@property(nonatomic , assign , readonly) BOOL isPlaying;

@property(nonatomic , strong) LLAVideoInfo *playingVideoInfo;

- (void) playVideo;

- (void) pauseVideo;

- (void) stopVideo;

- (void) updateCoverImageWithVideoInfo:(LLAVideoInfo *) videoInfo;

@end
