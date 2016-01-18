//
//  LLAVideoDetailViewController.m
//  LLama
//
//  Created by Live on 16/1/17.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAVideoDetailViewController.h"

//view
#import "LLATableView.h"

@interface LLAVideoDetailViewController()<UITableViewDataSource,UITableViewDelegate>
{
    LLATableView *dataTableView;
}

@end

@implementation LLAVideoDetailViewController

#pragma mark - Life Cycle

- (void) viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Init

- (void) initNavigationItems {
    
}

- (void) initSubViews {
    
}

#pragma mark - LoadData

- (void) loadData {
    
}

- (void) loadMoreData {
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
