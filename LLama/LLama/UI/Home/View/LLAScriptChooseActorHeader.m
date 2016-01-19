//
//  LLAScriptChooseActorHeader.m
//  LLama
//
//  Created by Live on 16/1/19.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAScriptChooseActorHeader.h"

static const CGFloat titleLabelToLeft = 6;
static const CGFloat titleLabelToRight = 6;

static NSString *const titleLabelTextString = @"已报名演员";

@interface LLAScriptChooseActorHeader()
{
    UILabel *titleLabel;
    
    UIFont *titleLabelFont;
    UIColor *titleLabelTextColor;
}
@end

@implementation LLAScriptChooseActorHeader

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithHex:0xeaeaea];
        
        [self initVariables];
        [self initSubViews];
    }
    return self;
}

- (void) initVariables {
    titleLabelFont = [UIFont llaFontOfSize:14];
    titleLabelTextColor = [UIColor colorWithHex:0x11111e];
}

- (void) initSubViews {
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.font = titleLabelFont;
    titleLabel.textColor = titleLabelTextColor;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = titleLabelTextString;
    [self addSubview:titleLabel];
    
    //constraints
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[titleLabel]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[titleLabel]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(titleLabelToLeft),@"toLeft",
               @(titleLabelToRight),@"toRight", nil]
      views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    [self addConstraints:constrArray];
}

+ (CGFloat) calculateHeight {
    return 26;
}

@end
