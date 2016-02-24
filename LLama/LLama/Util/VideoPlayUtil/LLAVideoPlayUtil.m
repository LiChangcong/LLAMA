//
//  LLAVideoPlayUtil.m
//  LLama
//
//  Created by Live on 16/2/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAVideoPlayUtil.h"

@implementation LLAVideoPlayUtil

//stop the video player whitch is out of bounds

+ (void) stopOutBoundsPlayingVideoInCells:(NSArray<UIView<LLACellPlayVideoProtocol> *> *)playerCells inScrollView:(UIScrollView *)scrollView{

    for (UIView* tempCell in playerCells) {
        if ([[tempCell class] conformsToProtocol:@protocol(LLACellPlayVideoProtocol)]) {
            
            UIView<LLACellPlayVideoProtocol> *tc = (UIView<LLACellPlayVideoProtocol> *)tempCell;
            
            CGRect playerFrame = tc.videoPlayerView.frame;
            
            CGRect subViewFrame = [tc convertRect:playerFrame toView:scrollView];
            if (subViewFrame.origin.y >= scrollView.contentOffset.y+scrollView.bounds.size.height || scrollView.contentOffset.y>subViewFrame.origin.y+subViewFrame.size.height) {
                
                [tc.videoPlayerView stopVideo];
            }
            
        }
    }

}

//play the should play video in scrollView

+ (void) playShouldPlayVideoInCells:(NSArray<UIView<LLACellPlayVideoProtocol> *> *)playerCells inScrollView:(UIScrollView *)scrollView {
    
    id <LLACellPlayVideoProtocol> playCell = nil;
    CGFloat maxHeight = 0;
    
    for (UITableViewCell* tempCell in playerCells) {
        if ([[tempCell class] conformsToProtocol:@protocol(LLACellPlayVideoProtocol)]) {
            
            UIView<LLACellPlayVideoProtocol> *tc = (UIView<LLACellPlayVideoProtocol> *)tempCell;
            
            CGRect playerFrame = tc.videoPlayerView.frame;
            
            CGRect subViewFrame = [tc convertRect:playerFrame toView:scrollView];
            
            CGFloat heightInWindow =  0;
            
            if (subViewFrame.origin.y < scrollView.contentOffset.y) {
                heightInWindow = subViewFrame.origin.y+subViewFrame.size.height-scrollView.contentOffset.y;
            }else if(subViewFrame.origin.y+subViewFrame.size.height > scrollView.contentOffset.y+scrollView.bounds.size.height) {
                heightInWindow = scrollView.contentOffset.y+scrollView.bounds.size.height-subViewFrame.origin.y;
                
            }else {
                heightInWindow = subViewFrame.size.height;
            }
            
            
            if (heightInWindow >= maxHeight) {
                maxHeight = heightInWindow;
                playCell = tc;
            }
        }
    }
    
    //
    for (UITableViewCell* tempCell in playerCells) {
        if ([[tempCell class] conformsToProtocol:@protocol(LLACellPlayVideoProtocol)]) {
            
            UITableViewCell<LLACellPlayVideoProtocol> *tc = (UITableViewCell<LLACellPlayVideoProtocol> *)tempCell;
            
            if (tc == playCell) {
                playCell.videoPlayerView.playingVideoInfo = playCell.shouldPlayVideoInfo;
                [playCell.videoPlayerView playVideo];
            }else {
                [tc.videoPlayerView stopVideo];
            }
            
        }
    }

    
}

//

+ (void) stopAllVideosInCells:(NSArray<UIView<LLACellPlayVideoProtocol> *> *)playerCells inScrollView:(UIScrollView *)scrollView {
    
    for (UITableViewCell* tempCell in playerCells) {
        
        if ([[tempCell class] conformsToProtocol:@protocol(LLACellPlayVideoProtocol)]) {
            
            UIView<LLACellPlayVideoProtocol> *tc = (UIView<LLACellPlayVideoProtocol> *)tempCell;
            [tc.videoPlayerView stopVideo];
        }
    }

    
}

//
+ (void) handlePlayerViewTappToPlay:(LLAVideoPlayerView *)playerView inCell:(NSArray<UIView<LLACellPlayVideoProtocol> *> *) playerCells inScrollView:(UIScrollView *) scrollView {
    
    //
    for (UITableViewCell* tempCell in playerCells) {
        if ([[tempCell class] conformsToProtocol:@protocol(LLACellPlayVideoProtocol)]) {
            
            UIView<LLACellPlayVideoProtocol> *tc = (UIView <LLACellPlayVideoProtocol> *)tempCell;
            if (playerView != tc.videoPlayerView) {
                [tc.videoPlayerView stopVideo];
            }
        }
    }
    
}


@end
