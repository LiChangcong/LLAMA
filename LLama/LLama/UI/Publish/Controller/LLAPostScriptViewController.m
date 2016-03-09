//
//  LLAPostScriptViewController.m
//  LLama
//
//  Created by tommin on 16/3/7.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAPostScriptViewController.h"

#import "LLAScriptTopView.h"
#import "LLAInviteView.h"
#import "LLAShareView.h"

#import "LLAInviteToActViewController.h"


#import "LLALoadingView.h"
#import "LLAViewUtil.h"
#import "LLAHttpUtil.h"


#import "LLAUser.h"
#import "LLAILoveWhoInfo.h"


#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "LLASocialContinuousShareManager.h"


#import "LLAShareRequestInfo.h"

#import "TMTabBarController.h"
#import "LLAScriptDetailViewController.h"
#import "LLAUploadFileUtil.h"

#import "LLAImagePickerViewController.h"
#import "LLAPickImageItemInfo.h"


@interface LLAPostScriptViewController () <LLAScriptTopViewDelegate>
{
    UIScrollView *contentScrollView;
    
    LLAScriptTopView *topView;
    
    LLAInviteView *inviteView;
    
    LLAShareView *shareView;
    
    UIView *blankShowView;
    UIImageView *blankShow;
    UILabel *blankDesLabel;

    UIButton *publishButton;
    
    
    UIFont *publishButtonFont;
    UIColor *publishButtonColor;
    
    
//    LLALoadingView *HUD;
//    LLAILoveWhoInfo *mainInfo;
    
    // 产生一个遮盖
    UIButton *shadeButton;



}
@end

@implementation LLAPostScriptViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithHex:0x1f1f1f];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self initNav];
    [self initVariables];
    [self initSubViews];
    [self initSubConstraints];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    


}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //
    
//    CGFloat bottonY =  CGRectGetMaxY(publishButton.frame);
    contentScrollView.contentSize = CGSizeMake(0, 557);

}

#pragma mark - Init

- (void)initNav
{
    self.navigationItem.title = @"剧本";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage llaImageWithName:@"back"] highlightedImage:nil target:self action:@selector(back)];

}

- (void)initVariables
{
    publishButtonFont = [UIFont systemFontOfSize:18];
    publishButtonColor = [UIColor colorWithHex:0xff206f];
    
}

