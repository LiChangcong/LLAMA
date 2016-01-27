//
//  LLACaptureVideoViewController.m
//  LLama
//
//  Created by Live on 16/1/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

//controller
#import "LLACaptureVideoViewController.h"

//view
#import "LLACaptureVideoToolBar.h"
#import "LLACaptureVideoProgressView.h"

//model
#import "LLACaptureVideoClipInfo.h"

//util
#import "SCRecorder.h"

static const CGFloat topBarHeight = 44;
static const CGFloat progressViewHeight = 6;

static const CGFloat deleteButtonToLeft = 38;
static const CGFloat editButtonToRight = 38;

//
static NSString *const deleteButtonImageName_Normal = @"";
static NSString *const deleteButtonImageName_Highlight = @"";
static NSString *const deleteButtonImageName_Disable = @"";

static NSString *const recordButtonImageName_Normal = @"";
static NSString *const recordButtonImageName_Highlight = @"";

static NSString *const editVideoButtonImageName_Normal = @"";
static NSString *const editVideoButtonImageName_Highlight = @"";

@interface LLACaptureVideoViewController()<LLACaptureVideoToolBarDelegate>
{
    LLACaptureVideoToolBar *topBar;
    
    UIView *videoPreView;
    LLACaptureVideoProgressView *recordProgressView;
    
    UIButton *deleteClipButton;
    UIButton *pressToRecordButton;
    UIButton *videoEditButton;
    
}

@end

@implementation LLACaptureVideoViewController

#pragma mark - Life Cycle

- (void) viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
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
    
    [self.view addSubview:videoEditButton];
    
    
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
      constraintsWithVisualFormat:@"H:|-(deleteButtonToLeft)-[deleteClipButton]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toLeft":@(deleteButtonToLeft)}
      views:NSDictionaryOfVariableBindings(deleteClipButton)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[videoEditButton]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toRight":@(editButtonToRight)}
      views:NSDictionaryOfVariableBindings(videoEditButton)]];
    
    [self.view addConstraints:constrArray];

    
}

#pragma mark - Button Clicked

- (void) deleteClipButtonClicked:(UIButton *) sender {
    
}

- (void) recordTouchDown:(UIButton *) sender {
    
}

- (void) recordTouchUp:(UIButton *) sender {
    
}

- (void) videoEditorButtonClicked:(UIButton *) sender {

}




@end
