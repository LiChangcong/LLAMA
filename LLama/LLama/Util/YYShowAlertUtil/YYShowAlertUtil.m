//
//  YYShowAlertUtil.m
//  mocha
//
//  Created by yunyao on 15/7/7.
//  Copyright (c) 2015年 Live. All rights reserved.
//

#import "YYShowAlertUtil.h"
#import "YYAlertView.h"
#import "YYActionSheetView.h"

@implementation YYShowAlertUtil

+(void) showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle alertType:(YYShowAlertType)alertType destructiveButtonTitle:(NSString *) destructiveButtonTitle inViewController:(UIViewController *)viewController buttonClickedBlock:(alertButtonClickedBlock) block otherButtonTitles:(NSString *)otherButtonTitles,... NS_REQUIRES_NIL_TERMINATION{
    
    if (alertType == YYShowAlertType_ActionSheet){
        if (NSClassFromString(@"UIAlertController")){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
            int i = 0;
            if (destructiveButtonTitle){
                [alertController addAction:[UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    block(i);
                }]];
                i++;
            }
            if (cancelButtonTitle){
                [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    block(i);
                }]];
                i++;
            }
            if (otherButtonTitles){
                [alertController addAction:[UIAlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    block(i);
                }]];
                i++;
                NSString *tempString = nil;
                va_list arpg;
                va_start(arpg, otherButtonTitles);
                
                while ((tempString = va_arg(arpg, NSString *))) {
                    [alertController addAction:[UIAlertAction actionWithTitle:tempString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        block(i);
                    }]];
                    i++;
                }
                
                va_end(arpg);
                
                //-----show alert
                dispatch_async(dispatch_get_main_queue(), ^{
                    [viewController presentViewController:alertController animated:YES completion:^{
                        
                    }];
                });
                
            }
            
            
        }else{
            YYActionSheetView *actionSheet = [[YYActionSheetView alloc] initWithTitle:title buttonClickBlock:block cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
            if (otherButtonTitles){
                [actionSheet addButtonWithTitle:otherButtonTitles];
                NSString *tempString = nil;
                
                va_list arpg;
                va_start(arpg, otherButtonTitles);
                while ((tempString = va_arg(arpg, NSString *))){
                    [actionSheet addButtonWithTitle:tempString];
                }
                va_end(arpg);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [actionSheet showInView:viewController.view];
            });
            
            
        }
        
    }else if (alertType == YYShowAlertType_AlertView){
        
        if (NSClassFromString(@"UIAlertController")){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            int i = 0;
            if (cancelButtonTitle){
                [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    block(i);
                }]];
                i++;
            }
            if (otherButtonTitles){
                
                [alertController addAction:[UIAlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    block(i);
                }]];
                i++;
                NSString *tempString = nil;
                va_list arpg;
                va_start(arpg, otherButtonTitles);
                
                while ((tempString = va_arg(arpg, NSString *))) {
                    [alertController addAction:[UIAlertAction actionWithTitle:tempString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        block(i);
                    }]];
                    i++;
                }
                
                va_end(arpg);
                
                //-----show alert
                dispatch_async(dispatch_get_main_queue(), ^{
                    [viewController presentViewController:alertController animated:YES completion:^{
                        
                    }];
                });
                
                
                
            }
            
            
        }else{
            YYAlertView *alertView = [[YYAlertView alloc] initWithTitle:title message:message clickedBlock:block  cancelButtonTitle:cancelButtonTitle];
            if (otherButtonTitles){
                [alertView addButtonWithTitle:otherButtonTitles];
                NSString *tempString = nil;
                va_list arpg;
                va_start(arpg, otherButtonTitles);
                
                while ((tempString = va_arg(arpg, NSString *))) {
                    [alertView addButtonWithTitle:tempString];
                }
                va_end(arpg);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [alertView show];
            });

        }
        
    }

    
    
    
}

