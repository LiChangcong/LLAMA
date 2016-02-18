//
//  LLAUserAccountWithdrawCacheCell.m
//  LLama
//
//  Created by Live on 16/1/25.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUserAccountWithdrawCashCell.h"

static const CGFloat cashTextFieldToTop = 20;
static const CGFloat cashTextFieldHeight = 50;
static const CGFloat cashTextFieldToButtonVerSpace = 14;
static const CGFloat functionButtonHeight = 50;
static const CGFloat buttonToBrokerageLabelVerSpace = 10;
static const CGFloat brokerageLabelHeight = 14;
static const CGFloat brokerageLabelToBottom = 50;

static const CGFloat cashTextFieldToBorder = 10;
static const CGFloat functionButtonToBorder  = 60;

@interface LLAUserAccountWithdrawCashCell()
{
    UIButton *functionButton;
    UILabel *brokerageLabel;
    
    //
    UIFont *cashTextFieldFont;
    UIColor *cashTextFieldTextColor;
    
    UIFont *functionButtonFont;
    UIColor *functionButtonNormalTextColor;
    UIColor *functionButtonHighLightTextColor;
    UIColor *functionButtonDisableTextColor;
    
    UIColor *functionButtonNormalBKColor;
    UIColor *functionButtonHighLightBKColor;
    UIColor *functionButtonDisableBKColor;
    
    UIFont *brokerageLabelFont;
    UIColor *brokerageLablelTextColor;
}

@property(nonatomic , readwrite ,strong) UITextField *cashTextField;

@end

@implementation LLAUserAccountWithdrawCashCell
@synthesize cashTextField;
@synthesize delegate;

#pragma mark - Init

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentView.backgroundColor = [UIColor colorWithHex:0xeaeaea];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];
    }
    return self;
}

- (void) initVariables {
    
    cashTextFieldFont = [UIFont llaFontOfSize:18];
    cashTextFieldTextColor = [UIColor colorWithHex:0x11111e];
    
    functionButtonFont = [UIFont llaFontOfSize:18];
    functionButtonNormalTextColor = [UIColor colorWithHex:0x11111e];
    functionButtonHighLightTextColor = [UIColor whiteColor];
    functionButtonDisableTextColor = [UIColor whiteColor];
    
    functionButtonNormalBKColor = [UIColor themeColor];
    functionButtonHighLightBKColor = [UIColor colorWithHex:0xcbcccd];
    functionButtonDisableBKColor = [UIColor colorWithHex:0xcbcccd];
    
    brokerageLabelFont = [UIFont llaFontOfSize:12];
    brokerageLablelTextColor = [UIColor colorWithHex:0xb7b7b7];
    
}