- (void)initSubViews
{
    /*-------------------------------------*/
//    CGRect bounds = [ [ UIScreen mainScreen ] applicationFrame ] ;
    contentScrollView = [ [UIScrollView alloc ] init];
//    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//    contentScrollView.contentSize = CGSizeMake(0, 1000);
    contentScrollView.alwaysBounceHorizontal = NO;
//    contentScrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:contentScrollView];
    
    /*-------------------------------------*/
    if (self.scriptType == LLAPublishScriptTypeNew_Text) {

        topView = [[LLAScriptTopView alloc] initWithType:LLAScriptTopViewType_Text];
        topView.delegate = self;
//        topView.backgroundColor = [UIColor colorWithHex:0x2c2a3a];
        [contentScrollView addSubview:topView];
        
    }else if (self.scriptType == LLAPublishScriptTypeNew_Image){
        
        topView = [[LLAScriptTopView alloc] initWithType:LLAScriptTopViewType_Image];
        topView.delegate = self;
        topView.scriptImageView.image = self.pickImgInfo.thumbImage;
//        topView.backgroundColor = [UIColor colorWithHex:0x2c2a3a];
        [contentScrollView addSubview:topView];
    
    }

    /*-------------------------------------*/
    inviteView = [[LLAInviteView alloc] init];
    inviteView.userInteractionEnabled = YES;
    [contentScrollView addSubview:inviteView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inviteToActTap)];
    [inviteView updateInfoWithInfoArray:[NSArray array]]; // 进入界面的时候邀请列表为空
    [inviteView addGestureRecognizer:tap];
    
    /*-------------------------------------*/

    shareView = [[LLAShareView alloc] init];
    [contentScrollView addSubview:shareView];
    
    /*-------------------------------------*/
    blankShowView = [[UIView alloc] init];
    blankShowView.hidden = YES;
    [contentScrollView addSubview:blankShowView];
    
    blankShow = [[UIImageView alloc] init];
    blankShow.image = [UIImage imageNamed:@"blankShow"];
    [blankShowView addSubview:blankShow];
    
    blankDesLabel = [[UILabel alloc] init];
    blankDesLabel.text = @"视频上传后将设置为私密状态,\n其他人都看不到哦~";
    blankDesLabel.numberOfLines = 0;
    blankDesLabel.font = [UIFont systemFontOfSize:12];
    blankDesLabel.textColor = [UIColor colorWithHex:0x807f87];
    blankDesLabel.textAlignment = NSTextAlignmentCenter;
    [blankShowView addSubview:blankDesLabel];

    /*-------------------------------------*/
    publishButton = [[UIButton alloc] init];
    publishButton.backgroundColor = publishButtonColor;
    [publishButton.titleLabel setFont:publishButtonFont];
    [publishButton setTitle:@"发布" forState:UIControlStateNormal];
    [publishButton addTarget:self action:@selector(publishButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [contentScrollView addSubview:publishButton];

    
    // 使用button生成一个遮盖
    shadeButton = [[UIButton alloc] init];
    shadeButton.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    shadeButton.backgroundColor = [UIColor lightGrayColor];
    shadeButton.alpha = 0.1;
    [shadeButton addTarget:self action:@selector(shadeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    shadeButton.hidden = YES;
    [self.view addSubview:shadeButton];
}

- (void)initSubConstraints
{
    [contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];

    /*-------------------------------------*/
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentScrollView.mas_top);
        make.left.equalTo(contentScrollView);
        make.right.equalTo(contentScrollView);
        make.height.equalTo(@204);
        make.width.equalTo(contentScrollView.mas_width);
    }];

    /*-------------------------------------*/
    [inviteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.height.equalTo(@44);
        make.left.right.equalTo(contentScrollView);
        make.width.equalTo(contentScrollView.mas_width);
    }];

    /*-------------------------------------*/
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inviteView.mas_bottom).with.offset(40);
        make.left.right.equalTo(contentScrollView);
        make.height.equalTo(@132);
        make.width.equalTo(contentScrollView.mas_width);

    }];
    
    
    /*-------------------------------------*/
    [blankShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inviteView.mas_bottom).with.offset(40);
        make.left.right.equalTo(contentScrollView);
        make.height.equalTo(@132);
        make.width.equalTo(contentScrollView.mas_width);

    }];
    
    [blankShow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(blankShowView.mas_top);
//        make.left.equalTo(blankShowView.mas_left);
//        make.right.equalTo(blankShowView.mas_right);
        make.centerX.equalTo(blankShowView.mas_centerX);
        make.width.height.equalTo(@100);
    }];
    
    [blankDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(blankShow.mas_bottom);
//        make.left.equalTo(blankShowView.mas_left);
//        make.right.equalTo(blankShowView.mas_right);
        make.centerX.equalTo(blankShowView.mas_centerX);
//        make.bottom.equalTo(blankShow.mas_bottom);
    }];
    
    /*-------------------------------------*/
    [publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inviteView.mas_bottom).with.offset(220);
//        make.left.equalTo(contentScrollView.mas_left).with.offset(10);
//        make.right.equalTo(contentScrollView.mas_right).with.offset(-10);
//        make.bottom.equalTo(contentScrollView.mas_bottom).with.offset(- 20);
        make.centerX.equalTo(contentScrollView.mas_centerX);
        make.height.equalTo(@45);
        make.width.equalTo(contentScrollView.mas_width).with.multipliedBy(0.9);

    }];

    
}



#pragma mark - nav

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - inviteToActTap

- (void)inviteToActTap
{
    LLAInviteToActViewController *inviteToAct = [[LLAInviteToActViewController alloc] init];
    inviteToAct.callBack = ^(NSArray *info){

        [inviteView updateInfoWithInfoArray:info];
    };
    [self.navigationController pushViewController:inviteToAct animated:YES];
}

#pragma mark - publishButtonClick

