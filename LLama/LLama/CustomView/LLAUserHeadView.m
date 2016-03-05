//
//  LLAUserHeadView.m
//  LLama
//
//  Created by Live on 16/1/13.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUserHeadView.h"
#import "LLAUser.h"


static const CGFloat roleImageViewHeightWidth = 8;

@interface LLAUserHeadView()
{
    
}

@property(nonatomic , readwrite , strong) UIImageView *userHeadImageView;

@property(nonatomic , readwrite , strong) UIImageView *userRoleImageView;

@property(nonatomic , readwrite , strong)LLAUser *currentUser;


@end

@implementation LLAUserHeadView

@synthesize userHeadImageView,userRoleImageView;
@synthesize currentUser;
@synthesize delegate;


#pragma mark - Init

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    userHeadImageView.layer.cornerRadius = userHeadImageView.frame.size.height/2;

}

- (void) setupViews {
    [self initVariables];
    [self initSubViews];
    
    
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headViewTapped:)];
    
    [self addGestureRecognizer:tapGes];

}

- (void) initVariables {
    
}

- (void) initSubViews {
    
    userHeadImageView = [[UIImageView alloc] init];
    userHeadImageView.translatesAutoresizingMaskIntoConstraints = NO;
    userHeadImageView.contentMode = UIViewContentModeScaleAspectFill;
    userHeadImageView.clipsToBounds = YES;
    
    [self addSubview:userHeadImageView];
    
    //
    userRoleImageView = [[UIImageView alloc] init];
    userRoleImageView.translatesAutoresizingMaskIntoConstraints = NO;
    userRoleImageView.contentMode = UIViewContentModeScaleAspectFill;
    userRoleImageView.clipsToBounds = YES;
    userRoleImageView.layer.cornerRadius = roleImageViewHeightWidth/2;
    
    [self addSubview:userRoleImageView];
    
    //constraints
    
    NSMutableArray *constrArr = [NSMutableArray array];
    
    //vertical
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[userHeadImageView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(userHeadImageView)]];
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[userRoleImageView(height)]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(roleImageViewHeightWidth),@"height", nil]
      views:NSDictionaryOfVariableBindings(userRoleImageView)]];
    
    //horizonal
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[userHeadImageView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(userHeadImageView)]];
    
    [constrArr addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[userRoleImageView(width)]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(roleImageViewHeightWidth),@"width", nil]
      views:NSDictionaryOfVariableBindings(userRoleImageView)]];
    
    [self addConstraints:constrArr];
    
}

#pragma mark - Gesture

- (void) headViewTapped:(UITapGestureRecognizer *) ges {
    
    if (delegate && [delegate respondsToSelector:@selector(headView:clickedWithUserInfo:)]) {
        [delegate headView:self clickedWithUserInfo:currentUser];
    }
}

#pragma mark - Update

- (void) updateHeadViewWithUser:(LLAUser *)userInfo {
    currentUser = userInfo;
    
    if (userInfo == nil) {
        [userHeadImageView setImage:nil];
    }else {
        [userHeadImageView setImageWithURL:[NSURL URLWithString:currentUser.headImageURL] placeholderImage:[UIImage llaImageWithName:@"placeHolder_100"]];
        
        //role image
    }
}

@end
