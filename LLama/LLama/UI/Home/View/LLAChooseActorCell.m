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

// 演员头像
static const CGFloat imageViewToBottom = 0;

// 演员详情按钮
static const CGFloat viewDetailButtonToTop = 4;
static const CGFloat viewDetailButtonToRight = 4;

// 演员名
static const CGFloat userNameLabelToBottom = 6;
static const CGFloat userNameLabelToLeft = 6;

@interface LLAChooseActorCell()
{
    // 演员头像
    UIImageView *userHeadImageView;
    
    // 演员详情按钮
    UIButton *viewDetailButton;
    
    // 演员名字
    UILabel *userNameLabel;
    
    //
    UIImageView *selectedImageCoverView;
    
    // 字体颜色
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
        // 设置变量
        [self initVariables];
        // 设置子控件
        [self initSubViews];
        // 设置约束
        [self initSubConstraints];
        
    }
    return self;
    
}

// 设置变量
- (void) initVariables {
    // 演员名字体和颜色
    userNameLabelFont = [UIFont systemFontOfSize:13];
    userNameLabelTextColor = [UIColor whiteColor];
    
}

// 设置子控件
- (void) initSubViews {
    
    // 用户头像
    userHeadImageView = [[UIImageView alloc] init];
    userHeadImageView.translatesAutoresizingMaskIntoConstraints = NO;
    userHeadImageView.contentMode = UIViewContentModeScaleAspectFill;
    userHeadImageView.clipsToBounds = YES;
    [self.contentView addSubview:userHeadImageView];
    
    // 演员详情按钮
    viewDetailButton = [[UIButton alloc] init];
    viewDetailButton.translatesAutoresizingMaskIntoConstraints = NO;
    [viewDetailButton setImage:[UIImage llaImageWithName:viewDetailButtonImageName_Normal] forState:UIControlStateNormal];
    [viewDetailButton setImage:[UIImage llaImageWithName:viewDetailButtonImageName_Highlight] forState:UIControlStateHighlighted];
    [viewDetailButton addTarget:self action:@selector(viewUserProfile:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:viewDetailButton];
    
    // 用户名
    userNameLabel = [[UILabel alloc] init];
    userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    userNameLabel.font = userNameLabelFont;
    userNameLabel.textColor = userNameLabelTextColor;
    userNameLabel.textAlignment = NSTextAlignmentLeft;
    userNameLabel.shadowOffset = CGSizeMake(1, 1);
    userNameLabel.shadowColor = [UIColor grayColor];
    [self.contentView addSubview:userNameLabel];
    
    // 选中演员图
    selectedImageCoverView = [[UIImageView alloc] init];
    selectedImageCoverView.translatesAutoresizingMaskIntoConstraints = NO;
    selectedImageCoverView.image = [[UIImage llaImageWithName:selectedCoverImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(60, 60, 8, 8)];
    [self.contentView addSubview:selectedImageCoverView];
    
    // 把演员详情按钮置前
    [self.contentView bringSubviewToFront:viewDetailButton];
    
}

// 设置约束
- (void) initSubConstraints {
    
    //
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //**********************vertical**********************
    
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
    
    //**********************horizonal**********************
    
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
// 点击了演员详情按钮
- (void) viewUserProfile:(UIButton *)sender {
    if (delegate && [delegate respondsToSelector:@selector(viewUserDetailWithUserInfo:)]) {
        [delegate viewUserDetailWithUserInfo:currentUserInfo];
    }
}

#pragma mark - Update Cell
// 设置信息
- (void) updateCellWithUserInfo:(LLAUser *)userInfo {
    //
    currentUserInfo = userInfo;
    
    // 设置头像
    [userHeadImageView setImageWithURL:[NSURL URLWithString:currentUserInfo.headImageURL] placeholderImage:[UIImage llaImageWithName:@"placeHolder_200"]];
    // 遥远名字
    userNameLabel.text = currentUserInfo.userName;
    // 选中按钮选中与否
    selectedImageCoverView.hidden = !currentUserInfo.hasBeenSelected;
    
}


#pragma mark - Calculate Height
// 计算高度
+ (CGFloat) calculateHeightWitthUserInfo:(LLAUser *)userInfo maxWidth:(CGFloat)maxWidth  {
    return MAX(0, maxWidth+imageViewToBottom);
}

@end
