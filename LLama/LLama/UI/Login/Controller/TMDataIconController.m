//
//  TMDataIconController.m
//  LLama
//
//  Created by tommin on 15/12/24.
//  Copyright © 2015年 heihei. All rights reserved.
//

#import "TMDataIconController.h"
#import "TMDataVideoController.h"

#import "LLAViewUtil.h"
#import "LLAUploadFileUtil.h"
#import "LLALoadingView.h"
#import "LLAHttpUtil.h"
#import "LLAUser.h"
#import "LLAAlbumPickerViewController.h"

// temp
#import "TMAlbumPickerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZLPhotoAssets.h"

#import "LLAImagePickerViewController.h"
#import "LLAPickImageItemInfo.h"

@interface TMDataIconController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    UIImage *choosedImage;
    
    LLALoadingView *HUD;
}
@property (weak, nonatomic) IBOutlet UIButton *ChooseHeadImageButton;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;

// temp
@property (nonatomic , strong) NSArray *assets;
@property (nonatomic , strong) UIImage *icon;


@end

@implementation TMDataIconController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"个人资料";
    
    self.ChooseHeadImageButton.clipsToBounds = YES;
    self.ChooseHeadImageButton.layer.cornerRadius = self.ChooseHeadImageButton.frame.size.height/2;
    
    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];
    [HUD hide:NO];
    
    // 设置男女按钮普通个/选中时候的颜色
    // male
    [self.maleButton setBackgroundColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    [self.maleButton setBackgroundColor:[UIColor colorWithHex:0xffd409] forState:UIControlStateSelected];
    [self.maleButton.layer setBorderWidth:1.5f];
    [self.maleButton.layer setBorderColor:[[UIColor colorWithHex:0xb7b7b7] CGColor]];

    // female
    [self.femaleButton setBackgroundColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    [self.femaleButton setBackgroundColor:[UIColor colorWithHex:0xffd409] forState:UIControlStateSelected];
    [self.femaleButton.layer setBorderWidth:1.5f];
    [self.femaleButton.layer setBorderColor:[[UIColor colorWithHex:0xb7b7b7] CGColor]];
/*
    // 监听异步done通知,得知挑选头像操作结束
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(done:) name:@"PICKER_TAKE_DONE" object:nil];
    });
*/    
    // 限制昵称长度
    [self.nickNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextStepButtonClick:(UIButton *)sender {
    
    // 推出键盘
    [self.view endEditing:YES];
    
    if (self.nickNameTextField.text.length < 1) {
    
        [LLAViewUtil showAlter:self.view withText:@"给自己起个名字吧"];
        
        return;
    }
    
//    if (self.nickNameTextField.text.length > 14) {
//        
//        [LLAViewUtil showAlter:self.view withText:@"昵称需要小于14个字符"];
//        
//        return;
//    }
    
    if (!choosedImage) {
        
        [LLAViewUtil showAlter:self.view withText:@"给自己找个头像吧"];
        
        return;
    }
    
    if (!self.femaleButton.selected && !self.maleButton.selected) {
        
        [LLAViewUtil showAlter:self.view withText:@"请选择性别"];
        
        return;
        
    }
    
    //first upload image to Qiniu,then change user's profiles
    
    [HUD show:YES];
    
    __weak typeof(self) blockSelf = self;
    
    [LLAUploadFileUtil llaUploadWithFileType:LLAUploadFileType_Image file:choosedImage tokenBlock:^(NSString *uploadToken, NSString *uploadKey) {
        
    } uploadProgress:^(NSString *uploadKey, float percent) {
        
    } complete:^(LLAUploadFileResponseCode responseCode, NSString *uploadToken, NSString *uploadKey, NSDictionary *respDic) {
        
        if (uploadKey && uploadToken && respDic) {
            //change user's profiles
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            
            [params setValue:blockSelf.nickNameTextField.text forKey:@"name"];
            [params setValue:uploadKey forKey:@"imgKey"];
            [params setValue:blockSelf.maleButton.selected ? @"男":@"女" forKey:@"gender"];
            
            [LLAHttpUtil httpPostWithUrl:@"/user/updateUserInfo" param:params responseBlock:^(id responseObject) {
                //
                
                [HUD hide:YES];
                
                LLAUser *user = [LLAUser parseJsonWidthDic:responseObject];
                
                [LLAUser updateUserInfo:user];
                //
                TMDataVideoController *dataVideo = [[TMDataVideoController alloc] init];
                
                [self.navigationController pushViewController:dataVideo animated:YES];
                
            } exception:^(NSInteger code, NSString *errorMessage) {
                
                [HUD hide:YES];
                [LLAViewUtil showAlter:blockSelf.view withText:errorMessage];
                
            } failed:^(NSURLSessionTask *sessionTask, NSError *error) {
                [HUD hide:YES];
                [LLAViewUtil showAlter:blockSelf.view withText:error.localizedDescription];
            }];
            
            
        }else {
            
            [HUD hide:YES];
            
            [LLAViewUtil showAlter:blockSelf.view withText:[LLAUploadFileUtil llaUploadResponseCodeToDescription:responseCode]];
            
        }
        
    }];
    
    

    
}
- (IBAction)chooseHeadImageButtonClicked:(id)sender {
    
/*
    TMAlbumPickerViewController *album = [[TMAlbumPickerViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:album];
    album.maxCount = 1;
    album.topShowPhotoPicker = YES;
    album.status = PickerViewShowStatusCameraRoll;
    [self presentViewController:nav animated:YES completion:nil];
    
    
    __weak typeof(self) weakSelf = self;
    album.callBack = ^(NSArray *assets){
        weakSelf.assets = assets;
        
        ZLPhotoAssets *asset = self.assets[0];
        choosedImage = asset.aspectRatioImage;
        [self.ChooseHeadImageButton setImage:asset.aspectRatioImage forState:UIControlStateNormal];
        [self.ChooseHeadImageButton setImage:nil forState:UIControlStateHighlighted];
        
    };
    
    album.callBack1 = ^(UIImage *ima){
        
        
        weakSelf.icon = ima;
        ima = [ima imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        choosedImage = ima;
        [self.ChooseHeadImageButton setImage:weakSelf.icon forState:UIControlStateNormal];
        [self.ChooseHeadImageButton setImage:nil forState:UIControlStateHighlighted];
        
    };
*/
    LLAImagePickerViewController *imagePicker = [[LLAImagePickerViewController alloc] init];
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    imagePicker.callBack = ^(LLAPickImageItemInfo *itemInfo){
        
        UIImage *headImage = itemInfo.thumbImage;
        
        [self.ChooseHeadImageButton setImage:headImage forState:UIControlStateNormal];
        [self.ChooseHeadImageButton setImage:nil forState:UIControlStateHighlighted];
    };

    
}

- (IBAction)backBtnClick:(UIButton *)sender {
    
    // 推出键盘
    [self.view endEditing:YES];

}

- (IBAction)maleButtonClicked:(id)sender {
    [self.view endEditing:YES];
    
    self.maleButton.selected = YES;
    self.femaleButton.selected = NO;
    // 设置不同状态不同的描边色
    if (self.femaleButton.state == UIControlStateNormal) {
        [self.femaleButton.layer setBorderColor:[[UIColor colorWithHex:0xb7b7b7] CGColor]];
        [self.maleButton.layer setBorderColor:[[UIColor colorWithHex:0x11111e] CGColor]];
    }else{
        [self.femaleButton.layer setBorderColor:[[UIColor colorWithHex:0x11111e] CGColor]];
        [self.maleButton.layer setBorderColor:[[UIColor colorWithHex:0xb7b7b7] CGColor]];
    }

}
- (IBAction)femaleButtonClicked:(id)sender {
    
    [self.view endEditing:YES];
    self.femaleButton.selected = YES;
    self.maleButton.selected = NO;
    // 设置不同状态不同的描边色
    if (self.femaleButton.state == UIControlStateNormal) {
        [self.femaleButton.layer setBorderColor:[[UIColor colorWithHex:0xb7b7b7] CGColor]];
        [self.maleButton.layer setBorderColor:[[UIColor colorWithHex:0x11111e] CGColor]];
    }else{
        [self.femaleButton.layer setBorderColor:[[UIColor colorWithHex:0x11111e] CGColor]];
        [self.maleButton.layer setBorderColor:[[UIColor colorWithHex:0xb7b7b7] CGColor]];
    }
}

// 点击屏幕时也推出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - UIImagePickerViewController
/*
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = nil;
    
    if (picker.allowsEditing){
        image = [info valueForKey:UIImagePickerControllerEditedImage];
    }else{
        image = [info valueForKey:UIImagePickerControllerOriginalImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        choosedImage = image;
        
        [self.ChooseHeadImageButton setImage:choosedImage forState:UIControlStateNormal];
        
    }];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
*/

/*
// 设置头像
- (void)done:(NSNotification *)note{
    UIImage *image =  note.userInfo[@"selectAssets"];
    dispatch_async(dispatch_get_main_queue(), ^{
        choosedImage = image;
        // 设置头像为相册挑选的头像
        [self.ChooseHeadImageButton setImage:image forState:UIControlStateNormal];
        [self.ChooseHeadImageButton setImage:nil forState:UIControlStateHighlighted];
        
    });
}

// 移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PICKER_TAKE_DONE" object:nil];
}
*/

// 限制昵称长度
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.nickNameTextField) {
        if (textField.text.length > 14) {
            [LLAViewUtil showAlter:self.view withText:@"昵称需要小于14个字符"];
            textField.text = [textField.text substringToIndex:14];
        }
    }
}


@end