- (void) initSubViews {
    
    cashTextField = [[UITextField alloc] init];
    cashTextField.translatesAutoresizingMaskIntoConstraints = NO;
    cashTextField.font = cashTextFieldFont;
    cashTextField.textColor = cashTextFieldTextColor;
    cashTextField.textAlignment = NSTextAlignmentRight;
    cashTextField.placeholder = @"最低单次提现金额100";
    cashTextField.leftViewMode = UITextFieldViewModeAlways;
    cashTextField.backgroundColor = [UIColor whiteColor];
    cashTextField.layer.cornerRadius = 4;
    cashTextField.rightViewMode = UITextFieldViewModeAlways;
    cashTextField.keyboardType = UIKeyboardTypeDecimalPad;
    //left View
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.font = cashTextFieldFont;
    leftLabel.textColor = cashTextFieldTextColor;
    leftLabel.text = @"提现(元)";
    leftLabel.textAlignment = NSTextAlignmentCenter;
    [leftLabel sizeToFit];
    
    leftLabel.frame = CGRectMake(0, 0, leftLabel.frame.size.width+6, leftLabel.frame.size.height);
    
    cashTextField.leftView = leftLabel;
    
    //
    //right view for fill
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, cashTextFieldHeight)];
    rightView.backgroundColor = cashTextField.backgroundColor;

    cashTextField.rightView = rightView;
    
    [self.contentView addSubview:cashTextField];
    
    //
    functionButton = [[UIButton alloc] init];
    functionButton.translatesAutoresizingMaskIntoConstraints = NO;
    functionButton.titleLabel.font = functionButtonFont;
    functionButton.layer.cornerRadius = 6;
    functionButton.clipsToBounds = YES;
    
    [functionButton setTitleColor:functionButtonNormalTextColor forState:UIControlStateNormal];
    [functionButton setTitleColor:functionButtonHighLightTextColor forState:UIControlStateHighlighted];
    [functionButton setTitleColor:functionButtonDisableTextColor forState:UIControlStateDisabled];
    
    [functionButton setBackgroundColor:functionButtonNormalBKColor forState:UIControlStateNormal];
    [functionButton setBackgroundColor:functionButtonHighLightBKColor forState:UIControlStateHighlighted ];
    [functionButton setBackgroundColor:functionButtonDisableBKColor forState:UIControlStateDisabled ];
    
    [functionButton setTitle:@"提 现" forState:UIControlStateNormal];
    
    [functionButton addTarget:self action:@selector(functionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:functionButton];
    
    //
    brokerageLabel = [[UILabel alloc] init];
    brokerageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    brokerageLabel.font = brokerageLabelFont;
    brokerageLabel.textColor = brokerageLablelTextColor;
    brokerageLabel.textAlignment = NSTextAlignmentCenter;
    brokerageLabel.text = @"LLama将收取5%的运营手续费";
    
    [self.contentView addSubview:brokerageLabel];
    
}

- (void) initSubConstraints {
    //
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toTop)-[cashTextField(textHeight)]-(textToButton)-[functionButton(buttonHeight)]-(buttonToBrokerage)-[brokerageLabel]-(toBottom)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(cashTextFieldToTop),@"toTop",
               @(cashTextFieldHeight),@"textHeight",
               @(cashTextFieldToButtonVerSpace),@"textToButton",
               @(functionButtonHeight),@"buttonHeight",
               @(buttonToBrokerageLabelVerSpace),@"buttonToBrokerage",
               @(brokerageLabelToBottom),@"toBottom", nil]
      views:NSDictionaryOfVariableBindings(cashTextField,functionButton,brokerageLabel)]];
    
    //horizonal
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toBorder)-[cashTextField]-(toBorder)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(cashTextFieldToBorder),@"toBorder", nil]
      views:NSDictionaryOfVariableBindings(cashTextField)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toBorder)-[functionButton]-(toBorder)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(functionButtonToBorder),@"toBorder", nil]
      views:NSDictionaryOfVariableBindings(functionButton)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toBorder)-[brokerageLabel]-(toBorder)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(4),@"toBorder", nil]
      views:NSDictionaryOfVariableBindings(brokerageLabel)]];
    
    [self.contentView addConstraints:constrArray];
    
}

#pragma mark - ButtonClicked

- (void) functionButtonClicked:(UIButton *) sender {
    
    if (delegate && [delegate respondsToSelector:@selector(withDrawcache)]) {
        [delegate withDrawcache];
    }
}

#pragma mark - Update

- (void) updateCellWithDrawCash:(NSInteger)cashNum {
    
    if (cashNum > 0) {
        functionButton.selected = YES;
    }else {
        functionButton.selected = NO;
    }
    cashTextField.text = [NSString stringWithFormat:@"%ld",(long)cashNum];
    
}

#pragma mark - CalculateHeight

+ (CGFloat) calculateCellHeight {
    
    return cashTextFieldToTop + cashTextFieldHeight + cashTextFieldToButtonVerSpace + functionButtonHeight + buttonToBrokerageLabelVerSpace + brokerageLabelHeight + brokerageLabelToBottom;
}

@end
