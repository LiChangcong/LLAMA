//
//  LLAChatInpuFunctionView.m
//  LLama
//
//  Created by Live on 16/2/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAChatInpuFunctionView.h"

static NSString *const recordImage_Normal = @"message_Input_Record_Voice_Normal";
static NSString *const recordImage_Highlight = @"message_Input_Record_Voice_Highlight";

static NSString *const pickPhotosImage_Normal = @"message_Input_Pick_Photos_Normal";
static NSString *const pickPhotosImage_Highlight = @"message_Input_Pick_Photos_Highlight";

static NSString *const cameraImage_Normal = @"message_Input_Pick_Camera_Normal";
static NSString *const cameraImage_Highlight = @"message_Input_Pick_Camera_Highlight";

static NSString *const emojiImage_Normal = @"message_Input_Emoji_Normal";
static NSString *const emojiImage_Highlight = @"message_Input_Emoji_Highlight";

@interface LLAChatInpuFunctionView()
{

}

@property(nonatomic , readwrite , strong) UIButton *recordVoiceButton;
@property(nonatomic , readwrite , strong) UIButton *pickPhotoButton;
@property(nonatomic , readwrite , strong) UIButton *cameraButton;
@property(nonatomic , readwrite , strong) UIButton *emojiButton;


@end

@implementation LLAChatInpuFunctionView

@synthesize delegate;

@synthesize recordVoiceButton,pickPhotoButton,cameraButton,emojiButton;

#pragma mark - Init

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void) commonInit {
    [self initVariables];
    [self initSubViews];
    [self initSubConstraints];
}

- (void) initVariables {
    
}

- (void) initSubViews {
    recordVoiceButton = [[UIButton alloc] init];
    recordVoiceButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [recordVoiceButton setImage:[UIImage imageNamed:recordImage_Normal] forState:UIControlStateNormal];
    [recordVoiceButton setImage:[UIImage imageNamed:recordImage_Highlight] forState:UIControlStateHighlighted];
    [recordVoiceButton setImage:[UIImage imageNamed:recordImage_Highlight] forState:UIControlStateSelected];
    
    [recordVoiceButton addTarget:self action:@selector(recordVoiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:recordVoiceButton];
    
    //
    pickPhotoButton = [[UIButton alloc] init];
    pickPhotoButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [pickPhotoButton setImage:[UIImage imageNamed:pickPhotosImage_Normal] forState:UIControlStateNormal];
    [pickPhotoButton setImage:[UIImage imageNamed:pickPhotosImage_Highlight] forState:UIControlStateHighlighted];
    [pickPhotoButton setImage:[UIImage imageNamed:pickPhotosImage_Highlight] forState:UIControlStateSelected];
    
    [pickPhotoButton addTarget:self action:@selector(pickPhotosButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:pickPhotoButton];
    
    cameraButton = [[UIButton alloc] init];
    cameraButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [cameraButton setImage:[UIImage imageNamed:cameraImage_Normal] forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:cameraImage_Highlight] forState:UIControlStateHighlighted];
    [cameraButton setImage:[UIImage imageNamed:cameraImage_Highlight] forState:UIControlStateSelected];
    
    [cameraButton addTarget:self action:@selector(cameraButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:cameraButton];
    
    emojiButton = [[UIButton alloc] init];
    emojiButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [emojiButton setImage:[UIImage imageNamed:emojiImage_Normal] forState:UIControlStateNormal];
    [emojiButton setImage:[UIImage imageNamed:emojiImage_Highlight] forState:UIControlStateHighlighted];
    [emojiButton setImage:[UIImage imageNamed:emojiImage_Highlight] forState:UIControlStateSelected];
    
    [emojiButton addTarget:self action:@selector(emojiButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:emojiButton];

}

- (void) initSubConstraints {
    
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:recordVoiceButton
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:self
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:pickPhotoButton
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:self
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];

    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:cameraButton
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:self
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];

    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:emojiButton
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:self
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];
    
    //horizonal
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:recordVoiceButton
      attribute:NSLayoutAttributeCenterX
      relatedBy:NSLayoutRelationEqual
      toItem:self
      attribute:NSLayoutAttributeCenterX
      multiplier:0.25
      constant:0]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:pickPhotoButton
      attribute:NSLayoutAttributeCenterX
      relatedBy:NSLayoutRelationEqual
      toItem:self
      attribute:NSLayoutAttributeCenterX
      multiplier:0.75
      constant:0]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:cameraButton
      attribute:NSLayoutAttributeCenterX
      relatedBy:NSLayoutRelationEqual
      toItem:self
      attribute:NSLayoutAttributeCenterX
      multiplier:1.25
      constant:0]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:emojiButton
      attribute:NSLayoutAttributeCenterX
      relatedBy:NSLayoutRelationEqual
      toItem:self
      attribute:NSLayoutAttributeCenterX
      multiplier:1.75
      constant:0]];


    [self addConstraints:constrArray];

}

#pragma mark - Button Clicked

- (void) recordVoiceButtonClicked:(UIButton *) sender {
    
//    if (recordVoiceButton.isSelected) {
//        return;
//    }
    
    emojiButton.selected = NO;
    recordVoiceButton.selected = YES;
    
    if (delegate && [delegate respondsToSelector:@selector(recordVoiceWithFunctionView:)]) {
        [delegate recordVoiceWithFunctionView:self];
    }
    
}

- (void) pickPhotosButtonClicked:(UIButton *) sender {
    
    if (delegate && [delegate respondsToSelector:@selector(pickImageWithFunctionView:)]) {
        [delegate pickImageWithFunctionView:self];
    }
    
}

- (void) cameraButtonClicked:(UIButton *) sender {
    
    if (delegate && [delegate respondsToSelector:@selector(takePhotoWithFunctionView:)]) {
        [delegate takePhotoWithFunctionView:self];
    }
}

- (void) emojiButtonClicked:(UIButton *) sender {
//    if (emojiButton.isSelected) {
//        return;
//    }
    
    emojiButton.selected = YES;
    recordVoiceButton.selected = NO;
    pickPhotoButton.selected = NO;
    cameraButton.selected = NO;
    
    if (delegate && [delegate respondsToSelector:@selector(showEmojiWithFunctionView:)]) {
        [delegate showEmojiWithFunctionView:self];
    }
}

#pragma mark - 

- (void) deselectAllButtons {
    recordVoiceButton.selected = NO;
    pickPhotoButton.selected = NO;
    cameraButton.selected = NO;
    emojiButton.selected = NO;
}

#pragma mark - CalculateHeight

+ (CGFloat) calculateHeight {
    return 40;
}


@end
