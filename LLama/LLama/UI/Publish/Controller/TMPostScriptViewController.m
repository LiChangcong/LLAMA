//
//  TMPostScriptViewController.m
//  LLama
//
//  Created by tommin on 15/12/15.
//  Copyright © 2015年 heihei. All rights reserved.
//

//controller
#import "TMPostScriptViewController.h"

#import "LLAAlbumPickerViewController.h"
#import "LLABaseNavigationController.h"
#import "LLAScriptDetailViewController.h"
#import "TMTabBarController.h"

//view
#import "LLATextView.h"
#import "LLALoadingView.h"

//model

//util
#import "LLAViewUtil.h"
#import "LLAHttpUtil.h"
#import "LLAUploadFileUtil.h"

//#import "TMAlbumPickerViewController.h"
#import "LLAImagePickerViewController.h"
#import "LLAPickImageItemInfo.h"
#import "ZLPhotoAssets.h"
static const CGFloat textViewToLeftWithoutImage = 20;
static const CGFloat textViewToLeftWithImage = 118;

@interface TMPostScriptViewController ()<LLAAlbumPickerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTrailConstraint;
@property (weak, nonatomic) IBOutlet UITextField *rewardMoneyTextField;
@property (weak, nonatomic) IBOutlet UIImageView *preViewImageView;
@property (weak, nonatomic) IBOutlet LLATextView *scriptContentTextView;
@property (weak, nonatomic) IBOutlet UIButton *isPrivateButton;
@property (weak, nonatomic) IBOutlet UIButton *weChatFriend;
@property (weak, nonatomic) IBOutlet UIButton *weChatTimeLine;
@property (weak, nonatomic) IBOutlet UIButton *sinaWeiBo;
@property (weak, nonatomic) IBOutlet UIButton *qqFriend;


@property (nonatomic , strong) NSArray *assets;
@property (nonatomic , strong) UIImage *icon;

@end

@implementation TMPostScriptViewController

