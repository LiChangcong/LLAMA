//
//  LLAUploadVideoProgressView.m
//  LLama
//
//  Created by Live on 16/1/31.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUploadVideoProgressView.h"



CGFloat LLAUploadVideoProgressViewHeight = 22;

static const CGFloat progressViewHeight = 3;

@interface LLAUploadVideoProgressView()
{
    UIView *progressBackView;
    UIView *progressLoadView;
    
    UILabel *tipsLabel;
    
    //
    UIColor *backColor;
    
    UIColor *progressBackViewBKColor;
    UIColor *progressLoadViewBKColor;
    
    UIFont *tipsLabelFont;
    UIColor *tipsLabelTextColor;
    
    //
    NSLayoutConstraint *loadedWidthConstraints;
    
}
@end

@implementation LLAUploadVideoProgressView

@synthesize delegate;

- (void) dealloc {
    [[LLAUploadVideoShareManager shareManager] removeScriptVideoUploadObserver:self];
    [[LLAUploadVideoShareManager shareManager] removeUserVideoUploadObserver:self];
}

- (instancetype) initWithViewType:(videoUploadType)type {
    self = [super init];
    if (self) {
        
        [self initVaraibles];
        [self initSubViews];
        [self initSubContraints];
        
        self.backgroundColor = backColor;
        
        if (type == videoUploadType_ScriptVideo) {
            [[LLAUploadVideoShareManager shareManager] addScriptVideoUploadObserver:self];
        }else {
            [[LLAUploadVideoShareManager shareManager] addUserVideoUploadObserver:self];
        }
        
        
    }
    
    return self;

}

- (void) initVaraibles {
    //
    
    backColor = [UIColor colorWithHex:0x202020 alpha:0.8];
    
    progressBackViewBKColor = [UIColor colorWithHex:0x5c5c5c];
    progressLoadViewBKColor = [UIColor colorWithHex:0xff0966];
    
    tipsLabelFont = [UIFont llaFontOfSize:12];
    tipsLabelTextColor = [UIColor whiteColor];

}

- (void) initSubViews {
    
    progressBackView = [[UIView alloc] init];
    progressBackView.translatesAutoresizingMaskIntoConstraints = NO;
    progressBackView.backgroundColor = progressBackViewBKColor;
    
    [self addSubview:progressBackView];
    
    progressLoadView = [[UIView alloc] init];
    progressLoadView.translatesAutoresizingMaskIntoConstraints = NO;
    progressLoadView.backgroundColor = progressLoadViewBKColor;
    
    [self addSubview:progressLoadView];
    
    tipsLabel = [[UILabel alloc] init];
    tipsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    tipsLabel.font = tipsLabelFont;
    tipsLabel.textColor = tipsLabelTextColor;
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:tipsLabel];
    
}

- (void) initSubContraints {
    
    //
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[progressBackView(height)]-(0)-[tipsLabel]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"height":@(progressViewHeight)}
      views:NSDictionaryOfVariableBindings(progressBackView,tipsLabel)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[progressLoadView(height)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"height":@(progressViewHeight)}
      views:NSDictionaryOfVariableBindings(progressLoadView)]];
    
    //horizonal
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[progressBackView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(progressBackView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[tipsLabel]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(tipsLabel)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[progressLoadView(0)]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(progressLoadView)]];
    
    [self addConstraints:constrArray];
    
    for (NSLayoutConstraint *constr in constrArray) {
        if (constr.firstAttribute == NSLayoutAttributeWidth && constr.firstItem == progressLoadView) {
            
            loadedWidthConstraints = constr;
            
            break;
        }
    }
    
}

#pragma mark - 
- (void) uploadVideoDidStart {
    self.hidden = NO;
    loadedWidthConstraints.constant = 0;
    
    tipsLabel.text = @"上传中";
}

- (void) uploadVideoProgressChange:(CGFloat) progress {
    self.hidden = NO;
    loadedWidthConstraints.constant = progress * progressBackView.bounds.size.width;
    tipsLabel.text = @"上传中";
    
}

- (void) uploadVideodidSuccess {
    loadedWidthConstraints.constant = self.bounds.size.width;
    self.hidden = YES;
    
    tipsLabel.text = @"上传成功";
    if (delegate && [delegate respondsToSelector:@selector(uploadVideoFinished:)]) {
        [delegate uploadVideoFinished:self];
    }
}

- (void) uploadVideoDidFailed {
    loadedWidthConstraints.constant = 0;
    self.hidden = YES;
    
    tipsLabel.text = @"上传失败";
    
    if (delegate && [delegate respondsToSelector:@selector(uploadVideoFailed:)]) {
        [delegate uploadVideoFailed:self];
    }

    
}


@end
