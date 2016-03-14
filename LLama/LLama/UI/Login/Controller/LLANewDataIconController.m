//
//  LLANewDataIconController.m
//  LLama
//
//  Created by tommin on 16/3/10.
//  Copyright © 2016年 heihei. All rights reserved.
//

#import "LLANewDataIconController.h"


#import "LLALoadingView.h"
#import "LLAViewUtil.h"
#import "LLAUploadFileUtil.h"
#import "LLAHttpUtil.h"

#import "LLAUser.h"
#import "TMTabBarController.h"

#import "LLAImagePickerViewController.h"
#import "LLAPickImageItemInfo.h"


@interface LLANewDataIconController ()
{
    UIView *headContentView;
    UIImageView *headBackgroundImage;
    UIButton *headImageButton;
    
    UIView *inputView;
    UILabel *nameLabel;
    UITextField *nameTextField;
    UILabel *sexLabel;
    UIView *sexView;
    UIButton *manButton;
    UIButton *womanButton;
    
    UIButton *inHeiHeiButton;
    
    LLALoadingView *HUD;
   
    // 挑选的头像
    UIImage *choosedImage;
}
@end

@implementation LLANewDataIconController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.title = @"填写个人资料";
    
    [self initVariables];
    [self initSubViews];
    [self initSubConstraints];
    
    HUD = [LLAViewUtil addLLALoadingViewToView:self.view];
    [HUD hide:NO];


}

- (void)initVariables
{
    
}

- (void)initSubViews
{
    /*-----------------------------------------------*/
    headContentView = [[UIView alloc] init];
    [self.view addSubview:headContentView];
    
    headBackgroundImage = [[UIImageView alloc] init];
    headBackgroundImage.image = [UIImage imageNamed:@"bg-loginset"];
    [headContentView addSubview:headBackgroundImage];
    
    headImageButton = [[UIButton alloc] init];
    [headImageButton setImage:[UIImage imageNamed:@"setuserhead"] forState:UIControlStateNormal];
    [headImageButton setImage:[UIImage imageNamed:@"setuserheadh"] forState:UIControlStateHighlighted];
    [headImageButton addTarget:self action:@selector(headImageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    headImageButton.layer.cornerRadius = headImageButton.frame.size.height/2;
    headImageButton.layer.borderWidth = 1.0;
    headImageButton.layer.borderColor =[UIColor whiteColor].CGColor;
    headImageButton.clipsToBounds = YES;
    [headContentView addSubview:headImageButton];
    
    
    /*-----------------------------------------------*/
    inputView = [[UIView alloc] init];
    inputView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:inputView];
    
    nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"昵称";
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = [UIColor whiteColor];
    [inputView addSubview:nameLabel];
    
    nameTextField = [[UITextField alloc] init];
    nameTextField.placeholder = @"请输入你的昵称";
    nameTextField.textAlignment = NSTextAlignmentRight;
    nameTextField.textColor = [UIColor whiteColor];
    [nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:nameTextField];
    
    sexView = [[UIView alloc] init];
    [inputView addSubview:sexView];
    
    sexLabel = [[UILabel alloc] init];
    sexLabel.text = @"性别";
    sexLabel.font = [UIFont systemFontOfSize:16];
    sexLabel.textColor = [UIColor whiteColor];
    [sexView addSubview:sexLabel];

    manButton = [[UIButton alloc] init];
    [manButton setTitle:@"男生" forState:UIControlStateNormal];
    [manButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [manButton addTarget:self action:@selector(maleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [manButton setImage:[UIImage imageNamed:@"sexual-greydot"] forState:UIControlStateNormal];
    [manButton setImage:[UIImage imageNamed:@"sexual-reddot"] forState:UIControlStateSelected];
    manButton.selected = YES;
    [sexView addSubview:manButton];
    
    womanButton = [[UIButton alloc] init];
    [womanButton setTitle:@"女生" forState:UIControlStateNormal];
    [womanButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [womanButton addTarget:self action:@selector(femaleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [womanButton setImage:[UIImage imageNamed:@"sexual-greydot"] forState:UIControlStateNormal];
    [womanButton setImage:[UIImage imageNamed:@"sexual-reddot"] forState:UIControlStateSelected];
    [sexView addSubview:womanButton];
    
    /*-----------------------------------------------*/
    inHeiHeiButton = [[UIButton alloc] init];
    inHeiHeiButton.backgroundColor = [UIColor redColor];
    [inHeiHeiButton setTitle:@"进入嘿嘿" forState:UIControlStateNormal];
    [inHeiHeiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [inHeiHeiButton addTarget:self action:@selector(inHeiHeiButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inHeiHeiButton];
    
}
- (void)initSubConstraints
{
    /*-----------------------------------------------*/
    [headContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@150);
    }];
    
    [headBackgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headContentView.mas_top);
        make.left.equalTo(headContentView.mas_left);
        make.right.equalTo(headContentView.mas_right);
        make.bottom.equalTo(headContentView.mas_bottom);
    }];
    
    [headImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headContentView.mas_centerX);
        make.centerY.equalTo(headContentView.mas_centerY);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
    }];
    
    /*-----------------------------------------------*/
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headContentView.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@80);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView.mas_top);
        make.left.equalTo(inputView.mas_left).with.offset(20);
        make.right.equalTo(nameTextField.mas_left).with.offset(-10);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
        
    }];
    
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView.mas_top);
        make.left.equalTo(nameLabel.mas_right).with.offset(10);
        make.right.equalTo(inputView.mas_right).with.offset(-20);
        make.height.equalTo(@40);
    }];
    
    [sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTextField.mas_bottom);
        make.left.equalTo(inputView.mas_left).with.offset(20);
        make.right.equalTo(inputView.mas_right).with.offset(-20);
        make.height.equalTo(@40);
    }];
    
    [sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(nameTextField.mas_bottom);
        make.left.equalTo(inputView.mas_left).with.offset(20);
//        make.right.equalTo(inputView.mas_right).with.offset(-20);
        make.height.equalTo(@40);

    }];
    
    [womanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sexView.mas_top);
        make.bottom.equalTo(sexView.mas_bottom);
        make.right.equalTo(sexView.mas_right).with.offset(-10);
        make.width.equalTo(@80);
    }];
    
    [manButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sexView.mas_top);
        make.bottom.equalTo(sexView.mas_bottom);
        make.right.equalTo(womanButton.mas_left);
        make.width.equalTo(@80);
    }];
    
    /*-----------------------------------------------*/
    [inHeiHeiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView.mas_bottom).with.offset(60);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@40);
    }];
    
}

