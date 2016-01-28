//
//  LLACaptureVideoProgressView.m
//  LLama
//
//  Created by Live on 16/1/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLACaptureVideoProgressView.h"

#import "LLACaptureVideoClipInfo.h"

//blink interval
static const CGFloat blinkInterval = 1.0;

//
static const CGFloat limitViewWidth = 2;
static const CGFloat blinkIndicatorWidth = 2;

static const CGFloat sepLineWidth = 0.5;

@interface LLACaptureVideoProgressView()
{
    UIView *limitView;
    
    UIView *blinkIndicatorView;
    
    //
    NSTimer *blinkTimer;
    
    //
    UIColor *progressBackColor;
    
    UIColor *limitViewBKColor;
    UIColor *blinkIndicatorBKColor;
    
    UIColor *progressColor;
    UIColor *progressMarkColor;
    
    //
    NSLayoutConstraint *limitViewToLeftConstraint;
    NSLayoutConstraint *blinkViewToLeftConstraint;
}

@property(nonatomic , readwrite ,strong) NSMutableArray<LLACaptureVideoClipInfo *> *videoClipArray;

@end

@implementation LLACaptureVideoProgressView

@synthesize minSecond,maxSecond;
@synthesize videoClipArray;

#pragma mark - Life Cycle

- (void) layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat offsetX = 0;
    
    if (maxSecond > minSecond && maxSecond > 0 & minSecond > 0) {
        offsetX = minSecond/maxSecond * self.bounds.size.width;
    }else {
        offsetX = 0;
    }
    
    limitView.frame = CGRectMake(offsetX, 0, limitView.frame.size.width,limitView.frame.size.height);
    
}

#pragma mark - Init

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initVariables];
        [self initSubViews];
        [self initSubContraints];
        
        self.backgroundColor = progressBackColor;
    }
    
    return self;
}

- (void) initVariables {
    minSecond = 5.0;
    maxSecond = 60.0;
    //
    videoClipArray = [NSMutableArray array];
    //
    progressBackColor = [UIColor colorWithHex:0x18182d];
    
    limitViewBKColor = [UIColor whiteColor];
    blinkIndicatorBKColor = [UIColor whiteColor];
    
    progressColor = [UIColor whiteColor];
    progressMarkColor = [UIColor redColor];
    
}

- (void) initSubViews {
    
    limitView = [[UIView alloc] init];
    limitView.translatesAutoresizingMaskIntoConstraints = NO;
    limitView.backgroundColor = limitViewBKColor;
    
    [self addSubview:limitView];
    //
    blinkIndicatorView = [[UIView alloc] init];
    blinkIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    blinkIndicatorView.backgroundColor = blinkIndicatorBKColor;
    
    [self addSubview:blinkIndicatorView];
}

- (void) initSubContraints {
    //constran
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertail
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[limitView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(limitView)]];
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[blinkIndicatorView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(blinkIndicatorView)]];
    
    //horizonal
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[limitView(width)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toLeft":@(minSecond/maxSecond),
                @"width":@(limitViewWidth)}
      views:NSDictionaryOfVariableBindings(limitView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[blinkIndicatorView(width)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toLeft":@(0),
                @"width":@(blinkIndicatorWidth)}
      views:NSDictionaryOfVariableBindings(blinkIndicatorView)]];
    
    [self addConstraints:constrArray];
    
    //
    for(NSLayoutConstraint *constr in constrArray) {
        
        if (constr.firstAttribute == NSLayoutAttributeLeading && constr.firstItem == limitView) {
            limitViewToLeftConstraint = constr;
        }else if (constr.firstAttribute == NSLayoutAttributeLeading && constr.firstItem == blinkIndicatorView) {
            blinkViewToLeftConstraint = constr;
        }
    }
    
}

#pragma mark - Setter

- (void) setMinSecond:(CGFloat)second {
    minSecond = second;
    [self updateLimitViewPosition];
}

- (void) setMaxSecond:(CGFloat)second {
    maxSecond = second;
    //
    [self updateLimitViewPosition];
}

#pragma mark - Private Method

