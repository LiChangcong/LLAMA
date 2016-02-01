//
//  YYActionSheetView.h
//  mocha
//
//  Created by yunyao on 15/7/7.
//  Copyright (c) 2015年 Live. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYShowAlertUtil.h"

@interface YYActionSheetView : UIActionSheet<UIActionSheetDelegate>

-(id) initWithTitle:(NSString *)title buttonClickBlock:(alertButtonClickedBlock) block cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

@property(nonatomic , copy) alertButtonClickedBlock buttonClickBlock;

@end