#pragma mark - ButtonClick

- (void)headImageButtonClick
{
    LLAImagePickerViewController *imagePicker = [[LLAImagePickerViewController alloc] init];
    imagePicker.status = PickerImgOrHeadStatusHead;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    imagePicker.callBack = ^(LLAPickImageItemInfo *itemInfo){
        
        UIImage *headImage = itemInfo.thumbImage;
        choosedImage = headImage;
        [headImageButton setImage:headImage forState:UIControlStateNormal];
        [headImageButton setImage:nil forState:UIControlStateHighlighted];
    };

}

// 性别男的按钮点击
- (IBAction)maleButtonClicked:(id)sender {
    [self.view endEditing:YES];
    
    manButton.selected = YES;
    womanButton.selected = NO;

    
}
// 性别女的按钮点击
- (IBAction)femaleButtonClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    manButton.selected = NO;
    womanButton.selected = YES;

}

// 点击进入嘿嘿
- (void)inHeiHeiButtonClick
{
    // 推出键盘
    [self.view endEditing:YES];
    
    if (nameTextField.text.length < 1) {
        
        [LLAViewUtil showAlter:self.view withText:@"给自己起个名字吧"];
        
        return;
    }
    
    
    if (!choosedImage) {
        
        [LLAViewUtil showAlter:self.view withText:@"给自己找个头像吧"];
        
        return;
    }
    
    if (!manButton.selected && !womanButton.selected) {
        
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
            
            [params setValue:nameTextField.text forKey:@"name"];
            [params setValue:uploadKey forKey:@"imgKey"];
            [params setValue:manButton.selected ? @"男":@"女" forKey:@"gender"];
            
            [LLAHttpUtil httpPostWithUrl:@"/user/updateUserInfo" param:params responseBlock:^(id responseObject) {
                //
                
                [HUD hide:YES];
                
                LLAUser *user = [LLAUser parseJsonWidthDic:responseObject];
                
                [LLAUser updateUserInfo:user];
                //
                TMTabBarController *main = [TMTabBarController new];
                [UIApplication sharedApplication].keyWindow.rootViewController = main;
                
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



#pragma mark - TouchScreen

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - limitNameLength
// 限制昵称长度
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == nameTextField) {
        if (textField.text.length > 14) {
            [LLAViewUtil showAlter:self.view withText:@"昵称需要小于14个字符"];
            textField.text = [textField.text substringToIndex:14];
        }
    }

}

@end
