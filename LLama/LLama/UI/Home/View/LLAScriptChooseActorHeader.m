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
    // 标题
    UILabel *titleLabel;
    
    // 字体颜色
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
        // 设置变量
        [self initVariables];
        // 设置子控件与约束
        [self initSubViews];
    }
    return self;
}

// 设置变量
- (void) initVariables {
    titleLabelFont = [UIFont llaFontOfSize:14];
    titleLabelTextColor = [UIColor colorWithHex:0x11111e];
}

// 设置子控件与约束
- (void) initSubViews {
    
    // 标题
    titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.font = titleLabelFont;
    titleLabel.textColor = titleLabelTextColor;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = titleLabelTextString;
    [self addSubview:titleLabel];
    
    // 约束
    NSMutableArray *constrArray = [NSMutableArray array];
    
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
