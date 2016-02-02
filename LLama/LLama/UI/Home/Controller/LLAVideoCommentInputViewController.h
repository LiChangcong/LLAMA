//
//  LLAVideoCommentInputViewController.h
//  LLama
//
//  Created by Live on 16/2/1.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat llaVideoCommentIputViewHeight;

@protocol LLAVideoCommentInputViewControllerDelegate <NSObject>

@optional

- (void) inputViewWillChangeHeight:(CGFloat) newHeight duration:(CGFloat) duration animationCurve:(UIViewAnimationCurve) animationCurve;

- (void) sendMessageWithContent:(NSString *) content;

- (void) inputViewControllerWillBecomeFirstResponder;

- (void) inputViewControllerWillResignFirstResponder;

@end

@interface LLAVideoCommentInputViewController : UIViewController

@property(nonatomic, weak) id<LLAVideoCommentInputViewControllerDelegate> delegate;

@property(nonatomic , copy) NSString *placeHolder;

- (void) inputViewBecomeFirstResponder;

- (void) inputViewResignFirstResponder;

- (void) resetContent;

@end
