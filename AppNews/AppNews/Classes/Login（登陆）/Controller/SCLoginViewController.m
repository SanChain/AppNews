//
//  SCLoginViewController.m
//  AppNews
//
//  Created by SanChain on 15/6/16.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCLoginViewController.h"
#import "SCTabBarController.h"
#import "MBProgressHUD+MJ.h"
#import "NSString+Extension.h"
#import "SCAccount.h"
#import "SCAccountTool.h"
#import "Colours.h"

@interface SCLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *logo;
/** 登陆账号 */
@property (weak, nonatomic) IBOutlet UITextField *loginAccount;
/** 登陆密码 */
@property (weak, nonatomic) IBOutlet UITextField *loginPassword;
- (IBAction)login:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation SCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor beigeColor];
    
    // logo圆角
    self.logo.layer.cornerRadius = 20;
    self.logo.clipsToBounds = YES;
    
    // 输入密码时不显示
    [self.loginPassword setSecureTextEntry:YES];
    
    // 登陆button圆角
    self.loginButton.layer.cornerRadius = 4;
    self.loginButton.clipsToBounds = YES;
    
}

#pragma mark - 登陆主界面
- (IBAction)login:(UIButton *)sender {
    self.loginButton.selected = !self.loginButton.selected; // 状态取反
    
    if (self.loginAccount.text.length == 0 && self.loginPassword.text.length == 0) {
        [MBProgressHUD showError:@"请输入账号和密码"];
        
    } else if (self.loginAccount.text.length == 0) {
        [MBProgressHUD showError:@"请输入账号"];
        
    } else if (self.loginPassword.text.length == 0) {
        [MBProgressHUD showError:@"请输入密码"];
        
    } else if ([self.loginAccount.text isPhoneNumber]) { // 正则：判断是否为手机号
        // 把账号写入沙盒
        SCAccount *account = [[SCAccount alloc] init];
        account.loginAccount = self.loginAccount.text;
        account.loginPassword = self.loginPassword.text;
        [SCAccountTool saveAccountWith:account];
        
        // 真正进入AppNews界面
        [MBProgressHUD showMessage:@"拼命登陆中..."];
        SCTabBarController *tabC = [[SCTabBarController alloc] init];
        [self presentViewController:tabC animated:YES completion:^{
            [MBProgressHUD hideHUD];
        }];
    } else {
        [MBProgressHUD showError:@"请正确输入手机号"];
    }
    
    
    
    
}

#pragma mark - 点击屏幕收起键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
