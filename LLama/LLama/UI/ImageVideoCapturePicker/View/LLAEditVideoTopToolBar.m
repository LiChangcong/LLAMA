//
//  LLAEditVideoTopToolBar.m
//  LLama
//
//  Created by Live on 16/1/28.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAEditVideoTopToolBar.h"

static const CGFloat viewsToTop = 12;
static const CGFloat viewsToHorBorder = 12;

static NSString *const backButtonImageName_Normal = @"back";
static NSString *const backButtonImageName_Highlight = @"backh";

static NSString *const editDoneButtonImageName_Normal = @"finishcutyouvideo";
static NSString *const editDoneButtonImageName_Highlight = @"finishcutyouvideo";

@interface LLAEditVideoTopToolBar()
{
    UIColor *backColor;
    
    //
    UIButton *backButton;
    
    UILabel *titleLabel;
    UIButton *editDoneButton;
    
    UIFont *titleLabelFont;
    UIColor *titleLabelTextColor;
    
}

@end

@implementation LLAEditVideoTopToolBar

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
    titleLabel.text = @"剪片";
    
    [self addSubview:titleLabel];
    
    //
    editDoneButton = [[UIButton alloc] init];
    editDoneButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [editDoneButton setImage:[UIImage llaImageWithName:editDoneButtonImageName_Normal] forState:UIControlStateNormal];
    [editDoneButton setImage:[UIImage llaImageWithName:editDoneButtonImageName_Highlight] forState:UIControlStateHighlighted];
    
    [editDoneButton addTarget:self action:@selector(editDoneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:editDoneButton];

    
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
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toTop)-[editDoneButton]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toTop":@(viewsToTop)}
      views:NSDictionaryOfVariableBindings(editDoneButton)]];
    
    //horizal
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toBorder)-[backButton]-(2)-[titleLabel]-(2)-[editDoneButton]-(toBorder)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toBorder":@(viewsToHorBorder)}
      views:NSDictionaryOfVariableBindings(backButton,titleLabel,editDoneButton)]];
    
    [backButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [editDoneButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self addConstraints:constrArray];
    
}

#pragma mark - ButtonClicked

- (void) backButtonClicked:(UIButton *) sender {
    if (delegate && [delegate respondsToSelector:@selector(backToPre)]) {
        [delegate backToPre];
    }
}

- (void) editDoneButtonClicked:(UIButton *) sender {
    if (delegate && [delegate respondsToSelector:@selector(editVideoDone)]) {
        [delegate editVideoDone];
    }
}

@end
