//
//  TMTopicCell.m
//  LLama
//
//  Created by tommin on 15/12/8.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMTopicCell.h"
#import "TMLikeTableViewController.h"

@implementation TMTopicCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeButtonClick:(UIButton *)sender {
    
#warning 记住这个坑：自定义view中的按钮点击后会出现做出相应反应，解决方法，代理传到控制器，控制器执行相应反应
//    TMLikeTableViewController *like = [[TMLikeTableViewController alloc] init];
//    [self.window.rootViewController.navigationController pushViewController:like animated:NO];
//    [[UIApplication sharedApplication].keyWindow.rootViewController.navigationController pushViewController:like animated:YES];
//    TMLogFuc;
    

    if ([self.delegate respondsToSelector:@selector(topicCellDidClickLikeButton:)]) {
        
        [self.delegate topicCellDidClickLikeButton:self];
    }

}
- (IBAction)morebButtonClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(topicCellDidClickMoreButton:)]) {
        
        [self.delegate topicCellDidClickMoreButton:self];
    }

}

@end
