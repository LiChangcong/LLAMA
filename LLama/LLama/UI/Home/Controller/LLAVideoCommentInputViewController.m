//
//  LLAVideoCommentInputViewController.m
//  LLama
//
//  Created by Live on 16/2/1.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAVideoCommentInputViewController.h"

#import "HPGrowingTextView.h"

//
static const NSInteger kMAXTITLEWORDCOUNT = 200;

static const CGFloat inputViewToTop = 8;
static const CGFloat inputViewMinHeight = 36;
static const CGFloat inputViewToBottom = 8;

static const CGFloat inputViewToLeft = 8;
static const CGFloat inputViewToSendButtonHorSpace = 10;
static const CGFloat sendMessageButtonWidth = 50;
static const CGFloat sendMessageButtonToRight = 8;

//
CGFloat llaVideoCommentIputViewHeight = inputViewToTop + inputViewMinHeight + inputViewToBottom;
//

@interface LLAVideoCommentInputViewController()<HPGrowingTextViewDelegate>
{
    HPGrowingTextView *contentInputView;
    
    UIButton *sendMessageButton;
    
    //
    UIFont *sendMessageButtonFont;
    UIColor *sendMessageNormalBKColor;
    UIColor *sendMessageTitleNormalColor;
    
    //
    UIFont *messageTextViewFont;
    UIColor *messageTextViewTextColor;
    
    //
    NSLayoutConstraint *inputViewHeightConstraints;
    
}

@end

@implementation LLAVideoCommentInputViewController

@synthesize delegate;

#pragma mark - Life Cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:0xebebeb];
    //
    [self initVariables];
    [self initSubViews];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark - init

- (void) initVariables {
    sendMessageButtonFont = [UIFont llaFontOfSize:14];
    sendMessageNormalBKColor = [UIColor themeColor];
    sendMessageTitleNormalColor = [UIColor colorWithHex:0x11111e];
    
    messageTextViewFont = [UIFont llaFontOfSize:14];
    messageTextViewTextColor = [UIColor colorWithHex:0x11111e];
}

- (void) initSubViews {
    contentInputView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-inputViewToLeft-inputViewToSendButtonHorSpace-sendMessageButtonWidth-sendMessageButtonToRight, inputViewMinHeight)];
    
    contentInputView.translatesAutoresizingMaskIntoConstraints = NO;
    contentInputView.font = messageTextViewFont;
    contentInputView.textColor = messageTextViewTextColor;
    //messageTextView.minNumberOfLines = 1;
    contentInputView.minHeight = inputViewMinHeight;
    contentInputView.maxNumberOfLines = 5;
    contentInputView.hidden = YES;
    contentInputView.layer.cornerRadius = 4;
    contentInputView.clipsToBounds = YES;
    contentInputView.delegate = self;
    contentInputView.isScrollable = YES;
    contentInputView.placeholder = @"添加评论...";
    
    [self.view addSubview:contentInputView];
    
    //
    sendMessageButton = [[UIButton alloc] init];
    sendMessageButton.translatesAutoresizingMaskIntoConstraints = NO;
    sendMessageButton.clipsToBounds = YES;
    sendMessageButton.layer.cornerRadius = 4;
    sendMessageButton.enabled = NO;
    sendMessageButton.titleLabel.font = sendMessageButtonFont;
    
    [sendMessageButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendMessageButton setTitleColor:sendMessageTitleNormalColor forState:UIControlStateNormal];
    [sendMessageButton setBackgroundColor:sendMessageNormalBKColor forState:UIControlStateNormal];
    
    [sendMessageButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sendMessageButton];
    
    //constraints
    
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toTop)-[contentInputView(height)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toTop":@(inputViewToTop),
                @"height":@(inputViewMinHeight)}
      views:NSDictionaryOfVariableBindings(contentInputView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[sendMessageButton(height)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{
                @"height":@(inputViewMinHeight)}
      views:NSDictionaryOfVariableBindings(sendMessageButton)]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:sendMessageButton
      attribute:NSLayoutAttributeBottom
      relatedBy:NSLayoutRelationEqual
      toItem:contentInputView
      attribute:NSLayoutAttributeBottom
      multiplier:1.0
      constant:0]];
    
    //vertical
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[contentInputView]-(inputToButton)-[sendMessageButton(width)]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toLeft":@(inputViewToLeft),
                @"inputToButton":@(inputViewToSendButtonHorSpace),
                @"width":@(sendMessageButtonWidth),
                @"toRight":@(sendMessageButtonToRight)}
      views:NSDictionaryOfVariableBindings(contentInputView,sendMessageButton)]];
    
    [self.view addConstraints:constrArray];
    
    //
    for (NSLayoutConstraint *constr in constrArray) {
        if (constr.firstAttribute == NSLayoutAttributeHeight && constr.firstItem == contentInputView) {
            
            inputViewHeightConstraints = constr;
            break;
        }
    }
    
    

}

