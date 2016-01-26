//
//  LLATextView.m
//  LLama
//
//  Created by Live on 16/1/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLATextView.h"

// 左右两边的offset
static CGFloat const kOffset = 5;

@interface LLATextView () <UITextViewDelegate>

@property (nonatomic, assign) CGRect placeholderRect;

LLAInitVariables(LLATextView);
- (void)handleTextDidChangeNotification:(NSNotification *)notification;

@end

@implementation LLATextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initVariablesLLATextView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initVariablesLLATextView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!self.text.length && self.placeholder.length) {
        
        UIFont *font = self.font;
        if (!font) {
            font = [UIFont systemFontOfSize:14];
        }
        
        [self.placeholder drawWithRect:self.placeholderRect
                               options:NSStringDrawingUsesLineFragmentOrigin
                            attributes:@{NSFontAttributeName:font,
                                         NSForegroundColorAttributeName:[[UIColor grayColor] colorWithAlphaComponent:0.7]}
                               context:nil];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

- (void)initVariablesLLATextView{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleTextDidChangeNotification:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillChangeFrameNotification:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    UIEdgeInsets edgeInsets = self.textContainerInset;
    edgeInsets.left = kOffset;
    edgeInsets.right = kOffset;
    self.placeholderRect = UIEdgeInsetsInsetRect(self.bounds, edgeInsets);
}

- (void)handleTextDidChangeNotification:(NSNotification *)notification {
    [self setNeedsDisplay];
}

- (void)handleKeyboardWillChangeFrameNotification:(NSNotification *)notification {
    // 1.移动view
    
    NSDictionary *userInfo = notification.userInfo;
    
    CGFloat duration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect endFrame = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect textFrame = [self convertRect:self.bounds toView:self.originView];
    CGFloat yOffset = endFrame.origin.y - (textFrame.origin.y + textFrame.size.height);
    // textView顶部不能超出屏幕
    if (textFrame.origin.y + yOffset < 0) {
        yOffset = -textFrame.origin.y;
    }
    // originView的originY
    CGRect newOriginFrame = self.originView.frame;
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    newOriginFrame.origin.y = yOffset;
    CGFloat maxOriginY = screenBounds.size.height-newOriginFrame.size.height;
    if (newOriginFrame.origin.y > maxOriginY) {
        newOriginFrame.origin.y = maxOriginY;
    }
    
    [UIView animateWithDuration:duration animations:^{
        self.originView.frame = newOriginFrame;
    } completion:nil];
    
    // 2.移动window
    /*
     NSDictionary *userInfo = notification.userInfo;
     
     CGFloat duration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
     CGRect endFrame = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
     
     UIWindow *keyWindow = [[UIApplication sharedApplication].delegate window];
     CGRect textFrame = [self convertRect:self.bounds toView:keyWindow];
     CGFloat yOffset = endFrame.origin.y - (textFrame.origin.y + textFrame.size.height);
     // textView顶部不能超出屏幕
     if (textFrame.origin.y + yOffset < 0) {
     yOffset = -textFrame.origin.y;
     }
     // originView的originY
     CGRect newOriginFrame = keyWindow.frame;
     newOriginFrame.origin.y = yOffset;
     if (newOriginFrame.origin.y > 0) {
     newOriginFrame.origin.y = 0;
     }
     
     [UIView animateWithDuration:duration animations:^{
     keyWindow.frame = newOriginFrame;
     } completion:nil];
     */
}

@end
