//
//  LLAVideoPickerCollectionCell.m
//  LLama
//
//  Created by Live on 16/1/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAVideoPickerCollectionCell.h"

#import "LLAPickVideoItemInfo.h"

static NSString *const cameraImageName = @"VideoSendIcon";

static const CGFloat cameraToLeft = 3;
static const CGFloat cameraToBottom = 5;

static const CGFloat timeLabelToRight = 5;
static const CGFloat timeLabelToBottom = 5;

@interface LLAVideoPickerCollectionCell()
{
    UIImageView *videoThumbView;
    
    UIImageView *cameraView;
    
    UILabel *timeLabel;
    
    //
    UIFont *timeLabelFont;
    UIColor *timeLabelTextColor;
}

@end

@implementation LLAVideoPickerCollectionCell

#pragma mark - Init

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];
    }
    
    return self;
}

- (void) initVariables {
    timeLabelFont = [UIFont llaFontOfSize:13];
    timeLabelTextColor = [UIColor whiteColor];
}

- (void) initSubViews {
    videoThumbView = [[UIImageView alloc] init];
    videoThumbView.translatesAutoresizingMaskIntoConstraints = NO;
    videoThumbView.contentMode = UIViewContentModeScaleAspectFill;
    videoThumbView.clipsToBounds = YES;
    
    [self.contentView addSubview:videoThumbView];
    
    cameraView = [[UIImageView alloc] init];
    cameraView.translatesAutoresizingMaskIntoConstraints = NO;
    cameraView.image = [UIImage llaImageWithName:cameraImageName];
    
    [self.contentView addSubview:cameraView];
    
    timeLabel = [[UILabel alloc] init];
    timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    timeLabel.font = timeLabelFont;
    timeLabel.textColor = timeLabelTextColor;
    timeLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:timeLabel];
    
}

- (void) initSubConstraints {
    
    //constraints
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[videoThumbView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(videoThumbView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[cameraView]-(toBottom)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toBottom":@(cameraToBottom)}
      views:NSDictionaryOfVariableBindings(cameraView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[timeLabel]-(toBottom)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toBottom":@(timeLabelToBottom)}
      views:NSDictionaryOfVariableBindings(timeLabel)]];
    
    //horizonal
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[cameraView]-(2)-[timeLabel]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toRight":@(timeLabelToRight),
                @"toLeft":@(cameraToLeft)}
      views:NSDictionaryOfVariableBindings(timeLabel,cameraView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[videoThumbView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(videoThumbView)]];
    
    [self.contentView addConstraints:constrArray];
    
    [cameraView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [timeLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
}

#pragma mark - Update

- (void) updateCellWithInfo:(LLAPickVideoItemInfo *)info {
    //
    videoThumbView.image = info.thumbImage;
    
    //format the time
    
    NSString *timeString = [NSString stringWithFormat:@"%01d:%02d",((int)info.videoDuration)/60,((int)info.videoDuration) % 60];
    
    timeLabel.text = timeString;
    
    
}

#pragma mark cell height

+ (CGFloat) calculateHeightWithInfo:(LLAPickVideoItemInfo *)info width:(CGFloat)width {
    return width;
}

@end
