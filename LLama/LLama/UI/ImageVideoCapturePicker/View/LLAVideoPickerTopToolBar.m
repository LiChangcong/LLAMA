//
//  LLAVideoPickerTopToolBar.m
//  LLama
//
//  Created by Live on 16/1/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAVideoPickerTopToolBar.h"

static const CGFloat viewsToTop = 12;
static const CGFloat viewsToHorBorder = 12;

static NSString *const backButtonImageName_Normal = @"back";
static NSString *const backButtonImageName_Highlight = @"backh";

@interface LLAVideoPickerTopToolBar()
{
    UIColor *backColor;
    
    //
    UIButton *backButton;
    
    UILabel *titleLabel;
    
    UIFont *titleLabelFont;
    UIColor *titleLabelTextColor;

}

@end

@implementation LLAVideoPickerTopToolBar

@synthesize delegate;

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        [self initVariables];
        [self initSubViews];
        [self initSubContraints];
        self.backgroundColor = backColor;
        
    }
    return self;
}

- (void) initVariables {
    backColor = [UIColor colorWithHex:0x202031];
    
    titleLabelFont = [UIFont llaFontOfSize:18];
    titleLabelTextColor = [UIColor whiteColor];
}

- (void) initSubViews {
    backButton = [[UIButton alloc] init];
    backButton.translatesAutoresizingMaskIntoConstraints = NO;
    backButton.userInteractionEnabled = YES;
    
    [backButton setImage:[UIImage llaImageWithName:backButtonImageName_Normal] forState:UIControlStateNormal];
    [backButton setImage:[UIImage llaImageWithName:backButtonImageName_Highlight] forState:UIControlStateHighlighted];
    
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:backButton];
    
    //
    titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.font = titleLabelFont;
    titleLabel.textColor = titleLabelTextColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"选片儿";
    
    [self addSubview:titleLabel];
    
    //
    
}

- (void) initSubContraints {
    
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toTop)-[backButton]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toTop":@(viewsToTop)}
      views:NSDictionaryOfVariableBindings(backButton)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toTop)-[titleLabel(==44)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toTop":@(viewsToTop)}
      views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    //horizal
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[backButton]-(2)-[titleLabel]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toLeft":@(viewsToHorBorder),
                @"toRight":@(viewsToHorBorder+46)}
      views:NSDictionaryOfVariableBindings(backButton,titleLabel)]];
    
    [backButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [self addConstraints:constrArray];
    
}

#pragma mark - ButtonClicked

- (void) backButtonClicked:(UIButton *) sender {
    if (delegate && [delegate respondsToSelector:@selector(backToPre)]) {
        [delegate backToPre];
    }
}

@end
