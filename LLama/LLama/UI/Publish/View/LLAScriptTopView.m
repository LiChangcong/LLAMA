//
//  LLAScriptTopView.m
//  LLama
//
//  Created by tommin on 16/3/7.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAScriptTopView.h"

@interface LLAScriptTopView()
{
    // 赏金整体
    UIView *moneyView;
    UIButton *moneyButton;
    UITextField *moneyTextField;
    UILabel *moneyYuanLabel;
    
    // 剧本整体
    UIView *scriptView;
    LLATextView *scriptTextView;
    UIImageView *scriptImageView;
    
    // 私密整体
    UIView *secretView;
    UIButton *secretButton;
    
    
    UIColor *moneyViewBackgroundColor;
    UIColor *yuanLabelColor;
    UIColor *scriptTextViewBackgroundColor;
    
    UIFont *yuanLabelFont;
    UIFont *textFieldFont;
    UIFont *scriptTextViewFont;
    
    
}
@end

@implementation LLAScriptTopView

//- (void)startWithType:(LLAScriptTopViewType)scriptTopViewType
//{
//    [self initVariables];
//    [self initSubViews];
//    [self initSubConstraints];
//}

//- (instancetype)init
//{
//
//}

- (instancetype)initWithType:(LLAScriptTopViewType)scriptTopViewType
{
    if(self = [super init]) {
        self.scriptTopViewType = scriptTopViewType;
        
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];
        
    }
    return self;
}
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        
//        [self initVariables];
//        [self initSubViews];
//        [self initSubConstraints];
//    }
//    
//    return self;
//}

- (void)initVariables
{
    
    moneyViewBackgroundColor = [UIColor colorWithHex:0x3d3b4c];
    
    yuanLabelColor = [UIColor colorWithHex:0xffffff];
    yuanLabelFont = [UIFont systemFontOfSize:12];
    
    textFieldFont = [UIFont systemFontOfSize:21];
    
    
    scriptTextViewBackgroundColor = [UIColor colorWithHex:0x1e1e1e];
    scriptTextViewFont = [UIFont systemFontOfSize:14];

}

- (void)initSubViews
{
    moneyView = [[UIView alloc] init];
    moneyView.backgroundColor = moneyViewBackgroundColor;
    [self addSubview:moneyView];
    
    moneyButton = [[UIButton alloc] init];
    [moneyButton setBackgroundImage:[UIImage imageNamed:@"publish_bounty"] forState:UIControlStateNormal];
    moneyButton.userInteractionEnabled = NO;
    [moneyButton setTitle:@"赏金" forState:UIControlStateNormal];
    
    [moneyView addSubview:moneyButton];
    
    moneyTextField = [[UITextField alloc] init];
    moneyTextField.font = textFieldFont;
    moneyTextField.textColor = [UIColor whiteColor];
    moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
    moneyTextField.textAlignment = NSTextAlignmentRight;
    moneyTextField.placeholder = @"点击此处输入金额";
    [moneyTextField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    [moneyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.moneyTextField = moneyTextField;
    [moneyView addSubview:moneyTextField];
    
    moneyYuanLabel = [[UILabel alloc] init];
    moneyYuanLabel.text = @"元";
    moneyYuanLabel.font = yuanLabelFont;
    moneyYuanLabel.textColor = yuanLabelColor;
    [moneyView addSubview:moneyYuanLabel];
    
    
    /*--------------------*/
    scriptView = [[UIView alloc] init];
    [self addSubview:scriptView];
    
    scriptTextView = [[LLATextView alloc] init];
    scriptTextView.backgroundColor = scriptTextViewBackgroundColor;
    scriptTextView.font =scriptTextViewFont;
    [scriptTextView setTextColor:[UIColor whiteColor]];
    scriptTextView.placeholder = @"这里写剧本";
    self.scriptTextView = scriptTextView;
    [scriptView addSubview:scriptTextView];
    
    scriptImageView = [[UIImageView alloc] init];
    self.scriptImageView = scriptImageView;
    scriptImageView.userInteractionEnabled = YES;
    [scriptView addSubview:scriptImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScriptImageView)];
    [scriptImageView addGestureRecognizer:tap];

    /*-----------------------*/
    secretView = [[UIView alloc] init];
    secretView.userInteractionEnabled = YES;
    [self addSubview:secretView];
    
    secretButton = [[UIButton alloc] init];
    [secretButton setImage:[UIImage imageNamed:@"publish_knock"] forState:UIControlStateNormal];
    [secretButton setImage:[UIImage imageNamed:@"publish_publish_knockh"] forState:UIControlStateSelected];
    [secretButton addTarget:self action:@selector(secretButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [secretView addSubview:secretButton];
    
    
    
}

- (void)initSubConstraints
{

    /*------------------------money------------------------*/
    [moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.right.equalTo(self);
        make.height.equalTo(@54);
    }];
    
    [moneyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyView);
        make.centerY.equalTo(moneyView);
        make.width.equalTo(@70);
        make.height.equalTo(@32);
    }];
    
    [moneyYuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-30);
        make.centerY.equalTo(moneyButton);
        make.height.equalTo(moneyButton);
    }];
    
    [moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyButton).with.offset(10);
        make.right.equalTo(moneyYuanLabel.mas_left).with.offset(-30);
        make.centerY.equalTo(moneyButton);
        make.height.equalTo(moneyButton);
    }];
    
    /*------------------------script------------------------*/
    [scriptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@100);
    }];

    
    if (self.scriptTopViewType == LLAScriptTopViewType_Text) {
        
        [scriptTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.left.equalTo(@20);
            make.right.equalTo(scriptView).with.offset(- 20);
            make.bottom.equalTo(scriptView.mas_bottom).with.offset(10);
        }];
        
    }else if (self.scriptTopViewType == LLAScriptTopViewType_Image){
    
        [scriptTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.left.equalTo(@20);
            make.right.equalTo(scriptImageView.mas_left).with.offset(-10);
            make.bottom.equalTo(scriptView.mas_bottom).with.offset(10);
        }];

        [scriptImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(scriptTextView);
            make.left.equalTo(scriptTextView.mas_right).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-20);
            make.width.height.equalTo(@94);
        }];

    }

    /*------------------------secretView------------------------*/
    [secretView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scriptView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@50);
    }];
    
    [secretButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.centerY.equalTo(secretView);
        make.width.height.equalTo(@30);
    }];

}

- (void)secretButtonClick
{
//    secretButton.selected = !secretButton.selected;

    if ([self.delegate respondsToSelector:@selector(scriptTopViewDidTapSecretButton: withSecretButton:)]) {
        [self.delegate scriptTopViewDidTapSecretButton:self withSecretButton:secretButton];
    }

}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == moneyTextField) {
        
        if (textField.text.length > 6) {
            //            [LLAViewUtil showAlter:self.view withText:@"金额须小于6个字符"];
            textField.text = [textField.text substringToIndex:6];
        }
    }
}

- (void)tapScriptImageView
{
    
    if ([self.delegate respondsToSelector:@selector(scriptTopViewDidTapImageView:)]) {
        [self.delegate scriptTopViewDidTapImageView:self];
    }

}

@end