- (void)publishButtonClick
{
    
    
    //validate
    if ([topView.moneyTextField.text integerValue] < 1) {
        [LLAViewUtil showAlter:self.view withText:@"片酬太少啦"];
        return;
    }
    
    if ([topView.scriptTextView.text length] < 1) {
        [LLAViewUtil showAlter:self.view withText:@"请输入剧本"];
        return;
    }
    
    if (self.scriptType == LLAPublishScriptTypeNew_Image && !self.pickImgInfo.thumbImage) {
        [LLAViewUtil showAlter:self.view withText:@"请选择剧本图片"];
        return;
    }

    LLALoadingView *HUD = [LLAViewUtil addLLALoadingViewToView:self.view];
    HUD.removeFromSuperViewOnHide = YES;
    
    [HUD show:YES];

    //
    if (self.scriptType == LLAPublishScriptTypeNew_Text) {
        
        NSMutableString *inviteUsersString = [NSMutableString new];
        for (int i = 0 ; i< inviteView.inviteUsersArray.count; i++) {
            
            NSString *str = [NSString new];
            if (!inviteView.inviteUsersArray.lastObject) {
                str = [NSMutableString stringWithFormat:@"%@,",inviteView.inviteUsersArray[i].userIdString];
            }else {
                str = [NSMutableString stringWithFormat:@"%@",inviteView.inviteUsersArray[i].userIdString];

            }
            [inviteUsersString stringByAppendingString:str];
        }
        
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setValue:topView.scriptTextView.text forKey:@"content"];
        [params setValue:@([topView.moneyTextField.text integerValue])forKey:@"fee"];
        [params setValue:@(topView.isSeleced) forKey:@"secret"];
        [params setValue:inviteUsersString forKey:@"invite"];

        
        
        [LLAHttpUtil httpPostWithUrl:@"/play/createPlay" param:params responseBlock:^(id responseObject) {
            
            [HUD hide:YES];
            //
            NSString *playId = [responseObject valueForKey:@"playId"];
            if ([playId isKindOfClass:[NSString class]]) {
                //success
                [self handlePublishSuccessWithPlayId:playId];
            }
            
        } exception:^(NSInteger code, NSString *errorMessage) {
            
            [HUD hide:YES];
            [LLAViewUtil showAlter:self.view withText:errorMessage];
            
        } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
            
            [HUD hide:YES];
            [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
            
            
        }];
        
    }else {
        
        //upload image first
        [LLAUploadFileUtil llaUploadWithFileType:LLAUploadFileType_Image file:self.pickImgInfo.thumbImage tokenBlock:NULL uploadProgress:NULL complete:^(LLAUploadFileResponseCode responseCode, NSString *uploadToken, NSString *uploadKey, NSDictionary *respDic) {
            
            if (responseCode >=0) {
                
                NSMutableString *inviteUsersString = [NSMutableString new];
                for (int i = 0 ; i< inviteView.inviteUsersArray.count; i++) {
                    
                    NSString *str = [NSString new];
                    if (!inviteView.inviteUsersArray.lastObject) {
                        str = [NSMutableString stringWithFormat:@"%@,",inviteView.inviteUsersArray[i].userIdString];
                    }else {
                        str = [NSMutableString stringWithFormat:@"%@",inviteView.inviteUsersArray[i].userIdString];
                        
                    }
                    [inviteUsersString stringByAppendingString:str];
                }

                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                
                [params setValue:topView.scriptTextView.text forKey:@"content"];
                [params setValue:@([topView.moneyTextField.text integerValue])forKey:@"fee"];
                [params setValue:@(topView.isSeleced) forKey:@"secret"];
                [params setValue:inviteUsersString forKey:@"invite"];
                [params setValue:uploadKey forKey:@"image"];
                
                [LLAHttpUtil httpPostWithUrl:@"/play/createPlay" param:params responseBlock:^(id responseObject) {
                    
                    [HUD hide:YES];
                    //
                    NSString *playId = [responseObject valueForKey:@"playId"];
                    if ([playId isKindOfClass:[NSString class]]) {
                        //success
                        [self handlePublishSuccessWithPlayId:playId];
                    }
                    
                } exception:^(NSInteger code, NSString *errorMessage) {
                    
                    [HUD hide:YES];
                    [LLAViewUtil showAlter:self.view withText:errorMessage];
                    
                } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
                    
                    [HUD hide:YES];
                    [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
                    
                    
                }];
                
            }else {
                //
                [HUD hide:YES];
                
                [LLAViewUtil showAlter:self.view withText:[LLAUploadFileUtil llaUploadResponseCodeToDescription:responseCode]];
                
            }
            
        }];
        
    }

}

