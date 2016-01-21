//
//  LLAUserProfileMyFunctionCell.m
//  LLama
//
//  Created by Live on 16/1/21.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUserProfileMyFunctionCell.h"

#import "LLAUser.h"

static NSString *const propertyButtonImageName_Normal = @"";
static NSString *const propertyButtonImageName_Highlight = @"";

static NSString *const orderListButtonImageName_Normal = @"";
static NSString *const orderListButtonImageName_Highlight = @"";

//
static const CGFloat functionButtonHeight = 40;
static const CGFloat verSepLineWidth = 2;
static const CGFloat verSepLineToTop = 6;
static const CGFloat horSepLineHeight = 2;
static const CGFloat horSepLineToBorder = 12;

@interface LLAUserProfileMyFunctionCell()

{
    UIButton *propertyButton;
    
    UIButton *orderListButton;
    
    UIView *verSepLineView;
    UIView *horSepLineView;
    
    //
    UIFont *functionButtonFont;
    UIColor *functionButtonNormalTextColor;
    UIColor *functionButtonHighlightTextColor;
    
    UIColor *sepLineColor;
    
    //
    LLAUser *currentUser;
}

@end

@implementation LLAUserProfileMyFunctionCell

@synthesize delegate;

#pragma mark - Init

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        if (self) {
            
            self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [self initVariables];
            [self initSubViews];
            [self initSubConstraints];
            
        }
        return self;

    }
    return self;
}

- (void) initVariables{

    functionButtonFont = [UIFont llaFontOfSize:18];
    functionButtonNormalTextColor = [UIColor colorWithHex:0x11111e alpha:1.0];
    functionButtonHighlightTextColor = [UIColor colorWithHex:0x11111e alpha:0.8];
    
    sepLineColor = [UIColor colorWithHex:0xededed];
    
}

- (void) initSubViews {
    
    propertyButton = [[UIButton alloc] init];
    propertyButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    propertyButton.titleLabel.font = functionButtonFont;
    
    [propertyButton setTitleColor:functionButtonNormalTextColor forState:UIControlStateNormal];
    [propertyButton setTitleColor:functionButtonHighlightTextColor forState:UIControlStateHighlighted];
    
    [propertyButton setImage:[UIImage llaImageWithName:propertyButtonImageName_Normal] forState:UIControlStateNormal];
    [propertyButton setImage:[UIImage llaImageWithName:propertyButtonImageName_Highlight] forState:UIControlStateHighlighted];
    
    [propertyButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [propertyButton addTarget:self action:@selector(propertyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:propertyButton];
    
    //
    verSepLineView = [[UIView alloc] init];
    verSepLineView.translatesAutoresizingMaskIntoConstraints = NO;
    verSepLineView.backgroundColor = sepLineColor;
    
    [self.contentView addSubview:verSepLineView];
    
    //
    orderListButton = [[UIButton alloc] init];
    orderListButton.translatesAutoresizingMaskIntoConstraints = NO;
    orderListButton.titleLabel.font = functionButtonFont;
    
    [orderListButton setTitleColor:functionButtonNormalTextColor forState:UIControlStateNormal];
    [orderListButton setTitleColor:functionButtonHighlightTextColor forState:UIControlStateHighlighted];
    
    [orderListButton setImage:[UIImage llaImageWithName:orderListButtonImageName_Normal] forState:UIControlStateNormal];
    [orderListButton setImage:[UIImage llaImageWithName:orderListButtonImageName_Highlight] forState:UIControlStateHighlighted];
    
    [orderListButton setTitle:@" 订单" forState:UIControlStateNormal];
    
    [orderListButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [orderListButton addTarget:self action:@selector(orderListButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:orderListButton];
    
    //
    horSepLineView = [[UIView alloc] init];
    horSepLineView.translatesAutoresizingMaskIntoConstraints = NO;
    horSepLineView.backgroundColor = sepLineColor;
    
    [self.contentView addSubview:horSepLineView];
    
    
}

- (void) initSubConstraints {
    
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[propertyButton]-(0)-[horSepLineView(lineHeight)]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(horSepLineHeight),@"lineHeight", nil]
      views:NSDictionaryOfVariableBindings(propertyButton,horSepLineView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toTop)-[verSepLineView]-(0)-[horSepLineView]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(verSepLineToTop),@"toTop", nil]
      views:NSDictionaryOfVariableBindings(verSepLineView,horSepLineView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[orderListButton]-(0)-[horSepLineView]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(orderListButton,horSepLineView)]];
    
    //horizonal
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[propertyButton(==orderListButton)]-(0)-[verSepLineView(lineWidth@999)]-(0)-[orderListButton]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(verSepLineWidth),@"lineWidth", nil]
      views:NSDictionaryOfVariableBindings(propertyButton,verSepLineView,orderListButton)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toBorder)-[horSepLineView]-(toBorder)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(horSepLineToBorder),@"toBorder", nil]
      views:NSDictionaryOfVariableBindings(horSepLineView)]];
    
    [self.contentView addConstraints:constrArray];
    
}
#pragma mark - ButtonClicked

- (void) propertyButtonClicked:(UIButton *) sender {
    if (delegate && [delegate respondsToSelector:@selector(showPersonalPropertyWithUserInfo:)]) {
        [delegate showPersonalPropertyWithUserInfo:currentUser];
    }
}

- (void) orderListButtonClicked:(UIButton *) sender {
    
    if (delegate && [delegate respondsToSelector:@selector(showPersonalOrderListWithUserInfo:)]) {
        [delegate showPersonalOrderListWithUserInfo:currentUser];
    }
}

#pragma mark - Update

- (void) updateCellWithUserInfo:(LLAUser *)userInfo tableWidth:(CGFloat)tableWidth {
    
    currentUser = userInfo;
    
    [propertyButton setTitle:[NSString stringWithFormat:@" %.0f",userInfo.balance] forState:UIControlStateNormal];
}

#pragma mark - Calculate

+ (CGFloat) calculateHeightWithUserInfo:(LLAUser *)userInfo tableWidth:(CGFloat)tableWidth {
    return functionButtonHeight + horSepLineHeight;
}

@end
