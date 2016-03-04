//
//  LLAChatInputViewController.m
//  LLama
//
//  Created by Live on 16/2/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAChatInputViewController.h"
#import "LLAImagePickerViewController.h"

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

@interface LLAChatInputViewController()<LLAChatInpuFunctionViewDelegate,HPGrowingTextViewDelegate,LLAChatInputPickerEmojiViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
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
    UIColor *tapToRecordButtonNormalBKColor;
    
    //nslayoutconstraints
    
    NSLayoutConstraint *inputViewHeightConstraints;
    NSLayoutConstraint *functionViewToTopConstraints;
    NSLayoutConstraint *functionContentViewHeightConstraints;
    
    
}

@property(nonatomic , strong) LLAChatInputPickerEmojiView *emojiPickerView;

@property(nonatomic , assign ,readwrite) LLAChatInputControllerCurrentType  currentInputType;

@end

@implementation LLAChatInputViewController

@synthesize delegate;
@synthesize currentInputType;

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
    
    currentInputType = LLAChatInputControllerCurrentType_InputText;
    
    inputTextViewFont = [UIFont llaFontOfSize:14];
    inputTextViewTextColor = [UIColor colorWithHex:0x11111e];
    inputTextViewTintColor = [UIColor themeColor];
    
    tapToRecordButtonFont = [UIFont llaFontOfSize:14];
    tapToRecordButtonNormalTextColor = [UIColor themeColor];
    tapToRecordButtonHighlightTextColor = [UIColor themeColor];
    tapToRecordButtonNormalBKColor = [UIColor whiteColor];

    
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
    inputTextView.returnKeyType = UIReturnKeySend;
    
    [self.view addSubview:inputTextView];
    
    //
    tapToRecordButton = [[UIButton alloc] init];
    tapToRecordButton.translatesAutoresizingMaskIntoConstraints = NO;
    tapToRecordButton.titleLabel.font = tapToRecordButtonFont;
    tapToRecordButton.hidden = YES;
    
    tapToRecordButton.clipsToBounds = YES;
    tapToRecordButton.layer.cornerRadius = 6;
    [tapToRecordButton setTitleColor:tapToRecordButtonNormalTextColor forState:UIControlStateNormal];
    [tapToRecordButton setTitleColor:tapToRecordButtonHighlightTextColor forState:UIControlStateHighlighted];
    
    [tapToRecordButton setBackgroundColor:tapToRecordButtonNormalBKColor forState:UIControlStateNormal];
    
    [tapToRecordButton setTitle:@"按住说话" forState:UIControlStateNormal];
    
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
      constraintsWithVisualFormat:@"V:|-(toTop)-[functionView(height)]-(0)-[functionContentView(0)]"
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

    //
    for (NSLayoutConstraint *constr in constrArray) {
        if (constr.firstAttribute == NSLayoutAttributeHeight && constr.firstItem == inputTextView) {
            inputViewHeightConstraints = constr;
        }else if (constr.firstAttribute == NSLayoutAttributeTop && constr.firstItem == functionView) {
            functionViewToTopConstraints = constr;
        }else if (constr.firstAttribute == NSLayoutAttributeHeight && constr.firstItem == functionContentView) {
            functionContentViewHeightConstraints = constr;
        }
    }
    
}

#pragma mark - getter

- (LLAChatInputPickerEmojiView *) emojiPickerView {
    if (!_emojiPickerView) {
        _emojiPickerView = [[LLAChatInputPickerEmojiView alloc] init];
        _emojiPickerView.translatesAutoresizingMaskIntoConstraints = NO;
        _emojiPickerView.delegate = self;
        
        [functionContentView addSubview:_emojiPickerView];
        
        //
        [functionContentView addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|-(0)-[_emojiPickerView(height)]"
          options:NSLayoutFormatDirectionLeadingToTrailing
          metrics:@{@"height":@([LLAChatInputPickerEmojiView calculateHeight])}
          views:NSDictionaryOfVariableBindings(_emojiPickerView)]];
        
        [functionContentView addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-(0)-[_emojiPickerView]-(0)-|"
          options:NSLayoutFormatDirectionLeadingToTrailing
          metrics:nil
          views:NSDictionaryOfVariableBindings(_emojiPickerView)]];
        
        [functionContentView layoutIfNeeded];
        
    }
    
    return _emojiPickerView;
}

