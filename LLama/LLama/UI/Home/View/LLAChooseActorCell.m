//
//  LLAChooseActorCell.m
//  LLama
//
//  Created by Live on 16/1/18.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAChooseActorCell.h"

static NSString *const viewDetailButtonImageName_Normal = @"view_profile";
static NSString *const viewDetailButtonImageName_Highlight = @"view_profileH";

static NSString *const selectedCoverImageName = @"winner";

//
static const CGFloat imageViewToBottom = 6;

static const CGFloat viewDetailButtonToTop = 4;
static const CGFloat viewDetailButtonToRight = 4;

@interface LLAChooseActorCell()
{
    UIImageView *userHeadImageView;
    UIButton *viewDetailButton;
    UILabel *userNameLabel;
    
    UIImageView *selectedImageCoverView;
    
    //
    UIFont *userNameLabelFont;
    UIColor *userNameLabelTextColor;
    
}

@end

@implementation LLAChooseActorCell

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
    userNameLabelFont = [UIFont systemFontOfSize:13];
    userNameLabelTextColor = [UIColor whiteColor];
    
}

- (void) initSubViews {
    
    userHeadImageView = [[UIImageView alloc] init];
    userHeadImageView.translatesAutoresizingMaskIntoConstraints = NO;
    userHeadImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.contentView addSubview:userHeadImageView];
    
    viewDetailButton = [[UIButton alloc] init];
    viewDetailButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [viewDetailButton setImage:[UIImage llaImageWithName:viewDetailButtonImageName_Normal] forState:UIControlStateNormal];
    [viewDetailButton setImage:[UIImage llaImageWithName:viewDetailButtonImageName_Highlight] forState:UIControlStateHighlighted];
    
    [viewDetailButton addTarget:self action:@selector(viewUserProfile:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:viewDetailButton];
    
    //
    userNameLabel = [[UILabel alloc] init];
    userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    userNameLabel.font = userNameLabelFont;
    userNameLabel.textColor = userNameLabelTextColor;
    userNameLabel.textAlignment = NSTextAlignmentLeft;
    
    selectedImageCoverView = [[UIImageView alloc] init];
    selectedImageCoverView.translatesAutoresizingMaskIntoConstraints = NO;
    
    selectedImageCoverView.image = [[UIImage llaImageWithName:selectedCoverImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 8, 8)];
    
    [self.contentView addSubview:selectedImageCoverView];
    
   
    
    [self.contentView addSubview:userNameLabel];
    
    [self.contentView bringSubviewToFront:viewDetailButton];
    
}

- (void) initSubConstraints {
    
    //
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[userHeadImageView]-(toBottom)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(imageViewToBottom),@"toBottom", nil]
      views:NSDictionaryOfVariableBindings(userHeadImageView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[selectedImageCoverView]-(toBottom)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(imageViewToBottom),@"toBottom", nil]
      views:NSDictionaryOfVariableBindings(selectedImageCoverView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toTop)-[viewDetailButton]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(viewDetailButtonToTop),@"toTop", nil]
      views:NSDictionaryOfVariableBindings(viewDetailButton)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[userNameLabel]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(userNameLabel)]];
    
    //horizonal
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[userHeadImageView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(userHeadImageView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[selectedImageCoverView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(selectedImageCoverView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[userNameLabel]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(userNameLabel)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[viewDtailButton]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:@(viewDetailButtonToRight),@"toRight", nil]
      views:NSDictionaryOfVariableBindings(viewDetailButton)]];
    
    [self.contentView addConstraints:constrArray];
    
    
}

#pragma mark - ButtonClicked

- (void) viewUserProfile:(UIButton *)sender {
    
}

@end
