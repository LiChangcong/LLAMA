//
//  LLAVideoPlayerView.h
//  LLama
//
//  Created by Live on 16/1/13.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAVideoInfo;

@interface LLAVideoPlayerView : UIView

@property(nonatomic , assign , readonly) BOOL isPlaying;

@property(nonatomic , strong) LLAVideoInfo *playingVideoInfo;

- (void) playVideo;

- (void) pauseVideo;

- (void) stopVideo;

@end