#pragma mark - KeyBoard Notification

-(void) keyboardWillShow:(NSNotification *) noti{
    NSDictionary *userInfo = [noti userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    //keyBoardRect = keyboardEndFrame;
    //    CGFloat newHeight = textViewToTop+textInputView.frame.size.height + textViewToExtentionView  + keyboardEndFrame.size.height;
    
    if (delegate && [delegate respondsToSelector:@selector(inputViewWillChangeHeight:duration:animationCurve:)]) {
        
        CGFloat newHeight = inputViewToTop + contentInputView.bounds.size.height + inputViewToBottom + keyboardEndFrame.size.height;
        
        [delegate inputViewWillChangeHeight:newHeight duration:animationDuration animationCurve:animationCurve];
        
    }

    
}

-(void) keyboardWillHide:(NSNotification *) noti{
    NSDictionary *userInfo = [noti userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    if (delegate && [delegate respondsToSelector:@selector(inputViewWillChangeHeight:duration:animationCurve:)]) {
        
        CGFloat newHeight = inputViewToTop + contentInputView.bounds.size.height + inputViewToBottom;
        
        [delegate inputViewWillChangeHeight:newHeight duration:animationDuration animationCurve:animationCurve];
        
    }

    
    
}

#pragma mark - Send Message

- (void) sendMessage:(UIButton *) sender {
    //
    if (contentInputView.text.length > 0) {
        if (delegate && [delegate respondsToSelector:@selector(sendMessageWithContent:)]) {
            [delegate sendMessageWithContent:contentInputView.text];
        }
    }
}

#pragma mark - HPGrowingTextViewDelegate

- (void) growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    
    CGFloat newHeight = MAX(height,inputViewMinHeight);
    newHeight += inputViewToTop;
    newHeight += inputViewToBottom;
    
    inputViewHeightConstraints.constant = newHeight;
    
    if (delegate && [delegate respondsToSelector:@selector(inputViewWillChangeHeight:duration:animationCurve:)]) {
        [delegate inputViewWillChangeHeight:newHeight duration:0.1 animationCurve:UIViewAnimationCurveEaseInOut];
    }
    
    
}

- (void) growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height {
    
    growingTextView.internalTextView.scrollEnabled = YES;
    growingTextView.isScrollable = YES;
    growingTextView.internalTextView.showsHorizontalScrollIndicator = YES;
    [growingTextView scrollRangeToVisible:NSMakeRange([growingTextView.text length], 0)];
    
}

- (void) growingTextViewDidChange:(HPGrowingTextView *)growingTextView {
    
    NSString *text = growingTextView.text;
    
    // 截取超出文字
    // 判断输入法
    BOOL isChinese = NO;
    UITextInputMode *textInputMode = growingTextView.textInputMode;
    if ([textInputMode.primaryLanguage isEqualToString: @"zh-Hans"]) {
        isChinese = YES;
    }
    
    // maxLength是自己设置的位数
    if (isChinese) { //中文输入法下
        UITextRange *selectedRange = [growingTextView.internalTextView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [growingTextView.internalTextView  positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (text.length>kMAXTITLEWORDCOUNT) {
                NSString *strNew = [NSString stringWithString:text];
                growingTextView.internalTextView.text = [strNew substringToIndex:kMAXTITLEWORDCOUNT];
            }
            
            // 获取截取后的内容，更新剩余多少字
            text = growingTextView.internalTextView.text;
            
        }
    }else{
        if (text.length>kMAXTITLEWORDCOUNT) {
            NSString *strNew = [NSString stringWithString:text];
            growingTextView.text = [strNew substringToIndex:kMAXTITLEWORDCOUNT];
        }
        
        // 获取截取后的内容，更新剩余多少字
        text = growingTextView.text;
    }
    
    //
    growingTextView.internalTextView.scrollEnabled = YES;
    growingTextView.isScrollable = YES;
    growingTextView.internalTextView.showsHorizontalScrollIndicator = YES;
    [growingTextView scrollRangeToVisible:NSMakeRange([growingTextView.text length], 0)];
    //
    //    if ([messageTextView.text isEqualToString:[NSString stringWithFormat:@"@%@ ",currentReplyToUser.nickName]]) {
    //        sendMessageButton.enabled = NO;
    //    }else {
    //        sendMessageButton.enabled = YES;
    //    }
    if (contentInputView.text.length > 0) {
        sendMessageButton.enabled = YES;
    }else {
        sendMessageButton.enabled = NO;
    }
}


#pragma mark - Public Method

- (void) inputViewBecomeFirstResponder {
    [contentInputView becomeFirstResponder];
}

- (void) inputViewResignFirstResponder {
    
    [contentInputView resignFirstResponder];
    
}

@end
