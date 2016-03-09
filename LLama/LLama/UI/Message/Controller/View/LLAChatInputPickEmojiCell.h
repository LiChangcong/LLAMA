//
//  LLAChatInputPickEmojiCell.h
//  LLama
//
//  Created by Live on 16/2/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAPickEmojiItemInfo;

@interface LLAChatInputPickEmojiCell : UICollectionViewCell

- (void) updateCellWithEmoji:(LLAPickEmojiItemInfo *) emojiInfo;

@end
