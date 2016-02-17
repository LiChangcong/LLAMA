//
//  LLAImagePickerTopToolBar.m
//  LLama
//
//  Created by tommin on 16/2/16.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAImagePickerTopToolBar.h"

static const CGFloat viewsToTop = 12;
static const CGFloat viewsToHorBorder = 12;

static NSString *const backButtonImageName_Normal = @"back";
static NSString *const backButtonImageName_Highlight = @"backh";

static NSString *const determineButtonImageName_Normal = @"pickImage_Finish_Normal";
static NSString *const determineButtonImageName_Highlight = @"pickImage_Finish_Highlight";


@interface LLAImagePickerTopToolBar()
{
    UIColor *backColor;
    
    //
    UIButton *backButton;
    
    //
    UIButton *determineButton;
    
    UILabel *titleLabel;
    UIFont *titleLabelFont;
    UIColor *titleLabelTextColor;
    
}

@end

@implementation LLAImagePickerTopToolBar

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
    
    //
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
    titleLabel.text = @"相册";
    [self addSubview:titleLabel];
    
    //
    determineButton = [[UIButton alloc] init];
    determineButton.translatesAutoresizingMaskIntoConstraints = NO;
    determineButton.userInteractionEnabled = YES;
    [determineButton setImage:[UIImage llaImageWithName:determineButtonImageName_Normal] forState:UIControlStateNormal];
    [determineButton setImage:[UIImage llaImageWithName:determineButtonImageName_Highlight] forState:UIControlStateDisabled];
    [determineButton addTarget:self action:@selector(determineButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    determineButton.enabled = NO;
    [self addSubview:determineButton];
    self.determineButtonFaceToPublich = determineButton;
    

    
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
    
    
//    [constrArray addObjectsFromArray:
//     [NSLayoutConstraint
//      constraintsWithVisualFormat:@"V:|-(toTop)-[determineButton]"
//      options:NSLayoutFormatDirectionLeadingToTrailing
//      metrics:@{@"toTop":@(viewsToTop)}
//      views:NSDictionaryOfVariableBindings(determineButton)]];

    [constrArray addObject:[NSLayoutConstraint
                            constraintWithItem:determineButton
                            attribute:NSLayoutAttributeCenterY
                            relatedBy:NSLayoutRelationEqual
                            toItem:self
                            attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    //horizal
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[backButton]-(2)-[titleLabel]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toLeft":@(viewsToHorBorder),
                @"toRight":@(viewsToHorBorder+46)}
      views:NSDictionaryOfVariableBindings(backButton,titleLabel)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[determineButton]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toRight":@(25)}
      views:NSDictionaryOfVariableBindings(determineButton)]];
    
    [backButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [self addConstraints:constrArray];
    
}



#pragma mark - backButtonClicked

- (void) backButtonClicked:(UIButton *) sender {
    if (delegate && [delegate respondsToSelector:@selector(backToPre)]) {
        [delegate backToPre];
    }
}

#pragma mark - determineButtonClicked

- (void) determineButtonClicked:(UIButton *) sender {
    
    if ([self.delegate respondsToSelector:@selector(LLAImagePickerTopToolBarDidClickDetermineButton:)]) {
        
        [self.delegate LLAImagePickerTopToolBarDidClickDetermineButton:self];
    }
}

@end