#pragma mark - Publish Success

- (void) handlePublishSuccessWithPlayId:(NSString *) playId {
    
    //do share
    if (!topView.isSeleced) {
        NSMutableArray *platformsArray = [NSMutableArray arrayWithCapacity:4];
        
        if (shareView.weixinIsSelected) {
            [platformsArray addObject:@(LLASocialSharePlatform_WechatSession)];
        }
        
        if (shareView.weixinFriendCicleIsSelected) {
            [platformsArray addObject:@(LLASocialSharePlatform_WechatTimeLine)];
        }
        
        if (shareView.weiboIsSelected) {
            [platformsArray addObject:@(LLASocialSharePlatform_SinaWeiBo)];
        }
        
        if (shareView.QQIsSelected) {
            [platformsArray addObject:@(LLASocialSharePlatform_QQFriend)];
        }
        
        if (platformsArray.count > 0) {
            
            LLAShareRequestInfo *requestInfo = [LLAShareRequestInfo new];
            requestInfo.urlString = @"/play/getShareInfo";
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:playId forKey:@"playId"];
            requestInfo.paramsDic = params;
            
            __block int totalCount = (int)platformsArray.count;
            __weak typeof(self) weakSelf = self;
            
            [[LLASocialContinuousShareManager shareManager] shareToPlatforms:platformsArray requetInfo:requestInfo stateChangeHandler:^(LLASocialShareResponseState state, NSString *message, NSError *error) {
                
                if (state != LLASocialShareResponseState_Begin) {
                    totalCount--;
                }
                if (totalCount < 1) {
                    
                    [weakSelf dismissWithPlayId:playId];
                    
                }
                
            }];
            
        }else {
            [self dismissWithPlayId:playId];
        }
        
    }else {
        
        //dismiss
        [self dismissWithPlayId:playId];
    }
    
}

- (void) dismissWithPlayId:(NSString *) playId {
    //dismiss,show detail
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        UIViewController *controller = [[UIApplication sharedApplication].delegate window].rootViewController;
        if ([controller isKindOfClass:[TMTabBarController class]]) {
            UINavigationController *navi = ((TMTabBarController *)controller).selectedViewController;
            if ([navi isKindOfClass:[UINavigationController class]]) {
                
                //
                LLAScriptDetailViewController *detail = [[LLAScriptDetailViewController alloc] initWithScriptIdString:playId];
                [navi pushViewController:detail animated:YES];
            }
        }
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark -LLAScriptTopViewDelegate

- (void)scriptTopViewDidTapImageView:(LLAScriptTopView *)scriptTopView
{
    LLAImagePickerViewController *imagepicker = [[LLAImagePickerViewController alloc] init];
    imagepicker.PickerTimesStatus = PickerTimesStatusTwo;
    [self presentViewController:imagepicker animated:YES completion:nil];
    
    imagepicker.callBack = ^(LLAPickImageItemInfo *itemInfo){
        
        self.pickImgInfo.thumbImage = itemInfo.thumbImage;
        
        topView.scriptImageView.image = itemInfo.thumbImage;
    };
    
}

- (void)scriptTopViewDidTapSecretButton:(LLAScriptTopView *)scriptTopView withSecretButton:(UIButton *)button
{
    button.selected = !button.selected;
    
    if (button.selected) {
        
        shareView.hidden = YES;
        
        blankShowView.hidden = NO;
        
    }else {
        
        shareView.hidden = NO;
        
        blankShowView.hidden = YES;
        
    }
}

- (void)shadeButtonClicked
{
    [self.view endEditing:YES];
    shadeButton.hidden = YES;
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    shadeButton.hidden = NO;
}

@end
