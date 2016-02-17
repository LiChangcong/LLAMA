//
//  LLAEditVideoScaleView.m
//  LLama
//
//  Created by Live on 16/2/16.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAEditVideoScaleView.h"

static const CGFloat lineHeight = 1.5;
static const CGFloat lineWidth = 1.5;

static const NSInteger verLineTagThreshold = 10000;
static const NSInteger horLineTagThreshold = 20000;

static const NSInteger maxLines = 4;

@interface LLAEditVideoScaleView()
{
    UIColor *lineColor;
}

@end

@implementation LLAEditVideoScaleView

#pragma mark - Init

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        
        [self initVariables];
        [self initLineViews];
    }
    
    return self;
}

- (void) initVariables {
    lineColor = [UIColor colorWithHex:0xffffff alpha:0.6];
}

- (void) initLineViews {
    
    for (int i=0; i < maxLines; i++) {
        
        //vertical lines
        UIView *verLine = [[UIView alloc] init];
        verLine.backgroundColor = lineColor;
        verLine.tag = verLineTagThreshold + i;
        
        [self addSubview:verLine];
        
        //horizonal lines
        UIView *horLine = [[UIView alloc] init];
        horLine.backgroundColor = lineColor;
        horLine.tag = horLineTagThreshold + i;
        
        [self addSubview:horLine];
    }
    
}

#pragma mark - layout subViews

- (void) layoutSubviews {
    
    [super layoutSubviews];
    
    for (int i=0;i<maxLines;i++) {
        
        UIView *verLine = [self viewWithTag:verLineTagThreshold+i];
        UIView *horLine = [self viewWithTag:horLineTagThreshold+i];
        
        //
        CGRect verLineFrame = CGRectMake(((float)i)/(maxLines-1)*self.bounds.size.width, 0, lineWidth, self.bounds.size.height);
        CGRect horLineFrame = CGRectMake(0, ((float)i)/(maxLines-1)*self.bounds.size.height, self.bounds.size.width, lineHeight);
        
        if (i == maxLines -1) {
            verLineFrame.origin.x -= lineWidth;
            horLineFrame.origin.y -= lineHeight;
            
        }else if(i>0) {
            verLineFrame.origin.x -= lineWidth/2;
            horLineFrame.origin.y -= lineHeight/2;
        }
        
        verLine.frame = verLineFrame;
        horLine.frame = horLineFrame;
        
    }
    
}

@end
