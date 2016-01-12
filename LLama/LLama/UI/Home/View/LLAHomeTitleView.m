//
//  LLAHomeTitleView.m
//  LLama
//
//  Created by Live on 16/1/12.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAHomeTitleView.h"

static const CGFloat indicatorViewHeight = 2;
static const CGFloat itemWidth = 50;
static const CGFloat itemsHorSpace = 80;
static const CGFloat itemHeight = 36;

static const NSInteger tagThreshold = 10000;

@interface LLAHomeTitleView()
{
    NSArray *titlesArray;
    
    UIView *indicatorView;
    
    //
    UIFont *itemFont;
    UIColor *selectedColor;
    UIColor *unSelectedColor;
    
    //
    
}

@end

@implementation LLAHomeTitleView

@synthesize delegate;

- (instancetype) initWithTitles:(NSArray<NSString *> *)titles {
    self = [super init];
    if (self) {
        
        titlesArray = [titles copy];
        
        [self initVariables];
        [self initSubView];
    }
    
    return self;
}

- (void) initVariables {
    itemFont = [UIFont llaFontOfSize:20];
    selectedColor = [UIColor themeColor];
    unSelectedColor = [UIColor whiteColor];
}

- (void) initSubView {
    
    for (int i=0;i<titlesArray.count;i++) {
        
        NSString *title = titlesArray[i];
        
        UIButton *itemButton = [[UIButton alloc] init];
        itemButton.clipsToBounds = YES;
        itemButton.tag = tagThreshold + i;
        
        CGRect buttonframe = CGRectMake(i*(itemsHorSpace+itemWidth), 0, itemWidth, itemHeight);
        itemButton.frame = buttonframe;
        
        itemButton.titleLabel.font = itemFont;
        
        [itemButton setTitle:title forState:UIControlStateNormal];
        [itemButton setTitleColor:selectedColor forState:UIControlStateHighlighted];
        [itemButton setTitleColor:selectedColor forState:UIControlStateSelected];
        [itemButton setTitleColor:unSelectedColor forState:UIControlStateNormal];
        [itemButton addTarget:self action:@selector(itemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:itemButton];
        
        if (i==0) {
            itemButton.selected = YES;
        }else{
            itemButton.selected = NO;
        }
        
    }
    //indicator
    indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = selectedColor;
    indicatorView.frame = CGRectMake(0, itemHeight, itemWidth, indicatorViewHeight);
    [self addSubview:indicatorView];
    
    
}

- (void) itemButtonClicked:(UIButton *)sender {
    if (sender.tag-tagThreshold >= 0){
        if (delegate && [delegate respondsToSelector:@selector(titleView:didSelectedIndex:)]) {
            [delegate titleView:self didSelectedIndex:sender.tag - tagThreshold];
        }
    }
}

- (void) scrollWithProportion:(CGFloat)propotion {
    
    CGRect indicatorFrame = indicatorView.frame;
    indicatorFrame.origin.x = propotion*(itemWidth+itemsHorSpace);
    indicatorView.frame = indicatorFrame;
    
    //shoulSelectedIndex
    
    NSInteger index = (int) propotion;
    
    for (int i=0;i<titlesArray.count;i++) {
        
        UIButton *itemButton = [self viewWithTag:i+tagThreshold];
        if (i==index){
            itemButton.selected = YES;
        }else {
            itemButton.selected = NO;
        }
    }
    
}

- (CGSize) sizeThatFits:(CGSize)size {
    
    CGFloat width = titlesArray.count*itemWidth + MAX(0,titlesArray.count-1)*itemsHorSpace;
    
    return CGSizeMake(width, itemHeight+indicatorViewHeight);
    
}

@end