@synthesize scriptType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 设置标题
    self.navigationItem.title = @"剧本";
    
    //back item
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage llaImageWithName:@"back"] highlightedImage:nil target:self action:@selector(back)];
    //
    if (scriptType == LLAPublishScriptType_Text) {
        _textViewTrailConstraint.constant = textViewToLeftWithoutImage;
        _preViewImageView.hidden = YES;
    }else {
        _textViewTrailConstraint.constant = textViewToLeftWithImage;
        _preViewImageView.hidden = NO;
        //show choose image
//        [self chooseImageView:nil];
    }
    
    _preViewImageView.image = self.pickImgInfo.thumbImage;

    
    //
    _rewardMoneyTextField.placeholder = @"点击此处输入金额";
    _rewardMoneyTextField.textAlignment = NSTextAlignmentRight;
    //
    _preViewImageView.contentMode = UIViewContentModeScaleAspectFill;
    _preViewImageView.userInteractionEnabled = YES;
    _preViewImageView.clipsToBounds = YES;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImageView:)];
    [_preViewImageView addGestureRecognizer:tapGes];
    
    //
    _scriptContentTextView.placeholder = @"这里写剧本";
    
    //
    [_isPrivateButton setImage:[UIImage llaImageWithName:@"public"] forState:UIControlStateNormal];
    [_isPrivateButton setImage:[UIImage llaImageWithName:@"privite"] forState:UIControlStateHighlighted];
    [_isPrivateButton setImage:[UIImage llaImageWithName:@"privite"] forState:UIControlStateSelected];
    _isPrivateButton.tintColor = nil;
    
    [_isPrivateButton addTarget:self action:@selector(isPrivateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //
    [_weChatFriend setImage:[UIImage llaImageWithName:@"wechatShare"] forState:UIControlStateNormal];
    [_weChatFriend setImage:[UIImage llaImageWithName:@"wechatShareHighlight"] forState:UIControlStateSelected];
    _weChatFriend.tintColor = nil;
    
    [_weChatFriend addTarget:self action:@selector(weChatFriendClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_weChatTimeLine setImage:[UIImage llaImageWithName:@"wechatcircle"] forState:UIControlStateNormal];
    [_weChatTimeLine setImage:[UIImage llaImageWithName:@"wechatcircleh"] forState:UIControlStateSelected];
    _weChatFriend.tintColor = nil;
    
    [_weChatTimeLine addTarget:self action:@selector(weChatTimeLineClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_sinaWeiBo setImage:[UIImage llaImageWithName:@"weiboShare"] forState:UIControlStateNormal];
    [_sinaWeiBo setImage:[UIImage llaImageWithName:@"weiboShareHighlight"] forState:UIControlStateSelected];
    
    _sinaWeiBo.tintColor = nil;
    [_sinaWeiBo addTarget:self action:@selector(sinaWeiBoClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_qqFriend setImage:[UIImage llaImageWithName:@"qqtiny"] forState:UIControlStateNormal];
    [_qqFriend setImage:[UIImage llaImageWithName:@"qqtinyh"] forState:UIControlStateSelected];
    _qqFriend.tintColor = nil;
    [_qqFriend addTarget:self action:@selector(qqFriendClicked:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Button Touch up Inside

- (void) isPrivateButtonClicked:(UIButton *) sender {
    
    _isPrivateButton.selected = !_isPrivateButton.selected;
}

- (void) weChatFriendClicked:(UIButton *) sender {
    _weChatFriend.selected = !_weChatFriend.selected;
    
    if (_weChatFriend.selected) {
        _weChatFriend.backgroundColor = [UIColor colorWithHex:0x555555];
    }else {
        _weChatFriend.backgroundColor = [UIColor colorWithHex:0xcfcfcf];
    }

}

- (void) weChatTimeLineClicked:(UIButton *) sender {
    _weChatTimeLine.selected = !_weChatTimeLine.selected;
    
    if (_weChatTimeLine.selected) {
        _weChatTimeLine.backgroundColor = [UIColor colorWithHex:0x555555];
    }else {
        _weChatTimeLine.backgroundColor = [UIColor colorWithHex:0xcfcfcf];
    }

}

- (void) sinaWeiBoClicked:(UIButton *) sender {
    _sinaWeiBo.selected = !_sinaWeiBo.selected;
    
    if (_sinaWeiBo.selected) {
        _sinaWeiBo.backgroundColor = [UIColor colorWithHex:0x555555];
    }else {
        _sinaWeiBo.backgroundColor = [UIColor colorWithHex:0xcfcfcf];
    }

}


- (void) qqFriendClicked:(UIButton *) sender {
    _qqFriend.selected = !_qqFriend.selected;
    
    if (_qqFriend.selected) {
        _qqFriend.backgroundColor = [UIColor colorWithHex:0x555555];
    }else {
        _qqFriend.backgroundColor = [UIColor colorWithHex:0xcfcfcf];
    }

}

- (void)back
{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Image Tap

- (void) chooseImageView:(UITapGestureRecognizer *) ges {

 
    LLAImagePickerViewController *imagepicker = [[LLAImagePickerViewController alloc] init];
    imagepicker.PickerTimesStatus = PickerTimesStatusTwo;
    [self presentViewController:imagepicker animated:YES completion:nil];
    
    imagepicker.callBack = ^(LLAPickImageItemInfo *itemInfo){
    
        _preViewImageView.image = itemInfo.thumbImage;
    };
}

#pragma mark - LLAAlbumPickerViewControllerDelegate

- (void) didFinishChooseImage:(UIImage *)image {
    _preViewImageView.image = image;
    if (scriptType == LLAPublishScriptType_Image && !image) {
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark - Publish Script
- (IBAction)publishScript:(id)sender {
    
    [self.view endEditing:YES];
    
    //validate
    if ([_rewardMoneyTextField.text integerValue] < 1) {
        [LLAViewUtil showAlter:self.view withText:@"片酬太少啦"];
        return;
    }
    
    if ([_scriptContentTextView.text length] < 1) {
        [LLAViewUtil showAlter:self.view withText:@"请输入剧本"];
        return;
    }
    
    if (scriptType == LLAPublishScriptType_Image && !_preViewImageView.image) {
        [LLAViewUtil showAlter:self.view withText:@"请选择剧本图片"];
        return;
    }

    
    //
    LLALoadingView *HUD = [LLAViewUtil addLLALoadingViewToView:self.view];
    HUD.removeFromSuperViewOnHide = YES;
    
    [HUD show:YES];
    
    //
    if (scriptType == LLAPublishScriptType_Text) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setValue:@([_rewardMoneyTextField.text integerValue])forKey:@"fee"];
        [params setValue:@(_isPrivateButton.selected) forKey:@"secret"];
        [params setValue:_scriptContentTextView.text forKey:@"content"];
        
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
        [LLAUploadFileUtil llaUploadWithFileType:LLAUploadFileType_Image file:_preViewImageView.image tokenBlock:NULL uploadProgress:NULL complete:^(LLAUploadFileResponseCode responseCode, NSString *uploadToken, NSString *uploadKey, NSDictionary *respDic) {
            
            if (responseCode >=0) {
                
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                
                [params setValue:@([_rewardMoneyTextField.text integerValue])forKey:@"fee"];
                [params setValue:@(_isPrivateButton.selected) forKey:@"secret"];
                [params setValue:_scriptContentTextView.text forKey:@"content"];
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

@end
