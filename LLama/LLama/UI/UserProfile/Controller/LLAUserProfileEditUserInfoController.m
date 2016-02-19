//
//  LLAUserProfileEditUserInfoController.m
//  LLama
//
//  Created by Live on 16/1/23.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLAUserProfileEditUserInfoController.h"
#import "TMAlbumPickerViewController.h"
#import "LLABaseNavigationController.h"

//view
#import "LLAUserHeadView.h"
#import "LLATextView.h"
#import "LLALoadingView.h"

//model
#import "LLAUser.h"

#import "ZLPhotoAssets.h"


//util
#import "LLAHttpUtil.h"
#import "LLAViewUtil.h"
#import "LLAUploadFileUtil.h"

#import "LLAImagePickerViewController.h"
#import "LLAPickImageItemInfo.h"

static const CGFloat topBackViewHeight = 150;

static const CGFloat headViewHeightWidth = 90;

static const CGFloat topBackViewToNameField = 11;
static const CGFloat userNameTextFieldHeight = 42;
static const CGFloat userNameFieldToUserDescVerSpace =14;
static const CGFloat userDescTextViewHeight = 127;

@interface LLAUserProfileEditUserInfoController()<LLAUserHeadViewDelegate>
{
    UIScrollView *backScrollView;
    
    UIView *topBackView;
    LLAUserHeadView *headView;
    
    UITextField *userNameTextField;
    LLATextView *userDescTextView;
    
    LLALoadingView *HUD;
    
    //
    UIFont *userNameTextFont;
    UIColor *userNameTextColor;
    
    UIFont *userDescTextFont;
    UIColor *userDescTextColor;
    
    UIFont *userDescPlaceHolderTextFont;
    UIColor *userDescPlaceHolderTextColor;
    
    //
    UIImage *tempImage;
}

@end

@implementation LLAUserProfileEditUserInfoController

#pragma mark - Life Cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationItems];
    [self initVariables];
    [self initSubViews];
}

#pragma mark - Init

- (void) initNavigationItems {
    self.navigationItem.title = @"修改个人信息";
    
    //
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishEditUserInfo)];
    
    self.navigationItem.rightBarButtonItem = doneItem;
}

- (void) initVariables {
    
    userNameTextFont = [UIFont boldLLAFontOfSize:16];
    userNameTextColor = [UIColor colorWithHex:0x11111e];
    
    userDescTextFont = [UIFont llaFontOfSize:14];
    userDescTextColor = [UIColor colorWithHex:0x11111e];
    
    userDescPlaceHolderTextFont = [UIFont llaFontOfSize:14];
    userDescPlaceHolderTextColor = [UIColor colorWithHex:0xc6c6c6];
}

- (void) initSubViews {
    
    backScrollView = [[UIScrollView alloc] init];
    backScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    backScrollView.backgroundColor = [UIColor colorWithHex:0xebebeb];
    
    [self.view addSubview:backScrollView];
    
    //
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[backScrollView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(backScrollView)]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[backScrollView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(backScrollView)]];
    
    //
    [self initTopView];
    [self initInputInfoView];
    
    //
    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];
    
}

- (void) initTopView {
    //
    topBackView = [[UIView alloc] init];
    topBackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    topBackView.backgroundColor = [UIColor colorWithHex:0x11111e];
    
    [backScrollView addSubview:topBackView];
    
    headView = [[LLAUserHeadView alloc] init];
    headView.translatesAutoresizingMaskIntoConstraints = NO;
    headView.delegate = self;
    
    [headView updateHeadViewWithUser:[LLAUser me]];
    
    [topBackView addSubview:headView];
    
    //
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:headView
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:topBackView
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0
      constant:0]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:headView
      attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationEqual
      toItem:nil
      attribute:NSLayoutAttributeNotAnAttribute
      multiplier:0
      constant:headViewHeightWidth]];
    
    //horizonal
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:headView
      attribute:NSLayoutAttributeCenterX
      relatedBy:NSLayoutRelationEqual
      toItem:topBackView
      attribute:NSLayoutAttributeCenterX
      multiplier:1.0
      constant:0]];
    
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:headView
      attribute:NSLayoutAttributeWidth
      relatedBy:NSLayoutRelationEqual
      toItem:nil
      attribute:NSLayoutAttributeNotAnAttribute
      multiplier:0
      constant:headViewHeightWidth]];
    
    [topBackView addConstraints:constrArray];
}


