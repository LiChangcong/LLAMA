//
//  LLAUserProfileSettingCell.m
//  LLama
//
//  Created by Live on 16/1/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUserProfileSettingCell.h"

#import "LLAUserProfileSettingItemInfo.h"

static NSString *const arrowImageName_Normal = @"arrowgreg";
static NSString *const arrowImageName_Highlight = @"arrowgregh";

//
static const CGFloat contentHeight = 56;
static const CGFloat sepLineHeight = 1.0;
static const CGFloat titleLabelToLeft = 25;

static const CGFloat detailLabelToRight = 10;
static const CGFloat arrowImageHeightWidth = 30;

@interface LLAUserProfileSettingCell()
{
    
    UILabel *titleLabel;
    UILabel *detailContentLabel;
    
    UIImageView *arrowImageView;
    
    UIView *sepLineView;
    
    //
    UIFont *titleLabelFont;
    UIColor *titleLabelTextColor;
    
    UIFont *detailContentLabelFont;
    UIColor *detailContentLabelTextColor;
    
    UIColor *lineColor;
}

@end

@implementation LLAUserProfileSettingCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];
        
    }
    
    return self;
    
}

- (void) initVariables {
    
    titleLabelFont = [UIFont llaFontOfSize:16];
    titleLabelTextColor = [UIColor colorWithHex:0x11111e];
    
    detailContentLabelFont = [UIFont llaFontOfSize:14];
    detailContentLabelTextColor = [UIColor colorWithHex:0xffc409];
 
    lineColor = [UIColor colorWithHex:0xededed];
}

- (void) initSubViews {
    
    titleLabel = [UILabel new];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.font = titleLabelFont;
    titleLabel.textColor = titleLabelTextColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:titleLabel];
    
    //
    detailContentLabel = [UILabel new];
    detailContentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    detailContentLabel.font = detailContentLabelFont;
    detailContentLabel.textColor = detailContentLabelTextColor;
    
    detailContentLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:detailContentLabel];
    
    //
    arrowImageView = [[UIImageView alloc] init];
    arrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    arrowImageView.image = [UIImage llaImageWithName:arrowImageName_Normal];
    arrowImageView.highlightedImage = [UIImage llaImageWithName:arrowImageName_Highlight];
    arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.contentView addSubview:arrowImageView];
    
    //
    sepLineView = [[UIView alloc] init];
    sepLineView.translatesAutoresizingMaskIntoConstraints = NO;
    sepLineView.backgroundColor = lineColor;
    
    [self.contentView addSubview:sepLineView];
    
    
}

- (void) initSubConstraints {
    
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[titleLabel]-(0)-[sepLineView(lineHeight)]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(sepLineHeight),@"lineHeight", nil]
      views:NSDictionaryOfVariableBindings(titleLabel,sepLineView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[detailContentLabel]-(0)-[sepLineView]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(sepLineHeight),@"lineHeight", nil]
      views:NSDictionaryOfVariableBindings(detailContentLabel,sepLineView)]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:arrowImageView
      attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationEqual
      toItem:detailContentLabel
      attribute:NSLayoutAttributeHeight
      multiplier:1.0
      constant:0]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:arrowImageView
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:detailContentLabel
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];
    
    //horizonal
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(toLeft)-[titleLabel]-(4)-[detailContentLabel(>=width)]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(titleLabelToLeft),@"toLeft",
               @(arrowImageHeightWidth),@"width",
               @(detailLabelToRight),@"toRight", nil]
      views:NSDictionaryOfVariableBindings(titleLabel,detailContentLabel)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[arrowImageView(width)]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(arrowImageHeightWidth),@"width",
               @(detailLabelToRight),@"toRight", nil]
      views:NSDictionaryOfVariableBindings(arrowImageView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[sepLineView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(sepLineView)]];
    
    [self.contentView addConstraints:constrArray];
    
}

#pragma mark - Update

- (void) updateCellWithItemInfo:(LLAUserProfileSettingItemInfo *)info shouldHideSepLine:(BOOL)hide{
    
    sepLineView.hidden = hide;
    
    //
    titleLabel.text = info.titleString;
    
    if (info.detailContentString) {
        arrowImageView.hidden = YES;
        detailContentLabel.hidden = NO;
        detailContentLabel.text = info.detailContentString;
    }else{
        arrowImageView.hidden = NO;
        detailContentLabel.hidden = YES;
        detailContentLabel.text = @"";
    }
    
}

#pragma mark - Calculate Height

+ (CGFloat) calculateHeightWihtItemInfo:(LLAUserProfileSettingItemInfo *)info {
    
    return contentHeight + sepLineHeight;
}

@end
