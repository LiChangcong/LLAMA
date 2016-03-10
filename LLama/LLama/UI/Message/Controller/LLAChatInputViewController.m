//
//  LLAChatInputViewController.m
//  LLama
//
//  Created by Live on 16/2/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <Photos/Photos.h>

#import "LLAChatInputViewController.h"
#import "LLAImagePickerViewController.h"

//view
#import "LLAChatInpuFunctionView.h"
#import "HPGrowingTextView.h"
#import "LLAChatInputPickerEmojiView.h"

#import "XHVoiceRecordHUD.h"

//model
#import "LLAPickImageItemInfo.h"
#import "Emoji.h"

//util
#import "XHVoiceRecordHelper.h"
#import "XHVoiceCommonHelper.h"
#import "LLAMessageChatConfig.h"

#import "XHMacro.h"

#import "VoiceConverter.h"

//
#define kXHTouchToRecord         @"按住 说话"
#define kXHTouchToFinish         @"松开 结束"

#define MIN_AUDIO_RECORDING_INTERVAL 1

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

//
@property (nonatomic, assign, readwrite) CFTimeInterval lastAudioRecordingTime;

/**
 *  是否取消錄音
 */
@property (nonatomic, assign, readwrite) BOOL isCancelled;

/**
 *  是否正在錄音
 */
@property (nonatomic, assign, readwrite) BOOL isRecording;

//recorder

@property (nonatomic , strong ,readwrite) XHVoiceRecordHelper *voiceRecordHelper;

//recorder HUD

@property (nonatomic , strong ,readwrite) XHVoiceRecordHUD *voiceRecordHUD;


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

- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if (self.isRecording) {
        //stop it
        [self holdDownButtonTouchUpInside];
    }
    
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
    
    [tapToRecordButton setTitle:kXHTouchToRecord forState:UIControlStateNormal];
    [tapToRecordButton setTitle:kXHTouchToFinish forState:UIControlStateHighlighted];

    
    [tapToRecordButton addTarget:self action:@selector(holdDownButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [tapToRecordButton addTarget:self action:@selector(holdDownButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [tapToRecordButton addTarget:self action:@selector(holdDownButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [tapToRecordButton addTarget:self action:@selector(holdDownDragOutside) forControlEvents:UIControlEventTouchDragExit];
    [tapToRecordButton addTarget:self action:@selector(holdDownDragInside) forControlEvents:UIControlEventTouchDragEnter];
    
    
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
        tapToRecordButton.hidden = YES;
        inputTextView.hidden = NO;
        [inputTextView.internalTextView becomeFirstResponder];
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
    imagePicker.status = PickerImgOrHeadStatusHead;
    
    imagePicker.callBack = ^(LLAPickImageItemInfo *item) {
        if (item.thumbImage) {
            if (delegate && [delegate respondsToSelector:@selector(sendMessageWithImage:)]) {
                [delegate sendMessageWithImage:item.thumbImage];
            }
        }
    };
    
    [self.navigationController presentViewController:imagePicker animated:YES completion:^{
        if (currentInputType == LLAChatInputControllerCurrentType_InputText) {
            [self resignInputView];
        }

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
        
        if (currentInputType == LLAChatInputControllerCurrentType_InputText) {
            [self resignInputView];
        }

    }];
    
    
}

- (void) showEmojiWithFunctionView:(LLAChatInpuFunctionView *)functionView {
    if (currentInputType == LLAChatInputControllerCurrentType_PickEmoji) {
        //hide , show input text
        
        [inputTextView.internalTextView becomeFirstResponder];
        
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
    
    if (inputTextView.text.length > 0) {
        
        if (delegate && [delegate respondsToSelector:@selector(sendMessageWithContent:)]) {
            [delegate sendMessageWithContent:inputTextView.text];
        }
        inputTextView.text = @"";

    }
    
    
}

- (void) deleteEmoji {
    //delete
    
//    NSString *text = inputTextView.text;
//    if (text.length < 1) {
//        return;
//    }
//    
//    //emoji占两个长度，所以先看看是不是emoji表情
//    NSString *newStr = [text substringToIndex:text.length-1];
//    NSArray *faces = [Emoji allEmoji];
//    if(text.length > 1 && [faces containsObject:[text substringFromIndex:text.length-2]]){
//        newStr = [text substringToIndex:text.length-2];
//    }
//    inputTextView.text = newStr;
    
    [inputTextView.internalTextView deleteBackward];

    
}

- (void) closeKeyBoard {
    [self resignInputView];
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
    
    [functionView deselectAllButtons];
    
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

#pragma mark - Record Button

- (BOOL)audioRecordingShouldBegin {
    BOOL result = YES;
    
    CFTimeInterval now = CACurrentMediaTime();
    
    if (self.lastAudioRecordingTime > 0 && now - self.lastAudioRecordingTime < MIN_AUDIO_RECORDING_INTERVAL) {
        result = NO;
    }
    
    self.lastAudioRecordingTime = now;
    
    return result;
}


- (void)holdDownButtonTouchDown {
    if (![self audioRecordingShouldBegin]) {
        return;
    }
    
    self.isCancelled = NO;
    self.isRecording = NO;

    
    WEAKSELF
    
    //這邊回調 return 的 YES, 或 NO, 可以讓底層知道該次錄音是否成功, 進而處理無用的 record 對象
    
    NSString *path = [XHVoiceCommonHelper generateAudioRecordPath];
    
    [self.voiceRecordHelper prepareRecordingWithPath:path prepareRecorderCompletion:^BOOL{
        STRONGSELF
        
        //這邊要判斷回調回來的時候, 使用者是不是已經早就鬆開手了
        if (strongSelf && !strongSelf.isCancelled) {
            strongSelf.isRecording = YES;
        
            //
            [self.voiceRecordHUD startRecordingHUDAtView:[UIApplication sharedApplication].keyWindow];
            [self.voiceRecordHelper startRecordingWithStartRecorderCompletion:^{
            }];
            
            return YES;
        } else {
            return NO;
        }

    }];

    
}

- (void)holdDownButtonTouchUpOutside {
    
    //如果已經開始錄音了, 才需要做取消的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
//        if ([self.delegate respondsToSelector:@selector(didCancelRecordingVoiceAction)]) {
//            [self.delegate didCancelRecordingVoiceAction];
//        }
        WEAKSELF
        [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
            weakSelf.voiceRecordHUD = nil;
            self.isRecording = NO;
        }];
        [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
            
        }];
        
        
    } else {
        self.isCancelled = YES;
    }
}

- (void)holdDownButtonTouchUpInside {
    
    //如果已經開始錄音了, 才需要做結束的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
//        if ([self.delegate respondsToSelector:@selector(didFinishRecoingVoiceAction)]) {
//            [self.delegate didFinishRecoingVoiceAction];
//        }
        
        WEAKSELF
        [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
            weakSelf.voiceRecordHUD = nil;
        }];
        [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
            //[weakSelf didSendMessageWithVoice:weakSelf.voiceRecordHelper.recordPath voiceDuration:weakSelf.voiceRecordHelper.recordDuration];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(sendMessageWithVoiceURL:withDuration:)]) {
                
                //convert from wav to amr
                self.isRecording = NO;
                
                NSString *amrPath = [XHVoiceCommonHelper amrPathFromWavPath:weakSelf.voiceRecordHelper.recordPath];
                
                [VoiceConverter wavToAmr:weakSelf.voiceRecordHelper.recordPath amrSavePath:amrPath];
                
                [weakSelf.delegate sendMessageWithVoiceURL:amrPath withDuration:[weakSelf.voiceRecordHelper.recordDuration floatValue]];
            }
        }];
        
    } else {
        self.isCancelled = YES;
    }
}

