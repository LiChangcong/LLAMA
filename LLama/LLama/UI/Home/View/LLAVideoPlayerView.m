//
//  LLAVideoPlayerView.m
//  LLama
//
//  Created by Live on 16/1/13.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAVideoPlayerView.h"

#import "LLAVideoInfo.h"
#import <AVFoundation/AVFoundation.h>

#import "LLALoadingView.h"
#import "LLAViewUtil.h"

#import "LLAVideoCacheUtil.h"

static void *AVPlayerStatusObservationContext = &AVPlayerStatusObservationContext;
static void *AVPlayerRateObservationContext = &AVPlayerRateObservationContext;

@interface LLAVideoPlayerView()
{
    AVPlayer *videoPlayer;
    AVPlayerLayer *videoPlayerLayer;
    
    id playerTimeObserver;
    
    UIActivityIndicatorView *loadingIndicator;
}

@property(nonatomic , assign , readwrite) BOOL isPlaying;

@end

@implementation LLAVideoPlayerView

@synthesize playingVideoInfo;
@synthesize isPlaying;
@synthesize delegate;

#pragma mark - Life Cycle

- (void) dealloc {
    
    @try {
        [videoPlayer removeObserver:self forKeyPath:@"status"];
        [videoPlayer removeObserver:self forKeyPath:@"rate"];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    [self stopVideo];
    [videoPlayer removeTimeObserver:playerTimeObserver];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    
}

- (void) layoutSubviews {
    
    [super layoutSubviews];
    //
    videoPlayerLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    loadingIndicator.center = self.center;
    
}

#pragma mark - Init

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.clipsToBounds = YES;
        
        [self initAVPlayer];
        [self initPlayerLayer];
        
        loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        loadingIndicator.hidesWhenStopped = YES;
        
        [self addSubview:loadingIndicator];
        
    }
    return self;
}

- (void) initAVPlayer {
    
    videoPlayer = [[AVPlayer alloc] init];
    
    [videoPlayer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:AVPlayerStatusObservationContext];
    [videoPlayer addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:AVPlayerRateObservationContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    playerTimeObserver = [videoPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 5) queue:NULL usingBlock:^(CMTime time) {
        //playing call back
    }];
    
}


- (void) initPlayerLayer {
    
    if (videoPlayerLayer){
        [videoPlayerLayer removeFromSuperlayer];
    }
    
    videoPlayerLayer = [[AVPlayerLayer alloc] init];
    //videoPlayerLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    videoPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    videoPlayerLayer.player = videoPlayer;
    videoPlayerLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.layer addSublayer:videoPlayerLayer];
}

- (void) replacePlayerItem {
    
    AVPlayerItem *newItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:playingVideoInfo.videoPlayURL]];
    
    if (newItem) {
        [videoPlayer replaceCurrentItemWithPlayerItem:newItem];
    }
}

#pragma mark - Getter

- (BOOL) isPlaying {
    return videoPlayer.rate > 0;
}

#pragma mark - Setter

- (void) setPlayingVideoInfo:(LLAVideoInfo *)videoInfo {
    
    if (playingVideoInfo == videoInfo) {
        return;
    }
    
    if(isPlaying){
        [self stopVideo];
    }
    
    playingVideoInfo = videoInfo;
    
    [self replacePlayerItem];
    
}

#pragma mark - Observer

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if (context == AVPlayerStatusObservationContext) {
        
        switch (videoPlayer.status) {
            case AVPlayerStatusFailed:
                [loadingIndicator stopAnimating];
                break;
            case AVPlayerStatusReadyToPlay:
                [loadingIndicator stopAnimating];
                break;
            case AVPlayerStatusUnknown:
                //
                [loadingIndicator startAnimating];
                break;
                
            default:
                break;
        }
        
    }else if(context == AVPlayerRateObservationContext) {
        if (videoPlayer.rate > 0) {
            [loadingIndicator stopAnimating];
        }else {
            [loadingIndicator startAnimating];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}

#pragma mark - Notification

- (void) playerDidPlayToEnd:(NSNotification *) noti {
    if (noti.object == videoPlayer.currentItem) {
        //play to end
        [videoPlayer seekToTime:kCMTimeZero];
        //[videoPlayer play];
        
        [[LLAVideoCacheUtil shareInstance] cacheVideoFromPlayerItem:videoPlayer.currentItem videoInfo:playingVideoInfo];
        
    }
}

#pragma mark - Public Method

- (void) playVideo {
    
    if (videoPlayer.rate >0) {
        return;
    }else {
        [videoPlayer play];
    }
    self.hidden = NO;
}

- (void) stopVideo {
    [videoPlayer pause];
    
    [videoPlayer seekToTime:kCMTimeZero];
    
    self.hidden = YES;
}

- (void) pauseVideo {
    [videoPlayer pause];
}

@end