#pragma mark - LLAChatInpuFunctionViewDelegate

- (void) recordVoiceWithFunctionView:(LLAChatInpuFunctionView *)fnView {
    
    if (currentInputType == LLAChatInputControllerCurrentType_RecordVoice) {
        return;
    }
    
    if (currentInputType == LLAChatInputControllerCurrentType_InputText) {
        
        //
        [inputTextView resignFirstResponder];
        //
        
    }else if (currentInputType == LLAChatInputControllerCurrentType_PickEmoji) {
        //hide emoji pick view
        functionView.emojiButton.selected = NO;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.12];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    functionViewToTopConstraints.constant = tapToRecordButtonHeight + tapToRecordButtonToTop;
    functionContentViewHeightConstraints.constant = 0;
    [self.view layoutIfNeeded];

    [UIView commitAnimations];
    
    if (delegate && [delegate respondsToSelector:@selector(inputViewController:newHeight:duration:animationCurve:)]) {
        [delegate inputViewController:self newHeight:tapToRecordButtonHeight + tapToRecordButtonToTop + [LLAChatInpuFunctionView calculateHeight] duration:0.18 animationCurve:UIViewAnimationCurveEaseInOut];
    }

    
    currentInputType = LLAChatInputControllerCurrentType_RecordVoice;
    
    tapToRecordButton.hidden = NO;
    inputTextView.hidden = YES;
    
    
}

- (void) pickImageWithFunctionView:(LLAChatInpuFunctionView *)functionView  {
    
//    if (currentInputType == LLAChatInputControllerCurrentType_PickPhoto) {
//        return;
//    }
    LLAImagePickerViewController *imagePicker = [[LLAImagePickerViewController alloc] init];
    
    [self.navigationController presentViewController:imagePicker animated:YES completion:^{
        
    }];
    
}

- (void) takePhotoWithFunctionView:(LLAChatInpuFunctionView *)functionView {
    
//    if (currentInputType == LLAChatInputControllerCurrentType_TakePhoto) {
//        return;
//    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    
    [self.navigationController presentViewController:imagePicker animated:YES completion:^{
        
    }];
    
}

- (void) showEmojiWithFunctionView:(LLAChatInpuFunctionView *)functionView {
    if (currentInputType == LLAChatInputControllerCurrentType_PickEmoji) {
        //hide
        return;
    }
    
    if (currentInputType == LLAChatInputControllerCurrentType_InputText) {
        [inputTextView resignFirstResponder];
    }
    
    [UIView animateWithDuration:0.12 animations:^{
        functionViewToTopConstraints.constant = inputTextViewToTop + inputTextView.bounds.size.height;
        functionContentViewHeightConstraints.constant = [LLAChatInputPickerEmojiView calculateHeight];
        [self.view layoutIfNeeded];
    }];
    self.emojiPickerView.hidden = NO;
    if (delegate && [delegate respondsToSelector:@selector(inputViewController:newHeight:duration:animationCurve:)]) {
        [delegate inputViewController:self newHeight:inputTextViewToTop + inputTextView.bounds.size.height + [LLAChatInpuFunctionView calculateHeight]+ [LLAChatInputPickerEmojiView calculateHeight] duration:0.18 animationCurve:UIViewAnimationCurveEaseInOut];
    }
    
    
    currentInputType = LLAChatInputControllerCurrentType_PickEmoji;
    
    tapToRecordButton.hidden = YES;
    inputTextView.hidden = NO;

}

