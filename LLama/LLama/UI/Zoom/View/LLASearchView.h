//
//  LLASearchView.h
//  LLama
//
//  Created by tommin on 16/3/10.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLASearchView;

@protocol LLASearchViewDelegate <NSObject>

- (void) searchViewDidClickSearchButton:(LLASearchView *)searchView withSearchBar:(UISearchBar *)searchBar;

- (void) searchViewDidClickCancelButton:(LLASearchView *)searchView;

-(void) searchViewDidBeginEditing:(LLASearchView *)searchView;


@end

@interface LLASearchView : UIView

@property (nonatomic, weak) id<LLASearchViewDelegate> delegate;

@property(nonatomic, weak) UISearchBar *topSearchBar;

@end
