//
//  TMPurseHeadCell.m
//  LLama
//
//  Created by tommin on 15/12/21.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMPurseHeadCell.h"

@implementation TMPurseHeadCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)purseButtonClick:(UIButton *)sender {
    
    
    TMLog(@"点击了提现按钮");

    
    if ([self.delegate respondsToSelector:@selector(purseHeadCellDidClickPurseButton:)]) {
        
        [self.delegate purseHeadCellDidClickPurseButton:self];
    }

}


@end
