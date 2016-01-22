//
//  LLAUserProfileVideoHeaderView.m
//  LLama
//
//  Created by Live on 16/1/22.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUserProfileVideoHeaderView.h"


static const CGFloat indicatorViewHeight =  4;
static const CGFloat indicatorViewWidth = 6;

@interface LLAUserProfileVideoHeaderView()

{
    UIButton *dirctorVideoButton;
    UIButton *actorVideoButton;
    
    UIImageView *indicatorView;
    
    //
    UIFont *buttonFont;
    UIColor *buttonNormalTitleColor;
    UIColor *buttonHighLightTitleColor;
    
    //
    NSLayoutConstraint *indicatorCenterConstraints;
    
    //
    LLAUserProfileMainInfo *currentInfo;
}

@end

@implementation LLAUserProfileVideoHeaderView

@synthesize delegate;

#pragma mark - Init

- (instancetype) initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initVariables];
        [self initSubViews];
        [self initSubContraints];
    }
    return self;
}

- (void) initVariables {
    
    buttonFont = [UIFont boldLLAFontOfSize:18];
    
    buttonNormalTitleColor = [UIColor colorWithHex:0x11111e];
    buttonHighLightTitleColor = [UIColor themeColor];
    
    
    
}

- (void) initSubViews {
    
    dirctorVideoButton = [[UIButton alloc] init];
    dirctorVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    dirctorVideoButton.titleLabel.font = buttonFont;
    
    [dirctorVideoButton setTitleColor:buttonNormalTitleColor forState:UIControlStateNormal];
    [dirctorVideoButton setTitleColor:buttonHighLightTitleColor forState:UIControlStateHighlighted];
    [dirctorVideoButton setTitleColor:buttonHighLightTitleColor forState:UIControlStateSelected];
    
    [dirctorVideoButton addTarget:self action:@selector(directorButtonClikced:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:dirctorVideoButton];
    
    //
    actorVideoButton = [[UIButton alloc] init];
    actorVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    actorVideoButton.titleLabel.font = buttonFont;
    
    [actorVideoButton setTitleColor:buttonNormalTitleColor forState:UIControlStateNormal];
    [actorVideoButton setTitleColor:buttonHighLightTitleColor forState:UIControlStateHighlighted];
    [actorVideoButton setTitleColor:buttonHighLightTitleColor forState:UIControlStateSelected];
    
    [actorVideoButton addTarget:self action:@selector(actorButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:actorVideoButton];
    
    //
    indicatorView = [[UIImageView alloc] init];
    indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    
    indicatorView.image = [UIImage llaImageWithName:@""];
    indicatorView.backgroundColor = [UIColor lightGrayColor];
    
    [self.contentView addSubview:indicatorView];
    
    
}

- (void) initSubContraints {
    
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[dirctorVideoButton]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dirctorVideoButton)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[actorVideoButton]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(actorVideoButton)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[indicatorView(height)]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:@(indicatorViewHeight),@"height", nil]
      views:NSDictionaryOfVariableBindings(indicatorView)]];
    
    //horizonal
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[dirctorVideoButton(==actorVideoButton)]-(0)-[actorVideoButton]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dirctorVideoButton,actorVideoButton)]];
    
    
    //
    indicatorCenterConstraints  = [NSLayoutConstraint
                                   constraintWithItem:indicatorView
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.contentView
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0
                                   constant:0];
    [constrArray addObject:indicatorCenterConstraints];
    
    [constrArray addObject:[NSLayoutConstraint
                            constraintWithItem:indicatorView
                            attribute:NSLayoutAttributeWidth
                            relatedBy:NSLayoutRelationEqual
                            toItem:nil
                            attribute:NSLayoutAttributeNotAnAttribute
                            multiplier:0
                            constant:indicatorViewWidth]];
    
    [self.contentView addConstraints:constrArray];
    
}

#pragma mark - ButtonClick

- (void) actorButtonClicked:(UIButton *) sender {
    
    if (delegate && [delegate respondsToSelector:@selector(showVideosWithType:)]) {
        [delegate showVideosWithType:UserProfileHeadVideoType_Actor];
    }
    
    [self updateHeaderWithUserInfo:currentInfo tableWidth:self.contentView.frame.size.width];
    
}

- (void) directorButtonClikced:(UIButton *) sender {
    
    if (delegate && [delegate respondsToSelector:@selector(showVideosWithType:)]) {
        [delegate showVideosWithType:UserProfileHeadVideoType_Director];
    }
    
    [self updateHeaderWithUserInfo:currentInfo tableWidth:self.contentView.frame.size.width];

}

#pragma mark - Update

- (void) updateHeaderWithUserInfo:(LLAUserProfileMainInfo *)mainInfo tableWidth:(CGFloat)tableWidth {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        if (mainInfo.showingVideoType == UserProfileHeadVideoType_Director) {
            indicatorCenterConstraints.constant = tableWidth/4;
        }else {
            indicatorCenterConstraints.constant = tableWidth * 3/4;
        }
        
        [self.contentView layoutIfNeeded];
        [self.contentView setNeedsLayout];
        
    } completion:^(BOOL finished) {
        
    }];
    
    currentInfo = mainInfo;
    
    if ([mainInfo.userInfo isEqual:[LLAUser me]]) {
        [dirctorVideoButton setTitle:@"我导的片儿" forState:UIControlStateNormal];
        [actorVideoButton setTitle:@"我演的片儿" forState:UIControlStateNormal];
    }else {
        [dirctorVideoButton setTitle:@"TA导的片儿" forState:UIControlStateNormal];
        [actorVideoButton setTitle:@"TA演的片儿" forState:UIControlStateNormal];
    }
    
    if (mainInfo.showingVideoType == UserProfileHeadVideoType_Director) {
        dirctorVideoButton.selected = YES;
        dirctorVideoButton.userInteractionEnabled = NO;
        
        actorVideoButton.selected = NO;
        actorVideoButton.userInteractionEnabled = YES;
        
    }else {
        dirctorVideoButton.selected = NO;
        dirctorVideoButton.userInteractionEnabled = YES ;
        
        actorVideoButton.selected = YES;
        actorVideoButton.userInteractionEnabled = NO;
    }
}

#pragma mark - CalculateHeight

+ (CGFloat) calculateHeightWithUserInfo:(LLAUserProfileMainInfo *)mainInfo tableWidth:(CGFloat)tableWidth {
    return 60;
}

@end
