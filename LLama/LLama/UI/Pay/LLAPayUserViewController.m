//
//  LLAPayUserViewController.m
//  LLama
//
//  Created by Live on 16/1/29.
//  Copyright © 2016年 heihei. All rights reserved.
//

//constroller
#import "LLAPayUserViewController.h"

//view
#import "LLACollectionView.h"
#import "LLALoadingView.h"

//model
#import "LLAUser.h"

//util
#import "LLAViewUtil.h"

@interface LLAPayUserViewController()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    LLACollectionView *dataCollectionView;
}

@end

@implementation LLAPayUserViewController

#pragma mark - Life Cycle

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    [self initVariables];
    [self initNavigationItems];
    [self initSubViews];
    [self initSubConstraints];
    
}

#pragma mark - Init

- (void) initVariables {
    
}

- (void) initNavigationItems {
    self.title = @"支付";
}

- (void) initSubViews {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // collectionView
    dataCollectionView = [[LLACollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    dataCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    dataCollectionView.delegate = self;
    dataCollectionView.dataSource = self;
    dataCollectionView.bounces = YES;
    dataCollectionView.alwaysBounceVertical = YES;
    dataCollectionView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:dataCollectionView];

    
}

- (void) initSubConstraints {
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[dataCollectionView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataCollectionView)]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[dataCollectionView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataCollectionView)]];
}

@end
