//
//  LLAShareView.m
//  LLama
//
//  Created by tommin on 16/3/7.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAShareView.h"
#import "LLAShareButton.h"

@interface LLAShareView()
{
    UILabel *shareLabel;
    
    UIView *contentView;
    
    UIColor *shareLabelColor;
    UIFont *shareLabelFont;
}
@end

@implementation LLAShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithHex:0x1e1d28];
        [self initVariables];
        [self initSubViews];
        [self initSubConstraints];

    }
    
    return self;
}

- (void)initVariables
{
    shareLabelColor = [UIColor colorWithHex:0x807f87];
    shareLabelFont = [UIFont systemFontOfSize:12];
}

- (void)initSubViews
{

    shareLabel = [[UILabel alloc] init];
    shareLabel.text = @"分享到";
    shareLabel.font = shareLabelFont;
    shareLabel.textColor = shareLabelColor;
    [self addSubview:shareLabel];
    
    contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    
    NSArray *names = @[@"微信", @"微信朋友圈", @"新浪微博", @"QQ"];
    NSArray *normalImgae = @[@"publish_wechat", @"publish_friendscircle", @"publish_weibo", @"publish_qq"];
    NSArray *selectedImage = @[@"publish_wechath", @"publish_friendscircleh", @"publish_weiboh", @"publish_qqh"];

    
    
    CGFloat buttonW = [UIScreen mainScreen].bounds.size.width / 2;
    CGFloat buttonH = 44;
    
    NSLog(@"%f",[UIScreen mainScreen].bounds.size.width);
    
    NSUInteger count = 4;
    for (NSUInteger i = 0; i < count; i++) {
        LLAShareButton *button = [LLAShareButton buttonWithType:UIButtonTypeCustom];
        [button sizeToFit];
//        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:names[i] forState:UIControlStateNormal];
        button.tag = i;
        [button setImage:[UIImage imageNamed:normalImgae[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selectedImage[i]] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorWithHex:0x807f87] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(shareButtonClick:withTag:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
        
        CGFloat buttonX = (i % 2) * buttonW;
        CGFloat buttonY = (i / 2) * buttonH;
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        
    }

}

- (void)initSubConstraints
{
    [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.right.equalTo(self);
        make.height.equalTo(@44);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shareLabel.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    
}

- (void)shareButtonClick:(UIButton *)button withTag:(int)tag
{
    button.selected = !button.selected;
    
    if (button.tag == 0 ) {    // 微信
        
        if (button.selected == YES) {
            
            self.weixinIsSelected = YES;
        }else {
            self.weixinIsSelected = NO;

        }
        
    }else if(button.tag == 1 && button.selected == YES){ // 朋友圈
        
        if (button.selected == YES) {
            
            self.weixinFriendCicleIsSelected = YES;
        }else {
            self.weixinFriendCicleIsSelected = NO;
            
        }

    
    }else if(button.tag == 2 && button.selected == YES){ // 微博
        
        if (button.selected == YES) {
            
            self.weiboIsSelected = YES;
        }else {
            self.weiboIsSelected = NO;
            
        }

    
    }else{ // QQ
        
        if (button.selected == YES) {
            
            self.QQIsSelected = YES;
        }else {
            self.QQIsSelected = NO;
            
        }

    
    }

}

@end
