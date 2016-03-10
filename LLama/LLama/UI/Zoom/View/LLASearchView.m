//
//  LLASearchView.m
//  LLama
//
//  Created by tommin on 16/3/10.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLASearchView.h"

@interface LLASearchView()<UISearchBarDelegate>
{
    UIView *contentView;
    
    UISearchBar *topSearchBar;
    
    UIButton *cancelButton;
}
@end

@implementation LLASearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        
        [self initVarites];
        [self initSubViews];
        [self initCons];
        
    }
    
    return self;
}

- (void)initVarites
{
    
}

- (void)initSubViews
{
    contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor blackColor];
    [self addSubview:contentView];
    
    cancelButton = [[UIButton alloc] init];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelButton];
    
    topSearchBar = [[UISearchBar alloc] init];
    topSearchBar.placeholder = @"输入搜索关键字";
    topSearchBar.delegate = self;
    topSearchBar.barTintColor = [UIColor colorWithHex:0x1e1d22];
    topSearchBar.backgroundColor = [UIColor colorWithHex:0x1e1d22];
    topSearchBar.tintColor = [UIColor colorWithHex:0xff206f];
    self.topSearchBar = topSearchBar;
    [contentView addSubview:topSearchBar];
    
}

- (void)initCons
{
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    
    
    [topSearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.right.equalTo(contentView.mas_right).with.offset(- 10);
        make.top.equalTo(contentView.mas_top);
        make.bottom.equalTo(contentView.mas_bottom);
    }];
    
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    cancelButton.hidden = NO;
    
    
    topSearchBar.frame = CGRectMake(10, 0, self.frame.size.width-10-60-10 - 10, self.frame.size.height);
    cancelButton.frame = CGRectMake(10+topSearchBar.frame.size.width+10, 0, 60, self.frame.size.height);
    
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    
    if ([self.delegate respondsToSelector:@selector(searchViewDidBeginEditing:)]) {
        [self.delegate searchViewDidBeginEditing:self];
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    
    if ([self.delegate respondsToSelector:@selector(searchViewDidClickSearchButton:withSearchBar:)]) {
        [self.delegate searchViewDidClickSearchButton:self withSearchBar:topSearchBar];
    }
}

- (void)cancelButtonClick
{
    topSearchBar.text = @"";
    [topSearchBar resignFirstResponder];
    
    cancelButton.hidden = YES;
    
    
    
    topSearchBar.frame = CGRectMake(10, 0, self.frame.size.width-10 - 10, self.frame.size.height);
    
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    
    if ([self.delegate respondsToSelector:@selector(searchViewDidClickCancelButton:)]) {
        [self.delegate searchViewDidClickCancelButton:self];
    }

}

@end
