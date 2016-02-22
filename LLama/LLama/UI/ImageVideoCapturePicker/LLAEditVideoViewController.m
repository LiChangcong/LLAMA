//
//  LLAEditVideoViewController.m
//  LLama
//
//  Created by Live on 16/1/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

//controller
#import "LLAEditVideoViewController.h"
#import "LLAPickVideoNavigationController.h"

//view
#import "LLAEditVideoTopToolBar.h"
#import "LLAEditVideoProgressView.h"

#import "LLALoadingView.h"
#import "LLAEditVideoScaleView.h"

//model

//util
#import "SCVideoPlayerView.h"
#import "SCRecorder.h"
#import "LLAViewUtil.h"

//
#import "LLAUploadFileUtil.h"

#import "SDAVAssetExportSession.h"


static const CGFloat topBarHeight = 70;

static NSString *playPauseButtonImageName_Normal = @"play";
static NSString *playPasueButtonImageName_Highlight = @"playh";

@interface LLAEditVideoViewController()<LLAEditVideoTopToolBarDelegate,SCVideoPlayerViewDelegate,SCPlayerDelegate,LLAEditVideoProgressViewDelegate>
{
    AVAsset *editAsset;
    
    LLAEditVideoTopToolBar *topBar;
    
    UIScrollView *playerViewBackScrollView;
    
    LLAEditVideoScaleView *scaleView;
    
    SCVideoPlayerView *videoPlayerView;
    
    LLAEditVideoProgressView *editProgressView;
    
    UIButton *playPauseButton;
    
}

@end

@implementation LLAEditVideoViewController

#pragma mark - Life Cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:0x202031];
//    
    [self initVariables];
    [self initTopBarView];
    [self initSubViews];
    [self initSubContraints];
    
    [videoPlayerView.player setItemByAsset:editAsset];
    //[videoPlayerView.player play];
}

#pragma mark - Init

- (instancetype) initWithAVAsset:(AVAsset *)asset {
    
    self = [super init];
    if (self) {
        
        editAsset = asset;
    }
    
    return self;
    
}


- (void) initVariables {
    
}

- (void) initTopBarView {
    topBar = [[LLAEditVideoTopToolBar alloc] init];
    topBar.translatesAutoresizingMaskIntoConstraints = NO;
    topBar.delegate = self;
    
    [self.view addSubview:topBar];
}

- (void) initSubViews {
    
    playerViewBackScrollView = [[UIScrollView alloc] init];
    playerViewBackScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    playerViewBackScrollView.backgroundColor = self.view.backgroundColor;
    playerViewBackScrollView.clipsToBounds = YES;
    playerViewBackScrollView.bounces = NO;
    playerViewBackScrollView.showsHorizontalScrollIndicator = NO;
    playerViewBackScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:playerViewBackScrollView];
    
    
    //put playerView on player back Scroll View
    videoPlayerView = [[SCVideoPlayerView alloc] init];
    videoPlayerView.translatesAutoresizingMaskIntoConstraints = NO;
    videoPlayerView.delegate = self;
    videoPlayerView.player.delegate = self;
    videoPlayerView.tapToPauseEnabled = YES;
    videoPlayerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [playerViewBackScrollView addSubview:videoPlayerView];
    
    //
    scaleView = [[LLAEditVideoScaleView alloc] init];
    scaleView.translatesAutoresizingMaskIntoConstraints = NO;
    scaleView.userInteractionEnabled = NO;
    scaleView.hidden = YES;
    [self.view addSubview:scaleView];
    
    //
    
    playPauseButton = [[UIButton alloc] init];
    playPauseButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [playPauseButton setImage:[UIImage llaImageWithName:playPauseButtonImageName_Normal] forState:UIControlStateNormal];
    [playPauseButton setImage:[UIImage llaImageWithName:playPasueButtonImageName_Highlight] forState:UIControlStateHighlighted];
    
    [playPauseButton addTarget:self action:@selector(playPauseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:playPauseButton];
    
    //
    editProgressView = [[LLAEditVideoProgressView alloc] initWithAsset:editAsset];
    editProgressView.translatesAutoresizingMaskIntoConstraints = NO;
    editProgressView.delegate = self;
    
    [self.view addSubview:editProgressView];
    
}

