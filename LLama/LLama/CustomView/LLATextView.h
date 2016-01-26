//
//  LLATextView.h
//  LLama
//
//  Created by Live on 16/1/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLATextView : UITextView

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, weak) UIView *originView;


@end
