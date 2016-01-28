//
//  LLAAccountSecuritySectionTwoCell.m
//  LLama
//
//  Created by tommin on 16/1/27.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAAccountSecuritySectionTwoCell.h"

@interface LLAAccountSecuritySectionTwoCell()

@end

@implementation LLAAccountSecuritySectionTwoCell

- (void)awakeFromNib {
    // Initialization code
    
//    self.iconView.image = [UIImage imageNamed:@"qq"];
//    [self.swit setOn:NO];
//    self.swit.enabled = NO;
    self.swit.onTintColor = [UIColor colorWithHex:0xffd409];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setSectionTwo:(LLAAccountSecuritySectionTwo *)sectionTwo
//{
//    _sectionTwo = sectionTwo;
////        self.iconView.image = [UIImage imageNamed:@"qq"];
//
////    self.iconView.image = [UIImage imageNamed:sectionTwo.icon];
//    self.swit.on = sectionTwo.on;
//}

//- (void)setSectionTwo:(LLAAccountSecuritySectionTwo *)sectionTwo
//{
//    _sectionTwo = sectionTwo;
//    
//    self.iconView.image = [UIImage imageNamed:sectionTwo.icon];
//    if ([sectionTwo.on isEqualToString:@"YES"]) {
//        [self.swit setOn:YES];
//    }else {
//        [self.swit setOn:NO];
//    }
//}

// 通知代理
- (IBAction)switchButtonClick:(UISwitch *)sender {
    
    if ([self.delegate respondsToSelector:@selector(switchButtonOn:indexPath:)]) {
        [self.delegate switchButtonOn:self indexPath:_indexPath];
    }
}

@end