- (void) initSubContraints {
    
    //constraints
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[topBar(topBarHeight)]-(0)-[playerViewBackScrollView(playerHeight)]-(0)-[editProgressView(editHeight)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"topBarHeight":@(topBarHeight),
                @"playerHeight":@(self.view.frame.size.width),
                @"editHeight":@(editVideo_progressViewHeight+self.view.frame.size.width/editProgressView.numberOfThumbImages)}
      views:NSDictionaryOfVariableBindings(topBar,playerViewBackScrollView,editProgressView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[topBar]-(0)-[scaleView(scaleHeight)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{
                @"scaleHeight":@(self.view.frame.size.width)}
      views:NSDictionaryOfVariableBindings(topBar,scaleView)]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:playPauseButton
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:playerViewBackScrollView
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];
    
    //horizonal
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[topBar]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(topBar)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[playerViewBackScrollView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(playerViewBackScrollView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[scaleView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(scaleView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[editProgressView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(editProgressView)]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:playPauseButton
      attribute:NSLayoutAttributeCenterX
      relatedBy:NSLayoutRelationEqual
      toItem:playerViewBackScrollView
      attribute:NSLayoutAttributeCenterX
      multiplier:1.0
      constant:0]];

    
    [self.view addConstraints:constrArray];
    
    //constraints on player backScroll
    
    NSMutableArray *backScrollConstraints = [NSMutableArray array];
    
    
    CGSize videoSize = [self playerViewSizeForScroll];
    
    //vertical
    [backScrollConstraints addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[videoPlayerView(height)]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"height":@(videoSize.height)}
      views:NSDictionaryOfVariableBindings(videoPlayerView)]];
    //horizonal
    [backScrollConstraints addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[videoPlayerView(width)]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"width":@(videoSize.width)}
      views:NSDictionaryOfVariableBindings(videoPlayerView)]];
    
    [playerViewBackScrollView addConstraints:backScrollConstraints];
    
}

#pragma mark - Button Clicked

- (void) playPauseButtonClicked:(UIButton *) sender {
    //
    if (!videoPlayerView.player.isPlaying) {
        [videoPlayerView.player play];
        sender.hidden = YES;
    }
}

#pragma mark - Status Bar
- (BOOL) prefersStatusBarHidden {
    return YES;
}

#pragma mark - Video Size

