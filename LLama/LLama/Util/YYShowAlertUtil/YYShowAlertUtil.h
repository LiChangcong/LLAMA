//
//  YYShowAlertUtil.h
//  mocha
//
//  Created by yunyao on 15/7/7.
//  Copyright (c) 2015年 Live. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^alertButtonClickedBlock)(NSInteger buttonIndex);

typedef enum:NSInteger{
    YYShowAlertType_AlertView = 1,
    YYShowAlertType_ActionSheet = 2,
} YYShowAlertType;

@interface YYShowAlertUtil : NSObject

/***************
 显示alertView和actionSheet
 根据alertType来区分，传错了什么都不做，
 只有显示actionSheet时传入destructiveButtonTitle，alertView没用
 因为UIAlertView和UIActionSheet IOS8已废弃，所以方法内会自动选择用什么方法,
 需要传入在哪个UIViewController显示
 ***************/

+(void) showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle alertType:(YYShowAlertType)alertType destructiveButtonTitle:(NSString *) destructiveButtonTitle inViewController:(UIViewController *)viewController buttonClickedBlock:(alertButtonClickedBlock) block otherButtonTitles:(NSString *)otherButtonTitles,... NS_REQUIRES_NIL_TERMINATION;

+(void) showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle alertType:(YYShowAlertType)alertType destructiveButtonTitle:(NSString *) destructiveButtonTitle inViewController:(UIViewController *)viewController buttonClickedBlock:(alertButtonClickedBlock) block otherButtonTitleArray:(NSArray *)otherButtonTitleArray orOtherButtonTitles:(NSString *)otherButtonTitles,... NS_REQUIRES_NIL_TERMINATION;

@end