+(void) showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle alertType:(YYShowAlertType)alertType destructiveButtonTitle:(NSString *) destructiveButtonTitle inViewController:(UIViewController *)viewController buttonClickedBlock:(alertButtonClickedBlock) block otherButtonTitleArray:(NSArray *)otherButtonTitleArray orOtherButtonTitles:(NSString *)otherButtonTitles,... NS_REQUIRES_NIL_TERMINATION{
    
    if (alertType == YYShowAlertType_ActionSheet){
        if (NSClassFromString(@"UIAlertController")){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
            int i = 0;
            if (destructiveButtonTitle){
                [alertController addAction:[UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    block(i);
                }]];
                i++;
            }
            if (cancelButtonTitle){
                [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    block(i);
                }]];
                i++;
            }
            if (otherButtonTitleArray) {
                for (NSString *title in otherButtonTitleArray) {
                    [alertController addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        block(i);
                    }]];
                    i++;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [viewController presentViewController:alertController animated:YES completion:^{
                        
                    }];
                });
                
            } else if (otherButtonTitles){
                [alertController addAction:[UIAlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    block(i);
                }]];
                i++;
                NSString *tempString = nil;
                va_list arpg;
                va_start(arpg, otherButtonTitles);
                
                while ((tempString = va_arg(arpg, NSString *))) {
                    [alertController addAction:[UIAlertAction actionWithTitle:tempString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        block(i);
                    }]];
                    i++;
                }
                
                va_end(arpg);
                
                //-----show alert
                dispatch_async(dispatch_get_main_queue(), ^{
                    [viewController presentViewController:alertController animated:YES completion:^{
                        
                    }];
                });
                
            }
            
            
        }else{
            YYActionSheetView *actionSheet = [[YYActionSheetView alloc] initWithTitle:title buttonClickBlock:block cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
            if (otherButtonTitleArray) {
                for (NSString *title in otherButtonTitleArray) {
                    [actionSheet addButtonWithTitle:title];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [actionSheet showInView:viewController.view];
                });
            } else if (otherButtonTitles){
                [actionSheet addButtonWithTitle:otherButtonTitles];
                NSString *tempString = nil;
                
                va_list arpg;
                va_start(arpg, otherButtonTitles);
                while ((tempString = va_arg(arpg, NSString *))){
                    [actionSheet addButtonWithTitle:tempString];
                }
                va_end(arpg);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [actionSheet showInView:viewController.view];
            });
            
            
        }
        
    }else if (alertType == YYShowAlertType_AlertView){
        
        if (NSClassFromString(@"UIAlertController")){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            int i = 0;
            if (cancelButtonTitle){
                [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    block(i);
                }]];
                i++;
            }
            if (otherButtonTitleArray) {
                for (NSString *title in otherButtonTitleArray) {
                    [alertController addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        block(i);
                    }]];
                    i++;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [viewController presentViewController:alertController animated:YES completion:^{
                        
                    }];
                });
                
            } else if (otherButtonTitles){
                
                [alertController addAction:[UIAlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    block(i);
                }]];
                i++;
                NSString *tempString = nil;
                va_list arpg;
                va_start(arpg, otherButtonTitles);
                
                while ((tempString = va_arg(arpg, NSString *))) {
                    [alertController addAction:[UIAlertAction actionWithTitle:tempString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        block(i);
                    }]];
                    i++;
                }
                
                va_end(arpg);
                
                //-----show alert
                dispatch_async(dispatch_get_main_queue(), ^{
                    [viewController presentViewController:alertController animated:YES completion:^{
                        
                    }];
                });
                
                
                
            }
            
            
        }else{
            YYAlertView *alertView = [[YYAlertView alloc] initWithTitle:title message:message clickedBlock:block  cancelButtonTitle:cancelButtonTitle];
            if (otherButtonTitleArray) {
                for (NSString *title in otherButtonTitleArray) {
                    [alertView addButtonWithTitle:title];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [alertView show];
                });
                
            } else if (otherButtonTitles){
                [alertView addButtonWithTitle:otherButtonTitles];
                NSString *tempString = nil;
                va_list arpg;
                va_start(arpg, otherButtonTitles);
                
                while ((tempString = va_arg(arpg, NSString *))) {
                    [alertView addButtonWithTitle:tempString];
                }
                va_end(arpg);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [alertView show];
            });
            
        }
        
    }
    
    
    
    
}

//+(UIViewController *) toppestViewController{
//
//    
//    UINavigationController *selectNavi =(UINavigationController *) appDelegate.tabBarController.selectedViewController;
//    
//    return [selectNavi viewControllers].lastObject;
//}


@end
