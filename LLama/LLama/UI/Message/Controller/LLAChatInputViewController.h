//
//  LLAChatInputViewController.h
//  LLama
//
//  Created by Live on 16/2/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLAChatInputViewControllerDelegate <NSObject>


@end

@interface LLAChatInputViewController : UIViewController

@property(nonatomic , weak) id<LLAChatInputViewControllerDelegate> delegate;

@end
