//
//  LLAImagePickerCollectionCell.m
//  LLama
//
//  Created by tommin on 16/2/16.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAImagePickerCollectionCell.h"

#import "LLAPickImageItemInfo.h"
#import "LLAPickImageManager.h"

@interface LLAImagePickerCollectionCell()
{
    UIImageView *imageThumbView;
    
    UIButton *selectedButton;
}
@end

@implementation LLAImagePickerCollectionCell

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
    
    imageThumbView = [[UIImageView alloc] init];
    imageThumbView.translatesAutoresizingMaskIntoConstraints = NO;
    imageThumbView.contentMode = UIViewContentModeScaleAspectFill;
    imageThumbView.clipsToBounds = YES;
    [self.contentView addSubview:imageThumbView];
    
    // 扩大选中照片区域，点击cell的时候选中该cell
    imageThumbView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectButtonClick)];
    [imageThumbView addGestureRecognizer:tap];
    
    selectedButton = [[UIButton alloc] init];
    selectedButton.translatesAutoresizingMaskIntoConstraints = NO;
    [selectedButton setImage:[UIImage imageNamed:@"chosepicdot"] forState:UIControlStateNormal];
    [selectedButton setImage:[UIImage imageNamed:@"chosepicdoth"] forState:UIControlStateSelected];
    [selectedButton addTarget:self action:@selector(selectButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _selectedButtonFaceToPublich = selectedButton;
    [self.contentView addSubview:selectedButton];
    
}

- (void) initSubConstraints {
    
    //constraints
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[imageThumbView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(imageThumbView)]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(toTop)-[selectedButton]"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toTop":@(5)}
      views:NSDictionaryOfVariableBindings(selectedButton)]];
    
    //horizonal
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[selectedButton]-(toRight)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"toRight":@(5)}
      views:NSDictionaryOfVariableBindings(selectedButton)]];

    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[imageThumbView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(imageThumbView)]];
    
    [self.contentView addConstraints:constrArray];
    
}

#pragma mark - Update

- (void) updateCellWithInfo:(LLAPickImageItemInfo *)info {
    //
    selectedButton.selected = info.IsSelected;
    
    //load image from asset
//    [[LLAPickImageManager shareManager] photoFromAsset:info.asset completion:^(UIImage *resultImage, NSDictionary *info, BOOL isDegraded) {
//        imageThumbView.image = resultImage;
//    }];
    
    [[LLAPickImageManager shareManager] photoFromAsset:info.asset picWidth:[UIScreen mainScreen].bounds.size.width/3 completion:^(UIImage *resultImage, NSDictionary *info, BOOL isDegraded) {
        imageThumbView.image = resultImage;
    }];
    
}

#pragma mark cell height

+ (CGFloat) calculateHeightWithInfo:(LLAPickImageItemInfo *)info width:(CGFloat)width {
    return width;
}

- (void)selectButtonClick
{
    // 不要直接操作cell，要操作模型，那不是会带来循环利用的问题。
//    selectedButton.selected = !selectedButton.selected;
    
    // respondsToSelector:能判断某个对象是否实现了某个方法
    if ([self.delegate respondsToSelector:@selector(LLAImagePickerCollectionCellDidClickSelectedButton:andIndexPath:andButtonIsSelected:)]) {
        [self.delegate LLAImagePickerCollectionCellDidClickSelectedButton:self andIndexPath:_indexPath andButtonIsSelected:selectedButton.selected];
    }

}

@end
