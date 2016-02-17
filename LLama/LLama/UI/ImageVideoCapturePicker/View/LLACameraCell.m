//
//  LLACameraCell.m
//  LLama
//
//  Created by tommin on 16/2/17.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLACameraCell.h"

@interface LLACameraCell()
{
    UIButton *cameraButton;
}
@end

@implementation LLACameraCell

#pragma mark - Init

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self initSubViews];
        [self initSubConstraints];
    }
    
    return self;
}

- (void) initSubViews {
    
    cameraButton = [[UIButton alloc] init];
    cameraButton.translatesAutoresizingMaskIntoConstraints = NO;
    [cameraButton setImage:[UIImage imageNamed:@"takepic"] forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:@"takepich"] forState:UIControlStateSelected];
    [cameraButton addTarget:self action:@selector(cameraButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cameraButton];
    
}
- (void) initSubConstraints {
    
    //constraints
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[cameraButton]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(cameraButton)]];
    
    //horizonal
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[cameraButton]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(cameraButton)]];
    
    [self.contentView addConstraints:constrArray];
    
}

- (void)cameraButtonClick
{
    if ([self.delegate respondsToSelector:@selector(LLACameraCellDidClickCameraCell:)]) {
        [self.delegate LLACameraCellDidClickCameraCell:self];
    }
}


@end
