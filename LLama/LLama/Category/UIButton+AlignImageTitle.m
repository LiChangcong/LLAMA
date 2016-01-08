//
//  UIButton+AlignImageTitle.m
//  LLama
//
//  Created by WanDa on 16/1/8.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "UIButton+AlignImageTitle.h"

@implementation UIButton (AlignImageTitle)

- (void)setTitle:(NSString *)title
       withImage:(UIImage *)image
  titleImageType:(UIButtonTitleImageType)type
        forState:(UIControlState)state {
    [self setTitle:title forState:state];
    [self setImage:image forState:state];
    CGSize imageSize = image.size;
    UIFont *font = self.titleLabel.font;
    NSDictionary *fontDict = @{NSFontAttributeName : font};
    CGSize textSize = [title sizeWithAttributes:fontDict];
    
    switch (type) {
        case UIButtonTitleImageType_titleImageHorizontal: {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, textSize.width, 0, -textSize.width);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width);
        }
            break;
        case UIButtonTitleImageType_titleImageVertical: {
        }
            break;
        case UIButtonTitleImageType_imageTitleVertical: {
            //            if (imageSize.width<textSize.width) {
            //                self.imageEdgeInsets = UIEdgeInsetsMake(0, imageSize.width+(textSize.width-imageSize.width)/2, 0, 0);
            //            } else {
            self.titleEdgeInsets = UIEdgeInsetsMake(textSize.height+(imageSize.height-textSize.height)/2, -textSize.width-(imageSize.width-textSize.width)/2, -textSize.height-(imageSize.height-textSize.height)/2, textSize.width+(imageSize.width-textSize.width)/2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, 0, textSize.height, -textSize.width);
            //            }
            
            //            self.contentEdgeInsets = UIEdgeInsetsMake(textSize.height, -MIN(textSize.width, imageSize.width), <#CGFloat bottom#>, <#CGFloat right#>)
            //            self.contentEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, 0, 0);
            //            self.imageEdgeInsets = UIEdgeInsetsMake(-textSize.height, imageSize.width+(textSize.width-imageSize.width)/2, textSize.height, 0);
            //            self.contentEdgeInsets = UIEdgeInsetsMake(imageSize.height, -imageSize.width, 0, 0);
        }
            break;
        default:
            break;
    }
}


@end