- (CGSize) naturalSizeForEditAsset {
    
    AVAssetTrack *videoTrack = [[editAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    
    if (!videoTrack) {
        return CGSizeZero;
    }
    
    CGSize naturalSize = [videoTrack naturalSize];
    CGAffineTransform transform = videoTrack.preferredTransform;
    CGFloat videoAngleInDegree  = atan2(transform.b, transform.a) * 180 / M_PI;
    if (videoAngleInDegree == 90 || videoAngleInDegree == -90) {
        CGFloat width = naturalSize.width;
        naturalSize.width = naturalSize.height;
        naturalSize.height = width;
    }
    return naturalSize;
}

- (CGSize) playerViewSizeForScroll {
    
    CGSize videoNaturalSize = [self naturalSizeForEditAsset];
    
    float ratio;
    float xratio = self.view.bounds.size.width / videoNaturalSize.width;
    float yratio =self.view.bounds.size.width / videoNaturalSize.height;
    ratio = MAX(xratio, yratio);
    
    return CGSizeMake(videoNaturalSize.width * ratio, videoNaturalSize.height * ratio);
    
}

#pragma mark - LLAEditVideoTopToolBarDelegate
- (void) backToPre {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) editVideoDone {
    
    //

    
    //edit done,test,upload
//    SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:editAsset];
    
    //
    
    CGFloat assetDuration = CMTimeGetSeconds(editAsset.duration);
    
//    exportSession.outputUrl = [SCRecorder sharedRecorder].session.outputUrl;
//    exportSession.outputFileType = AVFileTypeMPEG4;
//    exportSession.contextType = SCContextTypeAuto;
//    exportSession.videoConfiguration.size = CGSizeMake(480, 480);
    
    //
    
    CMTime startTime = CMTimeMakeWithSeconds(assetDuration*editProgressView.editBeginRatio, editAsset.duration.timescale);
    
    CMTime durationTime = CMTimeMakeWithSeconds(assetDuration*(editProgressView.editEndRatio-editProgressView.editBeginRatio), editAsset.duration.timescale);
    
    if (CMTimeGetSeconds(durationTime) < 5) {
    
        [LLAViewUtil showAlter:self.view withText:@"片长不能小于5秒"];
        
        return;
    }else if (CMTimeGetSeconds(durationTime) > 60) {
        
        [LLAViewUtil showAlter:self.view withText:@"片长不能大于60秒"];
        
        return;
    }
    
    //trim position
    CGFloat left = playerViewBackScrollView.contentOffset.x / playerViewBackScrollView.contentSize.width;
    CGFloat right = (playerViewBackScrollView.contentSize.width-playerViewBackScrollView.contentOffset.x-playerViewBackScrollView.bounds.size.width) / playerViewBackScrollView.contentSize.width;
    
    CGFloat top = playerViewBackScrollView.contentOffset.y / playerViewBackScrollView.contentSize.height;
    CGFloat bottom = (playerViewBackScrollView.contentSize.height-playerViewBackScrollView.contentOffset.y - playerViewBackScrollView.bounds.size.height) / playerViewBackScrollView.contentSize.height;
    
    //exportSession.timeRange = CMTimeRangeMake(startTime, durationTime);
    
    //get thumb image
    
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:editAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    CMTime actualTime;
    
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:startTime actualTime:&actualTime error:nil];
    
    //crop image
    
    CGSize videoNaturalSize = [self naturalSizeForEditAsset];
    
    float ratio;
    float xratio = self.view.bounds.size.width / videoNaturalSize.width;
    float yratio =self.view.bounds.size.width / videoNaturalSize.height;
    ratio = MAX(xratio, yratio);
    
    CGRect cropRect = CGRectMake(videoNaturalSize.width*left, videoNaturalSize.height*top, videoNaturalSize.width*(1-left-right), videoNaturalSize.height*(1-top-bottom));
    
    cgImage = CGImageCreateWithImageInRect(cgImage, cropRect);
    
    UIImage *thumbImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    LLALoadingView *loadingView = [LLAViewUtil addLLALoadingViewToView:self.view];
    [loadingView show:YES];
    
    //system export
    
//    AVAssetExportSession *avExport = [[AVAssetExportSession alloc] initWithAsset:editAsset presetName:AVAssetExportPresetPassthrough];
//    avExport.outputURL = [SCRecorder sharedRecorder].session.outputUrl;
//    avExport.outputFileType = AVFileTypeMPEG4;
//    avExport.timeRange = CMTimeRangeMake(startTime, durationTime);
    
    //sdexport
    SDAVAssetExportSession *encoder = [[SDAVAssetExportSession alloc] initWithAsset:editAsset];
    encoder.outputFileType = AVFileTypeMPEG4;
    encoder.outputURL = [SCRecorder sharedRecorder].session.outputUrl;
    encoder.shouldOptimizeForNetworkUse = YES;
    encoder.timeRange = CMTimeRangeMake(startTime, durationTime);

    encoder.videoSettings = @
    {
    AVVideoCodecKey: AVVideoCodecH264,
    AVVideoWidthKey: @480,
    AVVideoHeightKey: @480,
    AVVideoCompressionPropertiesKey: @
        {
        AVVideoAverageBitRateKey: @6000000,
        AVVideoProfileLevelKey: AVVideoProfileLevelH264High40,
        },
    };
    
    encoder.audioSettings = @
    {
    AVFormatIDKey: @(kAudioFormatMPEG4AAC),
    AVNumberOfChannelsKey: @1,
    AVSampleRateKey: @44100,
    AVEncoderBitRateKey: @64000,
    };

    encoder.trimEdgeInsets = UIEdgeInsetsMake(top, left, 0, 0);
    
    //
    
    [encoder exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!encoder.error) {
                //upload
                
                [loadingView hide:YES];
                
//                [encoder.outputURL saveToCameraRollWithCompletion:^(NSString * _Nullable path, NSError * _Nullable error) {
//                    NSLog(@"error:%@",error);
//                }];
//                
                
                LLAPickVideoNavigationController *pick = (LLAPickVideoNavigationController *)self.navigationController;
                
                if ([pick isKindOfClass:[LLAPickVideoNavigationController class]]) {
                    
                    [pick dismissViewControllerAnimated:YES completion:^{
                        if (pick.videoPickerDelegate && [pick.videoPickerDelegate respondsToSelector:@selector(videoPicker:didFinishPickVideo:thumbImage:)]) {
                            [pick.videoPickerDelegate videoPicker:pick didFinishPickVideo:encoder.outputURL thumbImage:thumbImage];
                        }
                    }];
                }

                
            }else {
                //NSLog(@"exportError:%@",encoder.error);
                [loadingView hide:YES];
                [LLAViewUtil showAlter:self.view withText:encoder.error.localizedDescription];
            }

        });
    }];
    
}

#pragma mark - SCVideoPlayerViewDelegate

