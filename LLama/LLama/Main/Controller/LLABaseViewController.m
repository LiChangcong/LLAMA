//
//  LLABaseViewController.m
//  LLama
//
//  Created by WanDa on 16/1/8.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLABaseViewController.h"

@interface LLABaseViewController ()

@end

@implementation LLABaseViewController

- (void) back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //set back item
    if (self.navigationController.viewControllers.count > 1){
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage llaImageWithName:@"back"] highlightedImage:nil target:self action:@selector(back)];
        //self.navigationItem.hidesBackButton = YES;
        
    }
    
    
    
    [self.navigationItem setHidesBackButton:YES];
//    
//    for (UIView *view in self.navigationController.navigationBar.subviews){
//        NSString *name = [NSString stringWithFormat:@"%@",view.class];
//        if ([name isEqualToString:@"UINavigationItemButtonView"] || [name isEqualToString:@"_UINavigationBarBackIndicatorView"]) {
//            [view setHidden:YES];
//            
//        }
//    }

    
    

    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/***
 subViewContorller override these methods
 when need other orientations
 ***/

- (BOOL) shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

//status bar style

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