- (void) initInputInfoView {
    
    userNameTextField = [[UITextField alloc] init];
    userNameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    userNameTextField.font = userNameTextFont;
    userNameTextField.textAlignment = NSTextAlignmentCenter;
    userNameTextField.textColor = userNameTextColor;
    userNameTextField.backgroundColor = [UIColor whiteColor];
    userNameTextField.text = [LLAUser me].userName;
    
    userNameTextField.layer.borderWidth = 0.5;
    userNameTextField.layer.borderColor = [UIColor colorWithHex:0x11111e].CGColor;
    
    [backScrollView addSubview:userNameTextField];
    
    //
    userDescTextView = [[LLATextView alloc] init];
    userDescTextView.translatesAutoresizingMaskIntoConstraints = NO;
    userDescTextView.font = userDescTextFont;
    userDescTextView.textColor  = userDescTextColor;
    userDescTextView.placeholder = @"写一段关于你的个人简介";
    userDescTextView.originView = self.view;
    userDescTextView.text = [LLAUser me].userDescription;
    
    userDescTextView.layer.borderWidth = 0.5;
    userDescTextView.layer.borderColor = [UIColor colorWithHex:0x11111e].CGColor;
    
    [backScrollView addSubview:userDescTextView];
    
    //constraints
    
    NSMutableArray *constrArray = [NSMutableArray array];
    
    //vertical
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[topBackView(toBackHeight)]-(topBackToName)-[userNameTextField(nameHeight)]-(userNameToUserDesc)-[userDescTextView(userDescHeight)]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:[NSDictionary dictionaryWithObjectsAndKeys:
               @(topBackViewHeight),@"toBackHeight",
               @(topBackViewToNameField),@"topBackToName",
               @(userNameTextFieldHeight),@"nameHeight",
               @(userNameFieldToUserDescVerSpace),@"userNameToUserDesc",
               @(userDescTextViewHeight),@"userDescHeight", nil]
      views:NSDictionaryOfVariableBindings(topBackView,userNameTextField,userDescTextView)]];
    
    //horizonal
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[topBackView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(topBackView)]];
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:topBackView
      attribute:NSLayoutAttributeWidth
      relatedBy:NSLayoutRelationEqual
      toItem:backScrollView
      attribute:NSLayoutAttributeWidth
      multiplier:1.0
      constant:0]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[userNameTextField]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(userNameTextField)]];
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:userNameTextField
      attribute:NSLayoutAttributeWidth
      relatedBy:NSLayoutRelationEqual
      toItem:backScrollView
      attribute:NSLayoutAttributeWidth
      multiplier:1.0
      constant:0]];
    
    [constrArray addObjectsFromArray:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(0)-[userDescTextView]-(0)-|"
      options:NSLayoutFormatDirectionLeadingToTrailing
      metrics:nil
      views:NSDictionaryOfVariableBindings(userDescTextView)]];
    [constrArray addObject:
     [NSLayoutConstraint
      constraintWithItem:userDescTextView
      attribute:NSLayoutAttributeWidth
      relatedBy:NSLayoutRelationEqual
      toItem:backScrollView
      attribute:NSLayoutAttributeWidth
      multiplier:1.0
      constant:0]];

    [backScrollView addConstraints:constrArray];
}

#pragma mark - LLAUserHeadViewDelegate

- (void) headView:(LLAUserHeadView *)userheadView clickedWithUserInfo:(LLAUser *)user {
    
    //show choose imageViewController
//    NSLog(@"show selected view controller");
//    
//    TMAlbumPickerViewController *imagePicker = [[TMAlbumPickerViewController alloc] init];
//    LLABaseNavigationController *baseNavi = [[LLABaseNavigationController alloc] initWithRootViewController:imagePicker];
//    imagePicker.maxCount = 1;
//    imagePicker.topShowPhotoPicker = YES;
//    imagePicker.status = PickerViewShowStatusCameraRoll;
//    [self.navigationController presentViewController:baseNavi animated:YES completion:NULL];
//
//    imagePicker.callBack = ^(NSArray *assets){
//        
//        ZLPhotoAssets *asset = assets[0];
//        //        [self.head setBackgroundImage:[asset.aspectRatioImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//        headView.userHeadImageView.image = asset.aspectRatioImage;
//        tempImage = asset.aspectRatioImage;
//        
//    };
//    
//    imagePicker.callBack1 = ^(UIImage *ima){
//        
//        
//        headView.userHeadImageView.image = ima;
//        
//        tempImage = ima;
//        
//    };

    LLAImagePickerViewController *imagePicker = [[LLAImagePickerViewController alloc] init];
    imagePicker.status = PickerImgOrHeadStatusHead;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    imagePicker.callBack = ^(LLAPickImageItemInfo *itemInfo){
        
        UIImage *headImage = itemInfo.thumbImage;
        headView.userHeadImageView.image = headImage;
        tempImage = headImage;
    };

    
}

