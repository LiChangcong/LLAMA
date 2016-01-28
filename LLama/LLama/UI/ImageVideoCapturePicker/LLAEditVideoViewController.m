//
//  LLAEditVideoViewController.m
//  LLama
//
//  Created by Live on 16/1/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

//controller
#import "LLAEditVideoViewController.h"

//view
#import "LLAEditVideoTopToolBar.h"
#import "LLAEditVideoProgressView.h"

//model

//util
#import "SCVideoPlayerView.h"

static const CGFloat topBarHeight = 80;

@interface LLAEditVideoViewController()<LLAEditVideoTopToolBarDelegate,SCVideoPlayerViewDelegate>
{
    AVAsset *editAsset;
    
    LLAEditVideoTopToolBar *topBar;
    
    SCVideoPlayerView *videoPlayerView;
    
    LLAEditVideoProgressView *editProgressView;
    
    
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
    [videoPlayerView.player play];
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
    
    [self.view addSubview:videoPlayerView];
    
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
    
    [self.view addConstraints:constrArray];
    
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
    
}

#pragma mark - SCVideoPlayerViewDelegate

- (void)videoPlayerViewTappedToPlay:(SCVideoPlayerView *__nonnull)playerView {
    
}

- (void)videoPlayerViewTappedToPause:(SCVideoPlayerView *__nonnull)playerView {
    
}

#pragma mark - Pangesture

@end