- (void) updateLimitViewPosition {
    if (maxSecond > minSecond && maxSecond > 0 & minSecond > 0) {
        limitViewToLeftConstraint.constant = minSecond/maxSecond * self.bounds.size.width;
    }else {
        limitViewToLeftConstraint.constant = 0;
    }
}

- (void) updateBlinkPosition {
    blinkViewToLeftConstraint.constant = [self calculateVideoClipTotalWidth];
}

- (CGFloat) calculateVideoClipTotalWidth {
    
    CGFloat width = 0;
    
    for (LLACaptureVideoClipInfo *clipInfo in videoClipArray) {
        width += clipInfo.sepLineView.frame.size.width;
        width += clipInfo.progressView.frame.size.width;
    }
    
    return width;
}

- (void) doBlinkIndicator:(NSTimer *) timer {
    
    blinkIndicatorView.alpha = 1.0;
    
    [UIView animateWithDuration:blinkInterval / 2 animations:^{
        
        blinkIndicatorView.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:blinkInterval / 2 animations:^{
            blinkIndicatorView.alpha = 1;
            
        }];
    }];
}

#pragma mark - Public Method

- (void) startBlinkIndicator {
    blinkIndicatorView.hidden = NO;
    blinkTimer = [NSTimer scheduledTimerWithTimeInterval:blinkInterval target:self selector:@selector(doBlinkIndicator:) userInfo:nil repeats:YES];
}

- (void) stopBlinkIndicator {
    [blinkTimer invalidate];
    blinkTimer = nil;
    blinkIndicatorView.alpha = 0;
    blinkIndicatorView.hidden = YES;
}

- (void) addVideoClipInfo {
    
    //if the last is marked,cancel it
    LLACaptureVideoClipInfo *last = [videoClipArray lastObject];
    last.shouldDelete = NO;
    last.progressView.backgroundColor = progressColor;
    
    //
    LLACaptureVideoClipInfo *clipInfo = [[LLACaptureVideoClipInfo alloc] init];
    clipInfo.videoClipDuration = 0;
    clipInfo.shouldDelete = NO;
    
    CGFloat offsetX = [self calculateVideoClipTotalWidth];
    if (videoClipArray.count > 0) {
        UIView *sepLineView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, 0, sepLineWidth, self.frame.size.height)];
        sepLineView.backgroundColor = self.backgroundColor;
        
        [self addSubview:sepLineView];
        
        clipInfo.sepLineView = sepLineView;
        
        offsetX += sepLineView.frame.size.width;
    }
    
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, 0, 0, self.frame.size.height)];
    progressView.backgroundColor = progressColor;
    
    [self addSubview:progressView];
    
    clipInfo.progressView = progressView;
    
    [videoClipArray addObject:clipInfo];
}

- (void) updateLastVideoClipInfoWithNewDuration:(CGFloat)duration {
    //get last
    LLACaptureVideoClipInfo *clipInfo = [videoClipArray lastObject];
    
    if (clipInfo) {
        clipInfo.videoClipDuration = duration;
        
        CGRect progressRect = clipInfo.progressView.frame;
        progressRect.size.width = clipInfo.videoClipDuration / maxSecond * self.bounds.size.width;
        clipInfo.progressView.frame = progressRect;
        
        [self updateBlinkPosition];
    }
    
}

- (void) deleteVideoClipInfo:(void (^)(BOOL))callback {
    
    LLACaptureVideoClipInfo *clipInfo = [videoClipArray lastObject];
    
    if (clipInfo) {
        
        if (clipInfo.shouldDelete) {
            //delete
            [clipInfo.sepLineView removeFromSuperview];
            [clipInfo.progressView removeFromSuperview];
            [videoClipArray removeLastObject];
            
            [self updateBlinkPosition];
            if (callback) {
                callback(YES);
            }
            
        }else {
            //mark to delete
            clipInfo.shouldDelete = YES;
            clipInfo.progressView.backgroundColor = progressMarkColor;
            if (callback) {
                callback(NO);
            }
        }
        
    }
    
}

@end
