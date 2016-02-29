//
//  LLAChatInputViewController.m
//  LLama
//
//  Created by Live on 16/2/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAChatInputViewController.h"

//view
#import "LLAChatInpuFunctionView.h"
#import "HPGrowingTextView.h"

@interface LLAChatInputViewController()<LLAChatInpuFunctionViewDelegate>
{
    UIButton *tapToRecordButton;
    
    HPGrowingTextView *inputViewTextView;
    
    LLAChatInpuFunctionView *functioView;
    
    UIView *functionContentView;
}

@end

@implementation LLAChatInputViewController

#pragma mark - Life Cycle

- (void) viewDidLoad {
    
    [super viewDidLoad];
    //
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //add keyboardObserver
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //removeboardObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Init

- (void) initVariables {
    
}

- (void) initSubViews {
    
}

#pragma mark - KeyBoardNotification

- (void) keyboardWillShow:(NSNotification *) noti {
    
}

- (void) keyBoardWillHide:(NSNotification *) noti {
    
}

@end
