//
//  TMVersionCell.m
//  LLama
//
//  Created by tommin on 15/12/29.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMVersionCell.h"

@implementation TMVersionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {

        
        self.detailTextLabel.text = @"1.0.1";
        self.textLabel.text = @"版本信息";
        self.detailTextLabel.textColor = TMYellowColor;

    }
    return self;
}

@end
