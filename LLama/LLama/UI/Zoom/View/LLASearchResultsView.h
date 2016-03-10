//
//  LLASearchResultsView.h
//  LLama
//
//  Created by tommin on 16/3/10.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLASearchResultsView;

@protocol LLASearchResultsViewDelegate <NSObject>

- (void) searchResultsViewDidClickSearchButton:(LLASearchResultsView *)searchView withSearchBar:(UISearchBar *)searchBar;

- (void) searchResultsViewDidClickCancelButton:(LLASearchResultsView *)searchView;

- (void) searchResultsViewDidBeginEditing:(LLASearchResultsView *)searchView;
@end

@interface LLASearchResultsView : UIView

@property (nonatomic, weak) UISearchBar *searchBar;

@property (nonatomic, weak) id<LLASearchResultsViewDelegate> delegate;


@end
