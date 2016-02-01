//
//  LLACaptureVideoViewController.m
//  LLama
//
//  Created by Live on 16/1/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

//controller
#import "LLACaptureVideoViewController.h"
#import "LLAEditVideoViewController.h"
#import "LLAVideoPickerViewController.h"

//view
#import "LLACaptureVideoToolBar.h"
#import "LLACaptureVideoProgressView.h"

//model
#import "LLACaptureVideoClipInfo.h"

//util
#import "SCRecorder.h"

static const CGFloat minVideoSecond = 5.0;
static const CGFloat maxVideoSecond = 60.0;

//
static const CGFloat topBarHeight = 44;
static const CGFloat progressViewHeight = 6;

static const CGFloat deleteButtonToLeft = 38;
static const CGFloat editButtonToRight = 38;

//
static NSString *const deleteButtonImageName_Normal = @"cancelvideo";
static NSString *const deleteButtonImageName_Highlight = @"cancelvideoh";
static NSString *const deleteButtonImageName_Disable = @"cancelvideoh";

static NSString *const recordButtonImageName_Normal = @"startvideo";
static NSString *const recordButtonImageName_Highlight = @"startvideoh";

static NSString *const editVideoButtonImageName_Normal = @"finishedvideo";
static NSString *const editVideoButtonImageName_Highlight = @"finishedvideo";

static NSString *const chooseVideoButtonImageName_Normal = @"chosevideo";
static NSString *const chooseVideoButtonImageName_Highlight = @"chosevideoh";

static NSString *const recordFoucusImageName = @"";

@interface LLACaptureVideoViewController()<LLACaptureVideoToolBarDelegate,SCRecorderDelegate>
{
    LLACaptureVideoToolBar *topBar;
    
    UIView *videoPreView;
    LLACaptureVideoProgressView *recordProgressView;
    
    UIButton *deleteClipButton;
    UIButton *pressToRecordButton;
    UIButton *videoEditButton;
    
    UIButton *chooseVideoButton;
    
    //av recorder
    SCRecorder *shareRecorder;
}

@end

@implementation LLACaptureVideoViewController

#pragma mark - Life Cycle

- (void) dealloc {
    shareRecorder.previewView = nil;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:0x202031];
    
    //check auth
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        
        if (!granted) {
            //
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"没有访问相机的权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            });

        }
    }];
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        
        if (!granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"没有访问麦克风的权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];

            });
        }
        
    }];
    
    //
    [self initVariables];
    [self initTopBars];
    [self initSubViews];
    [self initConstraints];
    [self initialiseRecorder];
    
    [recordProgressView startBlinkIndicator];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [shareRecorder previewViewFrameChanged];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self prepareRecordSession];

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //
    [shareRecorder startRunning];
    
    //
    if (!shareRecorder.previewView) {
        shareRecorder.previewView = videoPreView;
    }
    
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
 
    [shareRecorder stopRunning];
}

#pragma mark - Init

- (void) initVariables {
    
}

- (void) initTopBars {
    
    topBar = [[LLACaptureVideoToolBar alloc] init];
    topBar.translatesAutoresizingMaskIntoConstraints = NO;
    topBar.delegate = self;
    
    [self.view addSubview:topBar];
    
}

