//
//  LLAChatInputPickEmojiCell.m
//  LLama
//
//  Created by Live on 16/2/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAChatInputPickEmojiCell.h"

#import "LLAPickEmojiItemInfo.h"

@interface LLAChatInputPickEmojiCell()
{
    UIButton *emojiButton;
    
    UIFont *emojiButtonFont;
}

@end

@implementation LLAChatInputPickEmojiCell

#pragma mark - Init

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHex:0xf6f6f6];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self commonInit];
        
    }
    
    return self;
    
}

- (void) commonInit {
    
    [self initVariables];
    [self initSubViews];
}

- (void) initVariables {
    
    emojiButtonFont = [UIFont llaFontOfSize:28];
}

- (void) initSubViews {
    
    emojiButton = [[UIButton alloc] init];
    emojiButton.translatesAutoresizingMaskIntoConstraints = NO;
    emojiButton.titleLabel.font = emojiButtonFont;
    
    emojiButton.userInteractionEnabled = NO;
    
    [self.contentView addSubview:emojiButton];
    
    //
    [self.contentView addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[emojiButton]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(emojiButton)]];
    
    [self.contentView addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[emojiButton]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(emojiButton)]];

}

- (void) updateCellWithEmoji:(LLAPickEmojiItemInfo *)emojiInfo {
    
    if (emojiInfo.type == LLAPickEmojiItemType_NormalEmoji) {
        [emojiButton setImage:nil forState:UIControlStateNormal];
        [emojiButton setTitle:emojiInfo.emojiString forState:UIControlStateNormal];
    }else {
        [emojiButton setTitle:nil forState:UIControlStateNormal];
        [emojiButton setImage:[UIImage llaImageWithName:@"delete_emoji"] forState:UIControlStateNormal];
    }
    
}

@end