- (void)holdDownDragOutside {
    
    //如果已經開始錄音了, 才需要做拖曳出去的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
//        if ([self.delegate respondsToSelector:@selector(didDragOutsideAction)]) {
//            [self.delegate didDragOutsideAction];
//        }
        [self.voiceRecordHUD resaueRecord];
    } else {
        self.isCancelled = YES;
    }
}

- (void)holdDownDragInside {
    
    //如果已經開始錄音了, 才需要做拖曳回來的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
//        if ([self.delegate respondsToSelector:@selector(didDragInsideAction)]) {
//            [self.delegate didDragInsideAction];
//        }
        [self.voiceRecordHUD pauseRecord];
    } else {
        self.isCancelled = YES;
    }
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //保存图片到相册
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromImage:pickedImage];
        } completionHandler:^(BOOL success, NSError *error) {
            
            if (success) {
                // 保存照片成功
            }
            
        }];
        
    });
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (delegate && [delegate respondsToSelector:@selector(sendMessageWithImage:)]) {
            [delegate sendMessageWithImage:pickedImage];
        }
    }];
    
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

#pragma mark - public method

- (void) resignInputView {
    
    //
    
    [functionView deselectAllButtons];
    
    if (currentInputType == LLAChatInputControllerCurrentType_InputText || currentInputType == LLAChatInputControllerCurrentType_PickEmoji) {
    
        [inputTextView resignFirstResponder];
        currentInputType = LLAChatInputControllerCurrentType_InputText;
        //
        CGFloat newHeight = inputTextViewToTop + inputTextView.bounds.size.height+[LLAChatInpuFunctionView calculateHeight];
        if (delegate && [delegate respondsToSelector:@selector(inputViewController:newHeight:duration:animationCurve:)]) {
            [delegate inputViewController:self newHeight:newHeight duration:0.2 animationCurve:UIViewAnimationCurveEaseIn];
        }
        
    }else {
        
    }
    
}

#pragma mark - Recorder Helper

- (XHVoiceRecordHelper *)voiceRecordHelper {
    if (!_voiceRecordHelper) {
        WEAKSELF
        _voiceRecordHelper = [[XHVoiceRecordHelper alloc] init];
        _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
            DLog(@"已经达到最大限制时间了，进入下一步的提示");
            
            [weakSelf holdDownButtonTouchUpInside];
            
        };
        _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
            weakSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
        };
        //_voiceRecordHelper.maxRecordTime = kVoiceRecorderTotalTime;
        _voiceRecordHelper.maxRecordTime = [LLAMessageChatConfig shareConfig].maxRecordVoiceDuration;
    }
    return _voiceRecordHelper;
}

- (XHVoiceRecordHUD *)voiceRecordHUD {
    if (!_voiceRecordHUD) {
        _voiceRecordHUD = [[XHVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    }
    return _voiceRecordHUD;
}

#pragma mark - height

+ (CGFloat) normalHeight {
    return inputTextViewToTop + inputTextViewMinHeight + [LLAChatInpuFunctionView calculateHeight];
}

@end