- (void)videoPlayerViewTappedToPlay:(SCVideoPlayerView *__nonnull)playerView {
    //[[playerView player] play];
    playPauseButton.hidden = YES;
    
    if (CMTimeGetSeconds(playerView.player.currentTime) < CMTimeGetSeconds(playerView.player.currentItem.duration)*editProgressView.editBeginRatio) {
        
        [playerView.player seekToTime:CMTimeMake(editProgressView.editBeginRatio*CMTimeGetSeconds(playerView.player.currentItem.duration), 1) completionHandler:^(BOOL finished) {
            
        }];
    }
    
    if (CMTimeGetSeconds(playerView.player.currentTime) > CMTimeGetSeconds(playerView.player.currentItem.duration) * editProgressView.editEndRatio) {
        
        [playerView.player pause];
        
        [playerView.player seekToTime:CMTimeMake(editProgressView.editEndRatio*CMTimeGetSeconds(playerView.player.currentItem.duration), 1) completionHandler:^(BOOL finished) {
            
        }];
    }
    
}

- (void)videoPlayerViewTappedToPause:(SCVideoPlayerView *__nonnull)playerView {
    //[[playerView player] pause];
    playPauseButton.hidden = NO;
}

#pragma mark - SCPlayerDelegate

/**
 Called when the player has played some frames. The loopsCount will contains the number of
 loop if the curent item was set using setSmoothItem.
 */
- (void)player:(SCPlayer *__nonnull)player didPlay:(CMTime)currentTime loopsCount:(NSInteger)loopsCount {
    
    if (CMTimeGetSeconds(currentTime) < CMTimeGetSeconds(player.currentItem.duration)*editProgressView.editBeginRatio) {
        
        [player seekToTime:CMTimeMake(editProgressView.editBeginRatio*CMTimeGetSeconds(player.currentItem.duration), 1) completionHandler:^(BOOL finished) {
            
        }];
    }
    
    if (CMTimeGetSeconds(currentTime) > CMTimeGetSeconds(player.currentItem.duration) * editProgressView.editEndRatio) {
        
        [player pause];
        
        [player seekToTime:CMTimeMake(editProgressView.editEndRatio*CMTimeGetSeconds(player.currentItem.duration), 1) completionHandler:^(BOOL finished) {
            
        }];
    }
    
}

/**
 Called when the item has reached end
 */
- (void)player:(SCPlayer *__nonnull)player didReachEndForItem:(AVPlayerItem *__nonnull)item {
    
    //if (player.isPlaying) {
        //seek to cutting time
    
    
        [player seekToTime:CMTimeMake(editProgressView.editBeginRatio*CMTimeGetSeconds(item.duration), 1) completionHandler:^(BOOL finished) {
            
        }];
    
//    }else {
        playPauseButton.hidden = NO;
//    }
    
    
}

#pragma mark - LLAEditVideoProgressViewDelegate

- (void) progressView:(LLAEditVideoProgressView *)progressView didEndEditBeginRatio:(CGFloat)beginRatio {
    
    //seek to begin
    [self seekPlayerToBeginRatio];
    
}

- (void) progressView:(LLAEditVideoProgressView *)progressView didChangeBeginRatio:(CGFloat)beginRatio {
    
    [self seekPlayerToBeginRatio];
    
}

- (void) progressView:(LLAEditVideoProgressView *)progressView didChangeEndRatio:(CGFloat)endRatio {
    
    [self seekPlayerToEndRatio];
}

- (void) progressView:(LLAEditVideoProgressView *)progressView didEndEditEndRatio:(CGFloat)endRatio {
    //seek to begin
    [self seekPlayerToBeginRatio];
}

#pragma mark - Private Method

/**
 **/

- (void) seekPlayerToBeginRatio {
    if ([videoPlayerView.player isPlaying]) {
        [videoPlayerView.player pause];
        playPauseButton.hidden = NO;
        
    }
    //seek to time
    
    [videoPlayerView.player seekToTime:CMTimeMake(editProgressView.editBeginRatio*CMTimeGetSeconds(videoPlayerView.player.currentItem.duration), 1) completionHandler:^(BOOL finished) {
        
    }];
}

- (void) seekPlayerToEndRatio {
    if ([videoPlayerView.player isPlaying]) {
        [videoPlayerView.player pause];
        playPauseButton.hidden = NO;
    }
    //seek to time
    
    [videoPlayerView.player seekToTime:CMTimeMake(editProgressView.editEndRatio*CMTimeGetSeconds(videoPlayerView.player.currentItem.duration), 1) completionHandler:^(BOOL finished) {
        
    }];

}


@end
