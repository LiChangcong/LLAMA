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

static void *AVPlayerCurrentItemObservationContext = &AVPlayerCurrentItemObservationContext;
static void *AVPlayerItemStatusObservationContext = &AVPlayerItemStatusObservationContext;
static void *AVPlayerRateObservationContext = &AVPlayerRateObservationContext;

@interface LLAVideoPlayerView()
{
    AVPlayer *videoPlayer;
    AVPlayerLayer *videoPlayerLayer;
    
    id playerTimeObserver;
    
    UIActivityIndicatorView *loadingIndicator;
    
    //
    UIImageView *coverImageView;
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
        
        [videoPlayer removeObserver:self forKeyPath:@"rate"];
        [videoPlayer removeObserver:self forKeyPath:@"currentItem"];
        
        [videoPlayer.currentItem removeObserver:self forKeyPath:@"status"];
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
    
    loadingIndicator.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    coverImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

}

#pragma mark - Init

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.clipsToBounds = YES;
        
        [self initAVPlayer];
        [self initPlayerLayer];
        [self initCoverImageView];
        
        //
        __weak typeof(coverImageView) weakCoverImageView = coverImageView;
        __weak typeof(videoPlayer) weakVideoPlayer = videoPlayer;
        
        playerTimeObserver = [videoPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 5) queue:NULL usingBlock:^(CMTime time) {
            //playing call back
            if (weakVideoPlayer.currentItem.currentTime.value > 0) {
                weakCoverImageView.hidden = YES;
            }else {
                weakCoverImageView.hidden = NO;
            }
        }];
        
        //
        
        loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        loadingIndicator.hidesWhenStopped = YES;
        
        [self addSubview:loadingIndicator];
        
        //
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playerViewTapped:)];
        [self addGestureRecognizer:tapGes];
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

- (void) initAVPlayer {
    
    videoPlayer = [[AVPlayer alloc] init];
    
//    [videoPlayer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld context:AVPlayerStatusObservationContext];
    [videoPlayer addObserver:self forKeyPath:@"rate" options: NSKeyValueObservingOptionNew |  NSKeyValueObservingOptionInitial context:AVPlayerRateObservationContext];
    
    [videoPlayer addObserver:self forKeyPath:@"currentItem" options:NSKeyValueObservingOptionNew context:AVPlayerCurrentItemObservationContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    
    
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

- (void) initCoverImageView {
    coverImageView = [[UIImageView alloc] init];
    coverImageView.translatesAutoresizingMaskIntoConstraints = NO;
    coverImageView.userInteractionEnabled = NO;
    coverImageView.clipsToBounds = YES;
    coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    //coverImageView.hidden = YES;
    
    [self addSubview:coverImageView];
    
}

- (void) replacePlayerItem {
    
    AVPlayerItem *newItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:playingVideoInfo.videoPlayURL]];
    
    if (newItem) {
        
        [self removePlayerItemObserver];
        
        [videoPlayer replaceCurrentItemWithPlayerItem:newItem];
        
        [self initPlayerItemObserver];
    }
}


#pragma mark - Getter

- (BOOL) isPlaying {
    return videoPlayer.rate > 0;
}

#pragma mark - Setter

- (void) setPlayingVideoInfo:(LLAVideoInfo *)videoInfo {
    
    if ([playingVideoInfo isEqual: videoInfo]) {
        return;
    }
    
    if(isPlaying){
        [self stopVideo];
    }
    
    playingVideoInfo = videoInfo;
    
    [self replacePlayerItem];
    
    //
    [coverImageView setImageWithURL:[NSURL URLWithString:playingVideoInfo.videoCoverImageURL] placeholderImage:[UIImage llaImageWithName:@"placeHolder_750"]];
    
}

#pragma mark - Observer

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if (context == AVPlayerCurrentItemObservationContext) {
        //change item
        
        
    }else if (context == AVPlayerItemStatusObservationContext) {
        
        switch (videoPlayer.currentItem.status) {
            case AVPlayerItemStatusFailed:
                
                [loadingIndicator stopAnimating];
                
                coverImageView.hidden = NO;
                [LLAViewUtil showAlter:self withText:@"视频播放失败"];
                [self removePlayerItemObserver];
                break;
            case AVPlayerItemStatusReadyToPlay:
                [loadingIndicator stopAnimating];
                break;
                
            case AVPlayerItemStatusUnknown:
                //
                [loadingIndicator startAnimating];
                coverImageView.hidden = NO;

                break;
                
            default:
                break;
        }
        
    }else if(context == AVPlayerRateObservationContext) {
        
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
    }
}

#pragma mark - playerViewTapped

- (void) playerViewTapped:(UITapGestureRecognizer *) ges {

    if (self.isPlaying) {
        [self pauseVideo];
        if (delegate && [delegate respondsToSelector:@selector(playerViewTappToPause:)]) {
            [delegate playerViewTappToPause:self];
        }
    }else {
        [self playVideo];
        if (delegate && [delegate respondsToSelector:@selector(playerViewTappToPlay:)]) {
            [delegate playerViewTappToPlay:self];
        }

    }
}

#pragma mark - Publick Mehtod

- (void) removePlayerItemObserver {
    
    if (videoPlayer.currentItem) {
        @try {
            [videoPlayer.currentItem removeObserver:self forKeyPath:@"status"];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }

    }
}

- (void) initPlayerItemObserver {
    
    if (videoPlayer.currentItem) {
    
        [videoPlayer.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld context:AVPlayerItemStatusObservationContext];
    }
}

#pragma mark - Public Method

- (void) playVideo {
    
    if (videoPlayer.rate >0) {
        return;
    }else {
        [videoPlayer play];
    }
    
}

- (void) stopVideo {
    
    if (self.isPlaying || CMTimeGetSeconds(videoPlayer.currentTime) > 0 || videoPlayer.currentItem.status == AVPlayerItemStatusUnknown) {
    
        [videoPlayer pause];
    
        [videoPlayer seekToTime:kCMTimeZero];
    }
    //
    coverImageView.hidden = NO;
}

- (void) pauseVideo {
    [videoPlayer pause];
}


- (void) updateCoverImageWithVideoInfo:(LLAVideoInfo *)videoInfo {
    [coverImageView setImageWithURL:[NSURL URLWithString:videoInfo.videoCoverImageURL] placeholderImage:[UIImage llaImageWithName:@"placeHolder_750"]];
}

@end
