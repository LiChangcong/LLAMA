//
//  LLAPayUserPayTypeCell.m
//  LLama
//
//  Created by Live on 16/1/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAPayUserPayTypeCell.h"

#import "LLAPayUserPayTypeItem.h"

static const CGFloat imageViewHeightWidth = 59;
static const CGFloat imageViewToRight = 60;

@interface LLAPayUserPayTypeCell()
{
    UIButton *backButton;
    
    UILabel *titleLabel;
    
    UIImageView *imageView;
    
    //
    UIFont *titleLabelFont;
    UIColor *titleLabelTextColor;
}

@end

@implementation LLAPayUserPayTypeCell

#pragma mark - Init

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];
        
    }
    return self;
}

- (void) initVariables {
    titleLabelFont = [UIFont llaFontOfSize:17];
    titleLabelTextColor = [UIColor whiteColor];
}

- (void) initSubViews {
    
    backButton = [[UIButton alloc] init];
    backButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [backButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:backButton];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.font = titleLabelFont;
    titleLabel.textColor = titleLabelTextColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:titleLabel];
    
    imageView = [[UIImageView alloc] init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:imageView];
    
}

- (void) initSubConstraints {
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[backButton]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(backButton)]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:titleLabel
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:backButton
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:imageView
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:backButton
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];
    
    //horizonal
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[backButton]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(backButton)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[titleLabel]-(0)-[imageView(imageWidth)]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toLeft":@(imageViewHeightWidth+imageViewToRight),
                @"imageWidth":@(imageViewHeightWidth),
                @"toRight":@(imageViewToRight)}
      views:NSDictionaryOfVariableBindings(titleLabel,imageView)]];
    
    [self.contentView addConstraints:constrArray];

}

#pragma mark - Button Clicked

- (void) buttonClicked:(UIButton *) sender {
    
}

#pragma mark - Update

- (void) updateCellWithPayTypeInfo:(LLAPayUserPayTypeItem *) payTypeInfo {
    
    [backButton setBackgroundColor:payTypeInfo.backColor forState:UIControlStateNormal];
    imageView.image = payTypeInfo.payTypeNormalImage;
    imageView.highlightedImage = payTypeInfo.payTypeHighlightImage;
    titleLabel.text = payTypeInfo.payTypeDesc;
}

#pragma mark - Calculate Height

+ (CGFloat) calculateHeightPayTypeInfo:(LLAPayUserPayTypeItem *) payTypeInfo width:(CGFloat) width {
    return 60;
}

@end
