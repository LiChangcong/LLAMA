//
//  LLAChatInputPickEmojiCell.m
//  LLama
//
//  Created by Live on 16/2/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAChatInputPickEmojiCell.h"

@interface LLAChatInputPickEmojiCell()
{
    UILabel *emojiLabel;
    
    UIFont *emojiLabelFont;
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
    
    emojiLabelFont = [UIFont llaFontOfSize:28];
}

- (void) initSubViews {
    
    emojiLabel = [[UILabel alloc] init];
    emojiLabel.translatesAutoresizingMaskIntoConstraints = NO;
    emojiLabel.font = emojiLabelFont;
    emojiLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:emojiLabel];
    
    //
    [self.contentView addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[emojiLabel]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(emojiLabel)]];
    
    [self.contentView addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[emojiLabel]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(emojiLabel)]];

}

- (void) updateCellWithEmoji:(NSString *)emojiString {
    emojiLabel.text = emojiString;
}

@end