#pragma mark - edit finish

- (void) finishEditUserInfo {
    
    if ([self hasChangedInfo]) {
        //
        if ([self validateInputInfo]) {
            
            
            __weak typeof(self) blockSelf = self;
            
            [HUD show:YES];
            
            if (tempImage) {
                
                [LLAUploadFileUtil llaUploadWithFileType:LLAUploadFileType_Image file:tempImage tokenBlock:^(NSString *uploadToken, NSString *uploadKey) {
                    
                } uploadProgress:^(NSString *uploadKey, float percent) {
                    
                } complete:^(LLAUploadFileResponseCode responseCode, NSString *uploadToken, NSString *uploadKey, NSDictionary *respDic) {
                    
                    if (uploadKey && uploadToken && respDic) {
                        //change user's profiles
                        
                        NSMutableDictionary *params = [NSMutableDictionary dictionary];
                        
                        [params setValue:userNameTextField.text forKey:@"name"];
                        [params setValue:uploadKey forKey:@"imgKey"];
                        [params setValue:userDescTextView.text forKey:@"gxqm"];
            
                        [blockSelf changeUserInfoWithParams:params];
                        
                        
                    }else {
                        
                        [HUD hide:YES];
                        
                        [LLAViewUtil showAlter:blockSelf.view withText:[LLAUploadFileUtil llaUploadResponseCodeToDescription:responseCode]];
                        
                    }
                    
                }];
                
            }else {
                
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                
                [params setValue:userNameTextField.text forKey:@"name"];
                [params setValue:userDescTextView.text forKey:@"gxqm"];
                
                [blockSelf changeUserInfoWithParams:params];
            }
            
        }
        
    }else {
        //
        
    }
    
}

- (void) changeUserInfoWithParams:(NSDictionary *) params {
    [LLAHttpUtil httpPostWithUrl:@"/user/updateUserInfo" param:params responseBlock:^(id responseObject) {
        //
        
        [HUD hide:YES];
        
        LLAUser *user = [LLAUser parseJsonWidthDic:[responseObject valueForKey:@"user"]];
        user.isLogin = YES;
        
        [LLAUser updateUserInfo:user];
        
        //go back
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } exception:^(NSInteger code, NSString *errorMessage) {
        
        [HUD hide:YES];
        [LLAViewUtil showAlter:self.view withText:errorMessage];
        
    } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
        [HUD hide:YES];
        [LLAViewUtil showAlter:self.view withText:error.localizedDescription];
    }];
    

}

#pragma mark - Check

- (BOOL) hasChangedInfo {
    
    if (tempImage) {
        return YES;
    }
    
    if (![userNameTextField.text isEqualToString:[LLAUser me].userName]) {
        return YES;
    }
    
    if (![userDescTextView.text isEqualToString:[LLAUser me].userDescription]) {
        return YES;
    }
    
    return NO;
}

- (BOOL) validateInputInfo {
    
    if (!tempImage && ![LLAUser me].headImageURL) {
        [LLAViewUtil showAlter:self.view withText:@"给自己找个头像吧"];
        return NO;
    }
    
    if (userNameTextField.text.length <1) {
        
        [LLAViewUtil showAlter:self.view withText:@"给自己起个名字吧"];
        return NO;
    }
    
    if (userNameTextField.text.length > 14) {
        [LLAViewUtil showAlter:self.view withText:@"昵称需要小于14个字符"];
        return NO;
    }
    
    return YES;
    
}

#pragma mark - 

@end