- (void) initSubViews {
    
    videoPreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    videoPreView.translatesAutoresizingMaskIntoConstraints = NO;
    videoPreView.backgroundColor = [UIColor blackColor];
    videoPreView.userInteractionEnabled = YES;
    [self.view addSubview:videoPreView];
    
    //
    recordProgressView = [[LLACaptureVideoProgressView alloc] init];
    recordProgressView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:recordProgressView];
    
    //
    deleteClipButton = [[UIButton alloc] init];
    deleteClipButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [deleteClipButton setImage:[UIImage llaImageWithName:deleteButtonImageName_Normal] forState:UIControlStateNormal];
    [deleteClipButton setImage:[UIImage llaImageWithName:deleteButtonImageName_Highlight] forState:UIControlStateHighlighted];
    [deleteClipButton setImage:[UIImage llaImageWithName:deleteButtonImageName_Disable] forState:UIControlStateDisabled];
    [deleteClipButton addTarget:self action:@selector(deleteClipButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:deleteClipButton];
    
    //
    pressToRecordButton = [[UIButton alloc] init];
    pressToRecordButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [pressToRecordButton setImage:[UIImage llaImageWithName:recordButtonImageName_Normal] forState:UIControlStateNormal];
    
    [pressToRecordButton setImage:[UIImage llaImageWithName:recordButtonImageName_Highlight] forState:UIControlStateHighlighted];
    
    [pressToRecordButton addTarget:self action:@selector(recordTouchDown:) forControlEvents:UIControlEventTouchDown];
    [pressToRecordButton addTarget:self action:@selector(recordTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pressToRecordButton];
    
    //
    videoEditButton = [[UIButton alloc] init];
    videoEditButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [videoEditButton setImage:[UIImage llaImageWithName:editVideoButtonImageName_Normal] forState:UIControlStateNormal];
    [videoEditButton setImage:[UIImage llaImageWithName:editVideoButtonImageName_Highlight] forState:UIControlStateHighlighted];
    
    [videoEditButton addTarget:self action:@selector(videoEditorButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    videoEditButton.hidden = YES;
    videoEditButton.enabled = NO;
    [self.view addSubview:videoEditButton];
    
    //
    chooseVideoButton = [[UIButton alloc] init];
    chooseVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [chooseVideoButton setImage:[UIImage llaImageWithName:chooseVideoButtonImageName_Normal] forState:UIControlStateNormal];
    [chooseVideoButton setImage:[UIImage llaImageWithName:chooseVideoButtonImageName_Highlight] forState:UIControlStateHighlighted];
    
    [chooseVideoButton addTarget:self action:@selector(chooseVideoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:chooseVideoButton];
    
    
    
    
}

- (void) initConstraints {
    //
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[topBar(topHeight)]-(0)-[videoPreView(preViewHeight)]-(0)-[recordProgressView(progressHeight)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"topHeight":@(topBarHeight),
                @"preViewHeight":@(self.view.frame.size.width),
                @"progressHeight":@(progressViewHeight)}
      views:NSDictionaryOfVariableBindings(topBar,videoPreView,recordProgressView)]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:deleteClipButton
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:self.view
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:(topBarHeight+self.view.frame.size.width)/2]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:pressToRecordButton
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:self.view
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:(topBarHeight+self.view.frame.size.width)/2]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:videoEditButton
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:self.view
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:(topBarHeight+self.view.frame.size.width)/2]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:chooseVideoButton
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:self.view
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:(topBarHeight+self.view.frame.size.width)/2]];
    
    //horizonal
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[topBar]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(topBar)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[videoPreView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(videoPreView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[recordProgressView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(recordProgressView)]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:pressToRecordButton
      attribute:NSLayoutAttributeCenterX
      relatedBy:NSLayoutRelationEqual
      toItem:self.view
      attribute:NSLayoutAttributeCenterX
      multiplier:1.0
      constant:0]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[deleteClipButton]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toLeft":@(deleteButtonToLeft)}
      views:NSDictionaryOfVariableBindings(deleteClipButton)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[videoEditButton]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toRight":@(editButtonToRight)}
      views:NSDictionaryOfVariableBindings(videoEditButton)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[chooseVideoButton]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toRight":@(editButtonToRight)}
      views:NSDictionaryOfVariableBindings(chooseVideoButton)]];

    
    [self.view addConstraints:constrArray];

    
}

