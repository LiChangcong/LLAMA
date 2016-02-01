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

- (void) inputViewWillChangeHeight:(CGFloat) newHeight duration:(CGFloat) duration animationCurve:(UIViewAnimationCurve) animationCurve;

- (void) sendMessageWithContent:(NSString *) content;

@end

@interface LLAVideoCommentInputViewController : UIViewController

@property(nonatomic, weak) id<LLAVideoCommentInputViewControllerDelegate> delegate;

- (void) inputViewBecomeFirstResponder;

- (void) inputViewResignFirstResponder;

@end
