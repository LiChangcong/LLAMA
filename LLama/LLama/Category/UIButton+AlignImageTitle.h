//
//  UIButton+AlignImageTitle.h
//  LLama
//
//  Created by WanDa on 16/1/8.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (AlignImageTitle)

typedef NS_ENUM(NSInteger, UIButtonTitleImageType) {
    UIButtonTitleImageType_titleImageHorizontal = 0,    // 文字，图片水平排列
    UIButtonTitleImageType_titleImageVertical = 1,      // 文字，图片垂直排列
    UIButtonTitleImageType_imageTitleHorizontal = 2,    // 图片，文字水平排列
    UIButtonTitleImageType_imageTitleVertical = 3,      // 图片，文字垂直排列
};

- (void)setTitle:(NSString *)title
       withImage:(UIImage *)image
  titleImageType:(UIButtonTitleImageType)type
        forState:(UIControlState)state;


@end
