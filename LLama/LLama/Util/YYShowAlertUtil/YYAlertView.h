//
//  YYAlertView.h
//  mocha
//
//  Created by yunyao on 15/7/7.
//  Copyright (c) 2015年 Live. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYShowAlertUtil.h"

@interface YYAlertView : UIAlertView<UIAlertViewDelegate>

-(id) initWithTitle:(NSString *)title message:(NSString *)message clickedBlock:(alertButtonClickedBlock) block   cancelButtonTitle:(NSString *)cancelButtonTitle;

@property(nonatomic , copy) alertButtonClickedBlock buttonClickedBlock;

@end
