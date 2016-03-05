//
//  LLAChatInputViewController.h
//  LLama
//
//  Created by Live on 16/2/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LLAChatInputControllerCurrentType) {
    
    LLAChatInputControllerCurrentType_InputText = 0,
    LLAChatInputControllerCurrentType_RecordVoice = 1,
    LLAChatInputControllerCurrentType_PickPhoto = 2,
    LLAChatInputControllerCurrentType_TakePhoto = 3,
    LLAChatInputControllerCurrentType_PickEmoji = 4,
};

@class LLAChatInputViewController;

@protocol LLAChatInputViewControllerDelegate <NSObject>

//message

- (void) sendMessageWithContent:(NSString *) textContent;

- (void) sendMessageWithImage:(UIImage *) image;

- (void) sendMessageWithVoiceURL:(NSString *) voiceFilePath withDuration:(CGFloat) duration;

//change Height

- (void) inputViewController:(LLAChatInputViewController *) inputController
                   newHeight:(CGFloat) newHeight
                    duration:(NSTimeInterval) duration
              animationCurve:(UIViewAnimationCurve) animationCurve;


@end

@interface LLAChatInputViewController : UIViewController

@property(nonatomic , weak) id<LLAChatInputViewControllerDelegate> delegate;

@property(nonatomic , assign ,readonly) LLAChatInputControllerCurrentType  currentInputType;

- (void) resignInputView;

+ (CGFloat) normalHeight;

@end
