//
//  LLAChatMessageBaseCell.m
//  LLama
//
//  Created by Live on 16/3/2.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAChatMessageBaseCell.h"

@implementation LLAChatMessageBaseCell

#pragma mark - Init

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self baseCommonInit];
    }
    
    return self;
    
}

- (void) baseCommonInit {
    [self baseSetup];
    [self baseInitVariables];
    [self baseInitSubViews];
}

- (void) baseSetup {
    self.imageView.image = nil;
    self.imageView.hidden = YES;
    self.textLabel.text = nil;
    self.textLabel.hidden = YES;
    self.detailTextLabel.text = nil;
    self.detailTextLabel.hidden = YES;
}


- (void) baseInitVariables {
    
}

- (void) baseInitSubViews {
    
}

@end
