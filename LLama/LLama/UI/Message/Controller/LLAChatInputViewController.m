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
#import "LLAChatInputPickerEmojiView.h"

static const CGFloat inputTextViewToTop = 5;
static const CGFloat inputTextViewMinHeight = 34;

static const CGFloat inputTextViewToHorBorder = 8;

static const CGFloat tapToRecordButtonToTop = 5;
static const CGFloat tapToRecordButtonHeight = 30;

static const CGFloat tapToRecordButtonToHorBorder = 8;

@interface LLAChatInputViewController()<LLAChatInpuFunctionViewDelegate,HPGrowingTextViewDelegate,LLAChatInputPickerEmojiViewDelegate>
{
    UIButton *tapToRecordButton;
    
    HPGrowingTextView *inputTextView;
    
    LLAChatInpuFunctionView *functionView;
    
    UIView *functionContentView;
    
    //
    UIFont *inputTextViewFont;
    UIColor *inputTextViewTextColor;
    UIColor *inputTextViewTintColor;
    
    UIFont *tapToRecordButtonFont;
    UIColor *tapToRecordButtonNormalTextColor;
    UIColor *tapToRecordButtonHighlightTextColor;
    
    
}

@property(nonatomic , strong) LLAChatInputPickerEmojiView *emojiPickerView;

@end

@implementation LLAChatInputViewController

@synthesize delegate;

#pragma mark - Life Cycle

- (void) viewDidLoad {
    
    [super viewDidLoad];
    //
    [self initVariables];
    [self initSubViews];
    [self initConstraints];
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
    
    inputTextViewFont = [UIFont llaFontOfSize:14];
    inputTextViewTextColor = [UIColor colorWithHex:0x11111e];
    inputTextViewTintColor = [UIColor themeColor];
    
    tapToRecordButtonFont = [UIFont llaFontOfSize:14];
    tapToRecordButtonNormalTextColor = [UIColor themeColor];
    tapToRecordButtonHighlightTextColor = [UIColor themeColor];

    
}

- (void) initSubViews {
    
    inputTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-2*inputTextViewToHorBorder, inputTextViewMinHeight)];
    inputTextView.translatesAutoresizingMaskIntoConstraints = NO;
    inputTextView.clipsToBounds = YES;
    inputTextView.layer.cornerRadius = 6;
    inputTextView.textColor = inputTextViewTextColor;
    inputTextView.font = inputTextViewFont;
    inputTextView.internalTextView.tintColor = inputTextViewTintColor;
    inputTextView.minHeight = inputTextViewMinHeight;
    inputTextView.maxNumberOfLines = 5;
    inputTextView.delegate = self;
    inputTextView.isScrollable = YES;
    
    [self.view addSubview:inputTextView];
    
    //
    tapToRecordButton = [[UIButton alloc] init];
    tapToRecordButton.translatesAutoresizingMaskIntoConstraints = NO;
    tapToRecordButton.titleLabel.font = tapToRecordButtonFont;
    
    tapToRecordButton.clipsToBounds = YES;
    tapToRecordButton.layer.cornerRadius = 6;
    [tapToRecordButton setTitleColor:tapToRecordButtonNormalTextColor forState:UIControlStateNormal];
    [tapToRecordButton setTitleColor:tapToRecordButtonHighlightTextColor forState:UIControlStateHighlighted];
    [tapToRecordButton setTitle:@"按住说话" forState:UIControlStateHighlighted];
    
    [tapToRecordButton addTarget:self action:@selector(tapToRecordTouchDown:) forControlEvents:UIControlEventTouchDown];
    [tapToRecordButton addTarget:self action:@selector(tapToRecordTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:tapToRecordButton];
    
    //
    functionView  = [[LLAChatInpuFunctionView alloc] init];
    functionView.translatesAutoresizingMaskIntoConstraints = NO;
    functionView.delegate = self;
    
    [self.view addSubview:functionView];
    
    functionContentView = [[UIView alloc] init];
    functionContentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:functionContentView];
    
}

- (void) initConstraints {
    
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toTop)-[inputTextView(height)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toTop":@(inputTextViewToTop),
                @"height":@(inputTextViewMinHeight)}
      views:NSDictionaryOfVariableBindings(inputTextView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toTop)-[tapToRecordButton(height)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toTop":@(tapToRecordButtonToTop),
                @"height":@(tapToRecordButtonHeight)}
      views:NSDictionaryOfVariableBindings(tapToRecordButton)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toTop)-[functionView(height)]-(0)-[functionContentView]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toTop":@(inputTextViewMinHeight+inputTextViewToTop),
                @"height":@([LLAChatInpuFunctionView calculateHeight])}
      views:NSDictionaryOfVariableBindings(functionView,functionContentView)]];
    
    //horizonal
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toBorder)-[inputTextView]-(toBorder)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toBorder":@(inputTextViewToHorBorder)}
      views:NSDictionaryOfVariableBindings(inputTextView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toBorder)-[tapToRecordButton]-(toBorder)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toBorder":@(tapToRecordButtonToHorBorder)}
      views:NSDictionaryOfVariableBindings(tapToRecordButton)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[functionView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(functionView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[functionContentView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(functionContentView)]];
    
    [self.view addConstraints:constrArray];

    
}

#pragma mark - getter

- (LLAChatInputPickerEmojiView *) emojiPickerView {
    if (_emojiPickerView) {
        _emojiPickerView = [[LLAChatInputPickerEmojiView alloc] init];
        _emojiPickerView.translatesAutoresizingMaskIntoConstraints = NO;
        _emojiPickerView.delegate = self;
        
        [functionContentView addSubview:_emojiPickerView];
        
        //
        [functionContentView addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|-(0)-[_emojiPickerView]-(0)-|"
          options:NSLayoutFormatDirectionLeadingToTrailing
          metrics:nil
          views:NSDictionaryOfVariableBindings(_emojiPickerView)]];
        
        [functionContentView addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-(0)-[_emojiPickerView]-(0)-|"
          options:NSLayoutFormatDirectionLeadingToTrailing
          metrics:nil
          views:NSDictionaryOfVariableBindings(_emojiPickerView)]];
        
    }
    
    return _emojiPickerView;
}

#pragma mark - Record Button

- (void) tapToRecordTouchDown:(UIButton *) sender {
    
}

- (void) tapToRecordTouchUp:(UIButton *) sender {
    
}

#pragma mark - KeyBoardNotification

- (void) keyboardWillShow:(NSNotification *) noti {
    
}

- (void) keyBoardWillHide:(NSNotification *) noti {
    
}

@end
