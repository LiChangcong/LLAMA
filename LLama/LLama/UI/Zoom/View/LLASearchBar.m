//
//  LLASearchBar.m
//  LLama
//
//  Created by tommin on 16/2/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLASearchBar.h"

@interface LLASearchBar()

@end

@implementation LLASearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    NSLog(@"设置searchBar");
}

@end
