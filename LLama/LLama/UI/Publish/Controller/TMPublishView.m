//
//  TMPublishView.m
//  LLama
//
//  Created by tommin on 15/12/15.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMPublishView.h"
#import <POP.h>
#import "TMPostScriptViewController.h"
#import "TMNavigationController.h"
#import "LLABaseNavigationController.h"

#define TMRootView [UIApplication sharedApplication].keyWindow.rootViewController.view

#import "LLAImagePickerViewController.h"

static CGFloat const XMGAnimationDelay = 0.08;
static CGFloat const XMGSpringFactor = 10;
#define XMGScreenW [UIScreen mainScreen].bounds.size.width
#define XMGScreenH [UIScreen mainScreen].bounds.size.height


@implementation TMPublishView

+ (instancetype)publishView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


- (void)awakeFromNib {
    
    // 不能被点击
    TMRootView.userInteractionEnabled = NO;
    self.userInteractionEnabled = NO;
    
    // 数据
    NSArray *images = @[@"writecircle", @"cameracircle"];
    
    // 中间的2个按钮
    int maxCols = 2;
    CGFloat buttonW = 90;
    CGFloat buttonH = buttonW;
    CGFloat buttonStartY = (XMGScreenH - buttonH) * 0.7 ;
    CGFloat buttonStartX = 52;
    CGFloat xMargin = (XMGScreenW - 2 * buttonStartX - maxCols * buttonW) / (maxCols - 1);
    for (int i = 0; i<images.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        // 设置内容
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        
        // 计算X\Y
//        int row = i / maxCols;
        int col = i % maxCols;
        CGFloat buttonX = buttonStartX + col * (xMargin + buttonW);
        CGFloat buttonEndY = buttonStartY;
        CGFloat buttonBeginY = buttonEndY + XMGScreenH;
        
        // 按钮动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonBeginY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY, buttonW, buttonH)];
        anim.springBounciness = XMGSpringFactor;
        anim.springSpeed = XMGSpringFactor;
        anim.beginTime = CACurrentMediaTime() + XMGAnimationDelay * i;
        [button pop_addAnimation:anim forKey:nil];
        
        [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            // 标语动画执行完毕, 恢复点击事件
            self.userInteractionEnabled = YES;
        }];
    }
    


}

- (void)buttonClick:(UIButton *)button
{
    [self cancelWithCompletionBlock:^{
        
        
        if (button.tag == 0) {
            TMPostScriptViewController *postS = [[TMPostScriptViewController alloc] init];

            postS.scriptType = LLAPublishScriptType_Text;
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[LLABaseNavigationController alloc] initWithRootViewController:postS] animated:YES completion:nil];

        } else if (button.tag == 1) {
            
            LLAImagePickerViewController *imagePicker = [[LLAImagePickerViewController alloc] init];
            imagePicker.status = PickerImgOrHeadStatusImg;
            imagePicker.PickerTimesStatus = PickerTimesStatusOne;
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePicker animated:YES completion:nil];
            
//            TMPostScriptViewController *postS = [[TMPostScriptViewController alloc] init];
//
//            postS.scriptType = LLAPublishScriptType_Image;
//            
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[LLABaseNavigationController alloc] initWithRootViewController:postS] animated:YES completion:nil];

        
        }
    }];
}


/**
 * 先执行退出动画, 动画完毕后执行completionBlock
 */
- (void)cancelWithCompletionBlock:(void (^)())completionBlock
{
    // 不能被点击
    TMRootView.userInteractionEnabled = NO;
    self.userInteractionEnabled = NO;
    
    int beginIndex = 0;
    
    for (int i = beginIndex; i<self.subviews.count; i++) {
        UIView *subview = self.subviews[i];
        
        // 基本动画
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat centerY = subview.centerY + XMGScreenH;
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(subview.centerX, centerY)];
        anim.beginTime = CACurrentMediaTime() + (i - beginIndex) * XMGAnimationDelay;
        [subview pop_addAnimation:anim forKey:nil];
        
        // 监听最后一个动画
        if (i == self.subviews.count - 1) {
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                
                TMRootView.userInteractionEnabled = YES;

                // 销毁窗口
                [self removeFromSuperview];
                
                // 执行传进来的completionBlock参数
                !completionBlock ? : completionBlock();
            }];
        }
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self cancelWithCompletionBlock:nil];

}

- (void) show {
    
    self.frame = [UIApplication sharedApplication].keyWindow.frame;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}


@end