- (void) initialiseRecorder {
    
    shareRecorder = [SCRecorder sharedRecorder];
    shareRecorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
    shareRecorder.delegate = self;
    
//    //video configuration
    SCVideoConfiguration *videoConfig = shareRecorder.videoConfiguration;
    
//    videoConfig.size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
    videoConfig.bitrate = 900000;
    videoConfig.maxFrameRate = 30;
    //videoConfig.timeScale = 400;
    //videoConfig.filter = [SCFilter emptyFilter];
//    //videoConfig.filter = [SCFilter filterWithCIFilterName:@"CIPhotoEffectInstant"];
    videoConfig.enabled = YES;
    videoConfig.scalingMode = AVVideoScalingModeResizeAspectFill;
    videoConfig.sizeAsSquare = YES;
//
//    
//    //audio configuration
//    
    SCAudioConfiguration *audioConfig = shareRecorder.audioConfiguration;
    
    audioConfig.enabled = YES;
    audioConfig.bitrate = 48000;
    audioConfig.channelsCount = 1;
    audioConfig.sampleRate = 0;
    
    //preview
    
    //shareRecorder.previewView = videoPreView;
    
    //focus view
    SCRecorderToolsView *focusView = [[SCRecorderToolsView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
    focusView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    focusView.recorder = shareRecorder;
    
    focusView.outsideFocusTargetImage = [UIImage imageNamed:recordFoucusImageName];
    focusView.insideFocusTargetImage = [UIImage imageNamed:recordFoucusImageName];
    
    [videoPreView addSubview:focusView];
    
    if (!shareRecorder.isPrepared) {
        NSError *error;
        if (![shareRecorder prepare:&error]) {
            NSLog(@"Prepare error: %@", error.localizedDescription);
        }

    }
    

}

#pragma mark - Button Clicked

- (void) deleteClipButtonClicked:(UIButton *) sender {
    
    if (shareRecorder.isRecording) {
        return;
    }
    
    [recordProgressView deleteVideoClipInfo:^(BOOL hasDelete) {
        if (hasDelete) {
            //remove last
            if (hasDelete){
                [shareRecorder.session removeLastSegment];
                
                if (CMTimeGetSeconds(shareRecorder.session.duration) >= minVideoSecond) {
                    videoEditButton.enabled = YES;
                    videoEditButton.selected = YES;
                    
                    chooseVideoButton.hidden = YES;
                }else {
                    chooseVideoButton.hidden = NO;
                    videoEditButton.enabled = NO;
                    videoEditButton.hidden = YES;
                }
                
            }
        }
    }];
}

- (void) recordTouchDown:(UIButton *) sender {
    //begin record
    [shareRecorder record];
    
    [recordProgressView addVideoClipInfo];
    [recordProgressView stopBlinkIndicator];
    
    videoEditButton.hidden = NO;
    chooseVideoButton.hidden = YES;
    
}

- (void) recordTouchUp:(UIButton *) sender {
    //stop
    [shareRecorder pause];
    
    [recordProgressView startBlinkIndicator];
    
    //
    if (CMTimeGetSeconds(shareRecorder.session.duration) >= minVideoSecond) {
        videoEditButton.enabled = YES;
        videoEditButton.selected = YES;
        
        chooseVideoButton.hidden = YES;
    }else {
        chooseVideoButton.hidden = NO;
        videoEditButton.enabled = NO;
        videoEditButton.hidden = YES;
    }

    
}

- (void) videoEditorButtonClicked:(UIButton *) sender {
    //export
    
    [shareRecorder pause];
    
    LLAEditVideoViewController *editVideo = [[LLAEditVideoViewController alloc] initWithAVAsset:shareRecorder.session.assetRepresentingSegments];
    
    [self.navigationController pushViewController:editVideo animated:YES];
   
}

- (void) chooseVideoButtonClicked:(UIButton *) sender {
    [shareRecorder pause];
    
    LLAVideoPickerViewController *videoPicker = [[LLAVideoPickerViewController alloc] init];
    [self.navigationController pushViewController:videoPicker animated:YES];
}

#pragma mark - Status Bar Style

- (BOOL) prefersStatusBarHidden {
    return YES;
}

#pragma mark - Private Method

- (void) prepareRecordSession {
    if (shareRecorder.session == nil) {
        SCRecordSession *session = [SCRecordSession recordSession];
        session.fileType = AVFileTypeMPEG4;
        
        shareRecorder.session = session;
    }
}

#pragma mark - LLACaptureVideoToolBarDelegate

- (void) closeCapture {
    
    [recordProgressView stopBlinkIndicator];
    [shareRecorder.session removeAllSegments:YES];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void) changeflashMode {
    if (shareRecorder.flashMode == SCFlashModeOff) {
        shareRecorder.flashMode = SCFlashModeLight;
    }else if (shareRecorder.flashMode == SCFlashModeLight) {
        shareRecorder.flashMode = SCFlashModeOff;
    }
}

- (void) changeCamera {
    
    shareRecorder.flashMode = SCFlashModeOff;
    [shareRecorder switchCaptureDevices];
    
}

#pragma mark - SCShareRecorderDelegate

- (void)recorder:(SCRecorder *)recorder didCompleteSession:(SCRecordSession *)recordSession {
    //NSLog(@"didCompleteSession:");
    
}

- (void)recorder:(SCRecorder *)recorder didInitializeAudioInSession:(SCRecordSession *)recordSession error:(NSError *)error {
    if (error == nil) {
        //NSLog(@"Initialized audio in record session");
    } else {
        //NSLog(@"Failed to initialize audio in record session: %@", error.localizedDescription);
    }
}

- (void)recorder:(SCRecorder *)recorder didInitializeVideoInSession:(SCRecordSession *)recordSession error:(NSError *)error {
    if (error == nil) {
        //NSLog(@"Initialized video in record session");
    } else {
       // NSLog(@"Failed to initialize video in record session: %@", error.localizedDescription);
    }
}

- (void)recorder:(SCRecorder *)recorder didBeginSegmentInSession:(SCRecordSession *)recordSession error:(NSError *)error {
    //NSLog(@"Began record segment: %@", error);
}

- (void)recorder:(SCRecorder *)recorder didCompleteSegment:(SCRecordSessionSegment *)segment inSession:(SCRecordSession *)recordSession error:(NSError *)error {
    //NSLog(@"Completed record segment at %@: %@ (frameRate: %f)", segment.url, error, segment.frameRate);
    
}

- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBufferInSession:(SCRecordSession *)recordSession {
    
    if (CMTimeGetSeconds(recordSession.duration) >= minVideoSecond) {
        videoEditButton.enabled = YES;
        videoEditButton.selected = YES;
        
        chooseVideoButton.hidden = YES;
    }
    
    [recordProgressView updateLastVideoClipInfoWithNewDuration:CMTimeGetSeconds(recordSession.currentSegmentDuration)];
}



@end
