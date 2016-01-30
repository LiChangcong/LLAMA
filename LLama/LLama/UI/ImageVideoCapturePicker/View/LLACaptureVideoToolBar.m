//
//  LLACaptureVideoToolBar.m
//  LLama
//
//  Created by Live on 16/1/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLACaptureVideoToolBar.h"

static NSString *const closeButtonImageName_Normal = @"close";
static NSString *const closeButtonImageName_Highlight = @"closeh";

static NSString *const flashModeButtonImageName_Normal = @"lighting";
static NSString *const flashModeButtonImageName_Highlight = @"lightingh";

static NSString *const changeCameraImageName_Normal = @"camerchange";
static NSString *const changeCameraImageName_Highlight = @"camerchangeh";

//
static const CGFloat closeButtonToLeft = 17;

static const CGFloat changeCameraToRight = 17;
static const CGFloat flashModeToChangeCameraHorSpace = 17;

@interface LLACaptureVideoToolBar()
{
    UIButton *closeCaptureButton;
    
    UIButton *flashModeButton;
    UIButton *changeCameraButton;
    
    //
    UIColor *backColor;
}

@end

@implementation LLACaptureVideoToolBar

@synthesize delegate;

#pragma mark - Init

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initVariables];
        [self initSubViews];
        [self initSubContraints];
        self.backgroundColor = backColor;
    }
    return self;
}

- (void) initVariables {
    backColor = [UIColor colorWithHex:0x202031];
}

- (void) initSubViews {
    
    closeCaptureButton = [[UIButton alloc] init];
    closeCaptureButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [closeCaptureButton setImage:[UIImage llaImageWithName:closeButtonImageName_Normal] forState:UIControlStateNormal];
    [closeCaptureButton setImage:[UIImage llaImageWithName:closeButtonImageName_Highlight] forState:UIControlStateHighlighted];
    
    [closeCaptureButton addTarget:self action:@selector(closeCapture:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:closeCaptureButton];
    //
    
    flashModeButton = [[UIButton alloc] init];
    flashModeButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [flashModeButton setImage:[UIImage llaImageWithName:flashModeButtonImageName_Normal] forState:UIControlStateNormal];
    [flashModeButton setImage:[UIImage llaImageWithName:flashModeButtonImageName_Highlight] forState:UIControlStateHighlighted];
    
    [flashModeButton addTarget:self action:@selector(flashModeClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:flashModeButton];
    
    //
    changeCameraButton = [[UIButton alloc] init];
    changeCameraButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [changeCameraButton setImage:[UIImage llaImageWithName:changeCameraImageName_Normal] forState:UIControlStateNormal];
    [changeCameraButton setImage:[UIImage llaImageWithName:changeCameraImageName_Highlight] forState:UIControlStateHighlighted];
    
    [changeCameraButton addTarget:self action:@selector(changeCamera:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:changeCameraButton];


    
}

- (void) initSubContraints {
    //
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:closeCaptureButton
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:self
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:flashModeButton
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:self
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:changeCameraButton
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:self
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];
    
    //vertical
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[closeCaptureButton]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toLeft":@(closeButtonToLeft)}
      views:NSDictionaryOfVariableBindings(closeCaptureButton)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[flashModeButton]-(flashToCamera)-[changeCameraButton]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toRight":@(changeCameraToRight),
                @"flashToCamera":@(flashModeToChangeCameraHorSpace)}
      views:NSDictionaryOfVariableBindings(flashModeButton,changeCameraButton)]];
    
    [self addConstraints:constrArray];
    
}

#pragma mark - button click

- (void) closeCapture:(UIButton *) sender {
    if (delegate && [delegate respondsToSelector:@selector(closeCapture)]) {
        [delegate closeCapture];
    }
}

- (void) flashModeClicked:(UIButton *) sender {
    if (delegate && [delegate respondsToSelector:@selector(changeflashMode)]) {
        [delegate changeflashMode];
    }
}

- (void) changeCamera:(UIButton *) sender {
    if (delegate && [delegate respondsToSelector:@selector(changeCamera)]) {
        [delegate changeCamera];
    }
}

@end
