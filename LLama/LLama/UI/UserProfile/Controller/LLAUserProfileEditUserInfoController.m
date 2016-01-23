//
//  LLAUserProfileEditUserInfoController.m
//  LLama
//
//  Created by Live on 16/1/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUserProfileEditUserInfoController.h"

//view
#import "LLAUserHeadView.h"
#import "LLATextView.h"

//model

//util
#import "LLAHttpUtil.h"

static const CGFloat topBackViewHeight = 150;

static const CGFloat headViewHeightWidth = 90;

static const CGFloat topBackViewToNameField = 11;
static const CGFloat userNameTextFieldHeight = 42;
static const CGFloat userNameFieldToUserDescVerSpace =14;
static const CGFloat userDescTextViewHeight = 127;

@interface LLAUserProfileEditUserInfoController()<LLAUserHeadViewDelegate>
{
    UIScrollView *backScrollView;
    
    UIView *topBackView;
    LLAUserHeadView *headView;
    
    UITextField *userNameTextField;
    LLATextView *userDescTextView;
    
    //
    UIFont *userNameTextFont;
    UIColor *userNameTextColor;
    
    UIFont *userDescTextFont;
    UIColor *userDescTextColor;
    
    UIFont *userDescPlaceHolderTextFont;
    UIColor *userDescPlaceHolderTextColor;
}

@end

@implementation LLAUserProfileEditUserInfoController

#pragma mark - Life Cycle

- (void) viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Init

- (void) initNavigationItems {
    
}

- (void) initVariables {
    
    userNameTextFont = [UIFont boldLLAFontOfSize:16];
    userNameTextColor = [UIColor colorWithHex:0x11111e];
    
    userDescTextFont = [UIFont llaFontOfSize:14];
    userDescTextColor = [UIColor colorWithHex:0x11111e];
    
    userDescPlaceHolderTextFont = [UIFont llaFontOfSize:14];
    userDescPlaceHolderTextColor = [UIColor colorWithHex:0xc6c6c6];
}

- (void) initSubViews {
    
    backScrollView = [[UIScrollView alloc] init];
    backScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    backScrollView.backgroundColor = [UIColor colorWithHex:0xebebeb];
    
    [self.view addSubview:backScrollView];
    
    //
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[backScrollView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(backScrollView)]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[backScrollView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(backScrollView)]];
    
    //
    [self initTopView];
    
}

- (void) initTopView {
    //
    topBackView = [[UIView alloc] init];
    
    topBackView.backgroundColor = [UIColor colorWithHex:0x11111e];
    
    [backScrollView addSubview:topBackView];
    
    headView = [[LLAUserHeadView alloc] init];
    headView.translatesAutoresizingMaskIntoConstraints = NO;
    headView.delegate = self;
    
    [topBackView addSubview:topBackView];
    
    //
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:headView
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:topBackView
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:headView
      attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationEqual
      toItem:nil
      attribute:NSLayoutAttributeNotAnAttribute
      multiplier:0
      constant:headViewHeightWidth]];
    
    //horizonal
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:headView
      attribute:NSLayoutAttributeCenterX
      relatedBy:NSLayoutRelationEqual
      toItem:topBackView
      attribute:NSLayoutAttributeCenterX
      multiplier:1.0
      constant:0]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:headView
      attribute:NSLayoutAttributeWidth
      relatedBy:NSLayoutRelationEqual
      toItem:nil
      attribute:NSLayoutAttributeNotAnAttribute
      multiplier:0
      constant:headViewHeightWidth]];
    
    [topBackView addConstraints:constrArray];
}


- (void) initInputInfoView {
    
    userNameTextField = [[UITextField alloc] init];
    userNameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    userNameTextField.font = userNameTextFont;
    userNameTextField.textAlignment = NSTextAlignmentCenter;
    userNameTextField.textColor = userNameTextColor;
    
    [backScrollView addSubview:userNameTextField];
    
    //
    userDescTextView = [[LLATextView alloc] init];
    userDescTextView.translatesAutoresizingMaskIntoConstraints = NO;
    userDescTextView.font = userDescTextFont;
    userDescTextView.textColor  = userDescTextColor;
    userDescTextView.placeholder = @"写一段关于你的个人简介";
    userDescTextView.originView = backScrollView;
    
    [backScrollView addSubview:userDescTextView];
    
    //constraints
    
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[topBackView(toBackHeight)]-(topBackToName)-[userNameTextField(nameHeight)]-(userNameToUserDesc)-[userDescTextView(userDescHeight)]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(topBackViewHeight),@"toBackHeight",
               @(topBackViewToNameField),@"topBackToName",
               @(userNameTextFieldHeight),@"nameHeight",
               @(userNameFieldToUserDescVerSpace),@"userNameToUserDesc",
               @(userDescTextViewHeight),@"userDescHeight", nil]
      views:NSDictionaryOfVariableBindings(topBackView,userNameTextField,userDescTextView)]];
    
    //horizonal
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[topBackView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(topBackView)]];
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:topBackView
      attribute:NSLayoutAttributeWidth
      relatedBy:NSLayoutRelationEqual
      toItem:backScrollView
      attribute:NSLayoutAttributeWidth
      multiplier:1.0
      constant:0]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[userNameTextField]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(userNameTextField)]];
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:userNameTextField
      attribute:NSLayoutAttributeWidth
      relatedBy:NSLayoutRelationEqual
      toItem:backScrollView
      attribute:NSLayoutAttributeWidth
      multiplier:1.0
      constant:0]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[userDescTextView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(userDescTextView)]];
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:userDescTextView
      attribute:NSLayoutAttributeWidth
      relatedBy:NSLayoutRelationEqual
      toItem:backScrollView
      attribute:NSLayoutAttributeWidth
      multiplier:1.0
      constant:0]];

    [backScrollView addConstraints:constrArray];
}

#pragma mark - LLAUserHeadViewDelegate

- (void) headView:(LLAUserHeadView *)headView clickedWithUserInfo:(LLAUser *)user {
    
    //show choose imageViewController
    
}

@end
