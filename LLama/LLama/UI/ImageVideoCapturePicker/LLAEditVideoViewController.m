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

//model

//util
#import "SCVideoPlayerView.h"
#import "SCRecorder.h"
#import "LLAViewUtil.h"

//
#import "LLAUploadFileUtil.h"


static const CGFloat topBarHeight = 70;

static NSString *playPauseButtonImageName_Normal = @"play";
static NSString *playPasueButtonImageName_Highlight = @"playh";

@interface LLAEditVideoViewController()<LLAEditVideoTopToolBarDelegate,SCVideoPlayerViewDelegate,SCPlayerDelegate>
{
    AVAsset *editAsset;
    
    LLAEditVideoTopToolBar *topBar;
    
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
    
    videoPlayerView = [[SCVideoPlayerView alloc] init];
    videoPlayerView.translatesAutoresizingMaskIntoConstraints = NO;
    videoPlayerView.delegate = self;
    videoPlayerView.player.delegate = self;
    videoPlayerView.tapToPauseEnabled = YES;
    
    [self.view addSubview:videoPlayerView];
    
    playPauseButton = [[UIButton alloc] init];
    playPauseButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [playPauseButton setImage:[UIImage llaImageWithName:playPauseButtonImageName_Normal] forState:UIControlStateNormal];
    [playPauseButton setImage:[UIImage llaImageWithName:playPasueButtonImageName_Highlight] forState:UIControlStateHighlighted];
    
    [playPauseButton addTarget:self action:@selector(playPauseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:playPauseButton];
    
    //
    editProgressView = [[LLAEditVideoProgressView alloc] initWithAsset:editAsset];
    editProgressView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:editProgressView];
    
}

- (void) initSubContraints {
    
    //constraints
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[topBar(topBarHeight)]-(0)-[videoPlayerView(playerHeight)]-(0)-[editProgressView(editHeight)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"topBarHeight":@(topBarHeight),
                @"playerHeight":@(self.view.frame.size.width),
                @"editHeight":@(editVideo_progressViewHeight+self.view.frame.size.width/editProgressView.numberOfThumbImages)}
      views:NSDictionaryOfVariableBindings(topBar,videoPlayerView,editProgressView)]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:playPauseButton
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:videoPlayerView
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
      constraintsWithVisualFormat:@"H:|-(0)-[videoPlayerView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(videoPlayerView)]];
    
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
      toItem:videoPlayerView
      attribute:NSLayoutAttributeCenterX
      multiplier:1.0
      constant:0]];

    
    [self.view addConstraints:constrArray];
    
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

#pragma mark - LLAEditVideoTopToolBarDelegate
- (void) backToPre {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) editVideoDone {
    
    //

    
    //edit done,test,upload
    SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:editAsset];
    
    //
    
    CGFloat assetDuration = CMTimeGetSeconds(editAsset.duration);
    
    exportSession.outputUrl = [SCRecorder sharedRecorder].session.outputUrl;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.contextType = SCContextTypeAuto;
    exportSession.videoConfiguration.size = CGSizeMake(480, 480);
    
    //
    
    CMTime startTime = CMTimeMakeWithSeconds(assetDuration*editProgressView.editBeginRatio, editAsset.duration.timescale);
    
    CMTime durationTime = CMTimeMakeWithSeconds(assetDuration*(editProgressView.editEndRatio-editProgressView.editBeginRatio), editAsset.duration.timescale);
    
    exportSession.timeRange = CMTimeRangeMake(startTime, durationTime);
    
    //get thumb image
    
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:editAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    CMTime actualTime;
    
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:startTime actualTime:&actualTime error:nil];
    UIImage *thumbImage = [UIImage imageWithCGImage:cgImage];
    
    LLALoadingView *loadingView = [LLAViewUtil addLLALoadingViewToView:self.view];
    [loadingView show:YES];
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if (!exportSession.error) {
            //upload
            
            [loadingView hide:YES];
            
//            [exportSession.outputUrl saveToCameraRollWithCompletion:^(NSString * _Nullable path, NSError * _Nullable error) {
//                NSLog(@"error:%@",error);
//            }];
            
            LLAPickVideoNavigationController *pick = (LLAPickVideoNavigationController *)self.navigationController;
            
            if ([pick isKindOfClass:[LLAPickVideoNavigationController class]]) {
                
                [pick dismissViewControllerAnimated:YES completion:^{
                    if (pick.videoPickerDelegate && [pick.videoPickerDelegate respondsToSelector:@selector(videoPicker:didFinishPickVideo:thumbImage:)]) {
                        [pick.videoPickerDelegate videoPicker:pick didFinishPickVideo:exportSession.outputUrl thumbImage:thumbImage];
                    }
                }];
            }
            
            
        }else {
            NSLog(@"exportError:%@",exportSession.error);
            [loadingView hide:YES];
        }
    }];
    
}

#pragma mark - SCVideoPlayerViewDelegate

- (void)videoPlayerViewTappedToPlay:(SCVideoPlayerView *__nonnull)playerView {
    //[[playerView player] play];
    playPauseButton.hidden = YES;
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


@end
