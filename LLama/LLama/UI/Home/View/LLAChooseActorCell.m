//
//  LLAChooseActorCell.m
//  LLama
//
//  Created by Live on 16/1/18.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAChooseActorCell.h"

#import "LLAUser.h"

static NSString *const viewDetailButtonImageName_Normal = @"view_profile";
static NSString *const viewDetailButtonImageName_Highlight = @"view_profileH";

static NSString *const selectedCoverImageName = @"winner";

//
static const CGFloat imageViewToBottom = 0;

static const CGFloat viewDetailButtonToTop = 4;
static const CGFloat viewDetailButtonToRight = 4;

static const CGFloat userNameLabelToBottom = 6;
static const CGFloat userNameLabelToLeft = 6;

@interface LLAChooseActorCell()
{
    UIImageView *userHeadImageView;
    UIButton *viewDetailButton;
    UILabel *userNameLabel;
    
    UIImageView *selectedImageCoverView;
    
    //
    UIFont *userNameLabelFont;
    UIColor *userNameLabelTextColor;
    
    //
    LLAUser *currentUserInfo;
    
}

@end

@implementation LLAChooseActorCell

@synthesize delegate;

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
    userHeadImageView.clipsToBounds = YES;
    
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
    [self.contentView addSubview:userNameLabel];
    
    selectedImageCoverView = [[UIImageView alloc] init];
    selectedImageCoverView.translatesAutoresizingMaskIntoConstraints = NO;
    
    selectedImageCoverView.image = [[UIImage llaImageWithName:selectedCoverImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(60, 60, 8, 8)];
    
    [self.contentView addSubview:selectedImageCoverView];
    
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
      constraintsWithVisualFormat:@"V:[userNameLabel]-(toBottom)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:@(userNameLabelToBottom),@"toBottom", nil]
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
      constraintsWithVisualFormat:@"H:|-(toLeft)-[userNameLabel]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:@(userNameLabelToLeft),@"toLeft", nil]
      views:NSDictionaryOfVariableBindings(userNameLabel)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[viewDetailButton]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:@(viewDetailButtonToRight),@"toRight", nil]
      views:NSDictionaryOfVariableBindings(viewDetailButton)]];
    
    [self.contentView addConstraints:constrArray];
    
    
}

#pragma mark - ButtonClicked

- (void) viewUserProfile:(UIButton *)sender {
    if (delegate && [delegate respondsToSelector:@selector(viewUserDetailWithUserInfo:)]) {
        [delegate viewUserDetailWithUserInfo:currentUserInfo];
    }
}

#pragma mark - Update Cell

- (void) updateCellWithUserInfo:(LLAUser *)userInfo {
    //
    currentUserInfo = userInfo;
    
    //
    [userHeadImageView setImageWithURL:[NSURL URLWithString:currentUserInfo.headImageURL] placeholderImage:[UIImage llaImageWithName:@"placeHolder_200"]];
    
    userNameLabel.text = currentUserInfo.userName;
    
    selectedImageCoverView.hidden = !currentUserInfo.hasBeenSelected;
    
}


#pragma mark - Calculate Height

+ (CGFloat) calculateHeightWitthUserInfo:(LLAUser *)userInfo maxWidth:(CGFloat)maxWidth  {
    return MAX(0, maxWidth+imageViewToBottom);
}

@end
