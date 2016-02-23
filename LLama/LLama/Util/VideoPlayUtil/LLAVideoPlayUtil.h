//
//  LLAVideoPlayUtil.h
//  LLama
//
//  Created by Live on 16/2/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLACellPlayVideoProtocol.h"

@interface LLAVideoPlayUtil : NSObject

//
+ (void) stopOutBoundsPlayingVideoInCells:(NSArray<UIView<LLACellPlayVideoProtocol> *> *) playerCells inScrollView:(UIScrollView *) scrollView;

//
+ (void) playShouldPlayVideoInCells:(NSArray<UIView<LLACellPlayVideoProtocol> *> *) playerCells inScrollView:(UIScrollView *) scrollView;

//stop all videos

+ (void) stopAllVideosInCells:(NSArray<UIView<LLACellPlayVideoProtocol> *> *) playerCells inScrollView:(UIScrollView *) scrollView;

//handle playerView tap toPlay

+ (void) handlePlayerViewTappToPlay:(LLAVideoPlayerView *)playerView inCell:(NSArray<UIView<LLACellPlayVideoProtocol> *> *) playerCells inScrollView:(UIScrollView *) scrollView;


@end
