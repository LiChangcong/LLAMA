//
//  LLAChatMessageViewController.m
//  LLama
//
//  Created by Live on 16/3/1.
//  Copyright © 2016年 heihei. All rights reserved.
//

//controller
#import "LLAChatMessageViewController.h"
#import "LLAChatInputViewController.h"


//view
#import "LLATableView.h"
#import "LLALoadingView.h"

//model

@interface LLAChatMessageViewController()<UITableViewDataSource,UITableViewDelegate,LLAChatInputViewControllerDelegate>
{
    LLATableView *dataTableView;
    
    LLAChatInputViewController *inputController;
    
    NSMutableArray *messageArray;
    
    NSLayoutConstraint *inputViewHeightConstraints;
}

@end

@implementation LLAChatMessageViewController

#pragma mark - Life Cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    //
    [self initVariables];
    [self updateNavigationItems];
    [self initSubViews];
    
}

#pragma mark - Init

- (void) initVariables {
    
}

- (void) updateNavigationItems {
    
}

- (void) initSubViews {
    
    dataTableView = [[LLATableView alloc] init];
    dataTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    dataTableView.dataSource = self;
    dataTableView.delegate = self;
    dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    dataTableView.backgroundColor = [UIColor colorWithHex:0x211f2c];
    [self.view addSubview:dataTableView];
    
    inputController = [[LLAChatInputViewController alloc] init];
    inputController.delegate = self;
    
    [self addChildViewController:inputController];
    [inputController didMoveToParentViewController:self];
    
    //
    UIView *inputView = inputController.view;
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:inputView];
    
    //constraints
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[dataTableView]-(0)-[inputView(height)]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:@{@"height":@([LLAChatInputViewController normalHeight])}
      views:NSDictionaryOfVariableBindings(dataTableView,inputView)]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[dataTableView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(dataTableView)]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[inputView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(inputView)]];
    
    //
    for (NSLayoutConstraint *constr in self.view.constraints) {
        if (constr.firstItem == inputView && constr.firstAttribute == NSLayoutAttributeHeight) {
            
            inputViewHeightConstraints = constr;
            break;
        }
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return messageArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

#pragma mark - LLAChatInputViewControllerDelegate

- (void) sendMessageWithContent:(NSString *) textContent {

}

- (void) sendMessageWithImage:(UIImage *) image {
    
}

- (void) sendMessageWithVoiceURL:(NSURL *) voiceURL {
    
}


- (void) inputViewController:(LLAChatInputViewController *) inputController
                   newHeight:(CGFloat) newHeight
                    duration:(NSTimeInterval) duration
              animationCurve:(UIViewAnimationCurve) animationCurve {
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        inputViewHeightConstraints.constant = newHeight;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
    
}

@end
