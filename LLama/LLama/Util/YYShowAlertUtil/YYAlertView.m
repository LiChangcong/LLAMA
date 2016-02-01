//
//  YYAlertView.m
//  mocha
//
//  Created by yunyao on 15/7/7.
//  Copyright (c) 2015年 Live. All rights reserved.
//

#import "YYAlertView.h"

@implementation YYAlertView


-(id) initWithTitle:(NSString *)title message:(NSString *)message clickedBlock:(alertButtonClickedBlock)block cancelButtonTitle:(NSString *)cancelButtonTitle{
    
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles: nil];
    if (self){
        self.buttonClickedBlock = block;
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark UIAlertViewDelegate
-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (_buttonClickedBlock){
        _buttonClickedBlock(buttonIndex);
    }
}

@end
