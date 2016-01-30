//
//  LLAUserAgreementViewController.m
//  LLama
//
//  Created by tommin on 16/1/30.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUserAgreementViewController.h"
#import "LLALoadingView.h"
#import "LLAViewUtil.h"


@interface LLAUserAgreementViewController ()<UIWebViewDelegate>
{
    LLALoadingView *HUD;

}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LLAUserAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //
    self.navigationItem.title = @"用户协议";
    
    // webView
    NSURL *url = [NSURL URLWithString:@"http://hillama.com/PrivacyPolicy.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.webView.delegate = self;
    [self.webView loadRequest:request];

    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];
    [HUD show:YES];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"加载完成");
    [HUD hide:YES];

}

@end