#pragma mark - LLAChatInputPickerEmojiViewDelegate

- (void) pickedEmoji:(NSString *) emojiString {
    if (emojiString) {
        NSString *newString = [NSString stringWithFormat:@"%@%@",inputTextView.text,emojiString];
        inputTextView.text = newString;
    }
}

- (void) sendMessageClicked {
    
}

- (void) deleteEmoji {
    
}

#pragma mark - HPGrowingTextViewDelegate

- (void) growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    
    //
    
    CGFloat offset = height - growingTextView.bounds.size.height;
    
    CGFloat newHeight = self.view.bounds.size.height + offset;
    
    inputViewHeightConstraints.constant = height;
    functionViewToTopConstraints.constant = inputTextViewToTop + height;
    
    if (delegate && [delegate respondsToSelector:@selector(inputViewController:newHeight:duration:animationCurve:)]) {
        [delegate inputViewController:self newHeight:newHeight duration:0.5 animationCurve:UIViewAnimationCurveEaseInOut];
    }
    
}

- (void) growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height {
    
    growingTextView.internalTextView.scrollEnabled = YES;
    growingTextView.isScrollable = YES;
    growingTextView.internalTextView.showsHorizontalScrollIndicator = YES;
    [growingTextView scrollRangeToVisible:NSMakeRange([growingTextView.text length], 0)];
    
}

- (void) growingTextViewDidChange:(HPGrowingTextView *)growingTextView {
    
    growingTextView.internalTextView.scrollEnabled = YES;
    growingTextView.isScrollable = YES;
    growingTextView.internalTextView.showsHorizontalScrollIndicator = YES;
    [growingTextView scrollRangeToVisible:NSMakeRange([growingTextView.text length], 0)];
    
    
}

- (BOOL) growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView {
    
    currentInputType = LLAChatInputControllerCurrentType_InputText;
    
    functionView.recordVoiceButton.selected = NO;
    functionView.pickPhotoButton.selected = NO;
    functionView.cameraButton.selected = NO;
    functionView.emojiButton.selected = NO;
    
    return YES;
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (text.length !=0 && [text isEqualToString:@"\n"]){
        
        if (delegate && [delegate respondsToSelector:@selector(sendMessageWithContent:)]) {
            [delegate sendMessageWithContent:growingTextView.text];
        }
        growingTextView.text = @"";
        return NO;
    }
    return YES;
}


- (BOOL) growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView {
    growingTextView.text = @"";
    return NO;
}

#pragma mark - Record Button

- (void) tapToRecordTouchDown:(UIButton *) sender {
    
}

- (void) tapToRecordTouchUp:(UIButton *) sender {
    
}

#pragma mark - KeyBoardNotification

- (void) keyboardWillShow:(NSNotification *) noti {
    
    //
    if (currentInputType == LLAChatInputControllerCurrentType_InputText) {
    
        NSDictionary *userInfo = [noti userInfo];
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        CGRect keyboardEndFrame;
        
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
        
        if (delegate && [delegate respondsToSelector:@selector(inputViewController:newHeight:duration:animationCurve:)]) {
            [delegate inputViewController:self newHeight:inputTextViewToTop + inputTextView.bounds.size.height+[LLAChatInpuFunctionView calculateHeight]+keyboardEndFrame.size.height duration:animationDuration animationCurve:animationCurve];
        }
        

    }
    
}

- (void) keyBoardWillHide:(NSNotification *) noti {
    
}

#pragma mark - UIImagePickerViewController

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *pickedImage = [info valueForKey:UIImagePickerControllerEditedImage];
    if (!pickedImage) {
        pickedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

#pragma mark - public method

- (void) resignInputView {
    
    //
    
}

#pragma mark - height

+ (CGFloat) normalHeight {
    return inputTextViewToTop + inputTextViewMinHeight + [LLAChatInpuFunctionView calculateHeight];
}

@end
