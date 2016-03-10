//
//  LLAChatInputPickerEmojiView.h
//  LLama
//
//  Created by Live on 16/2/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLAChatInputPickerEmojiViewDelegate <NSObject>

- (void) pickedEmoji:(NSString *) emojiString;

- (void) sendMessageClicked;

- (void) deleteEmoji;

- (void) closeKeyBoard;

@end

@interface LLAChatInputPickerEmojiView : UIView

@property(nonatomic , weak) id<LLAChatInputPickerEmojiViewDelegate> delegate;

+ (CGFloat) calculateHeight;

@end
