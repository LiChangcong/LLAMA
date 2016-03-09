//
//  LLAScriptTopView.h
//  LLama
//
//  Created by tommin on 16/3/7.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LLATextView.h"


typedef NS_ENUM(NSInteger,LLAScriptTopViewType){
    LLAScriptTopViewType_Text,
    LLAScriptTopViewType_Image,
} ;

@class LLAScriptTopView;

@protocol LLAScriptTopViewDelegate <NSObject>


- (void) scriptTopViewDidTapImageView:(LLAScriptTopView *)topView;

- (void) scriptTopViewDidTapSecretButton:(LLAScriptTopView *)scriptTopView withSecretButton:(UIButton *) button;


@end

@interface LLAScriptTopView : UIView


@property(nonatomic , assign) LLAScriptTopViewType scriptTopViewType;

@property(nonatomic, weak)  UITextField *moneyTextField;

@property(nonatomic, weak)  LLATextView *scriptTextView;

@property(nonatomic, assign) BOOL isSeleced;

@property(nonatomic, weak) UIImageView *scriptImageView;

//- (void)startWithType:(LLAScriptTopViewType )scriptTopViewType;

@property(nonatomic, weak) id<LLAScriptTopViewDelegate> delegate;

- (instancetype)initWithType:(LLAScriptTopViewType)scriptTopViewType;
@end
