//
//  SCNickNameController.m
//  AppNews
//
//  Created by SanChain on 15/7/6.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCNickNameController.h"
#import "SCTextView.h"
#import "Masonry.h"
#import "Colours.h"
#import "SCConst.h"


@interface SCNickNameController ()
@property (nonatomic, weak) UITextView *textView;
@end

@implementation SCNickNameController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor beigeColor];
    [self.navigationController.navigationItem.backBarButtonItem setTitle:@"空"];
    self.title = @"姓名";
    
    [self setupSubviews];
}

#pragma mark 设置子控件（masonry的使用）
- (void)setupSubviews
{
    // textView
    SCTextView *textView = [[SCTextView alloc] init];
    textView.placeholder = @"请输入姓名";
    [textView drawRect:self.view.bounds];
    [textView becomeFirstResponder];
    textView.alwaysBounceVertical = NO;
    textView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    [self.view addSubview:textView];
    self.textView = textView;
    
    UIEdgeInsets padding = UIEdgeInsetsMake(70, 0, 0, 0);
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(padding.top);
        make.left.equalTo(self.view.mas_left).with.offset(padding.left);
        make.right.equalTo(self.view.mas_right).with.offset(padding.right);
        make.height.equalTo(@80);
    }];
    
    // 按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor orangeColor];
    btn.tintColor = [UIColor whiteColor];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickEnterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.equalTo(@40);
    }];
}

- (void)clickEnterBtn:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SCNickMessage object:nil userInfo:@{SCNickNameMassage : self.textView.text}];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view.superview endEditing:YES];
}

@end
