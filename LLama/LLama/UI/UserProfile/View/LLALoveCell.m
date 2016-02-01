//
//  LLALoveCell.m
//  LLama
//
//  Created by tommin on 16/2/1.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLALoveCell.h"

@interface LLALoveCell()

@property (strong, nonatomic) IBOutlet LLAUserHeadView *headView;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@end

@implementation LLALoveCell


// 设置数据
- (void) updateCellWithVideoInfo:(LLAUser *)userInfo tableWidth:(CGFloat)tableWidth {
    

    [self.headView updateHeadViewWithUser:userInfo];
    self.userName.text = userInfo.userName;
}

@end
