//
//  SCDetailViewController.m
//  AppNews
//
//  Created by SanChain on 15/6/22.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCDetailViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "SCConst.h"
#import "Colours.h"

@interface SCDetailViewController ()

@end

@implementation SCDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    // 导航条设置
    [self setupNavigationBarAttribute];

    // 设置titleView
    [self setupTitleView];
    
    
}

#pragma mark 导航条属性设置
- (void)setupNavigationBarAttribute
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor: [UIColor emeraldColor]];
}

#pragma mark 添加navigationBar的titleView
- (void)setupTitleView
{
    NSArray *array = [[NSArray alloc] initWithObjects:@"详情", @"网站", nil];
    UISegmentedControl *segC = [[UISegmentedControl alloc] initWithItems:array];
    segC.selectedSegmentIndex = 0;
    [segC addTarget:self action:@selector(clickSegmentedControll:) forControlEvents:UIControlEventValueChanged];
    segC.width = SCScreenWith * 0.6;
    segC.height = SCNavigationBarH * 0.55;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, [UIColor emeraldColor], NSForegroundColorAttributeName, nil, nil];
    [segC setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    [segC setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil, nil] forState:UIControlStateHighlighted];
    
    self.navigationItem.titleView = segC;
}

#pragma mark 监听titleView点击
- (void)clickSegmentedControll:(UISegmentedControl *)seg
{
    NSInteger indext = seg.selectedSegmentIndex;
    switch (indext) {
        case 0:
            [self clickDetailBtn]; // 详情
            break;
         case 1:
            [self clickWebBtn]; // 网站
            break;
        default:
            break;
    }
}
// 详情
- (void)clickDetailBtn
{
    NSLog(@"clickDetailBtn");
}
// 网站
- (void)clickWebBtn
{
    NSLog(@"clickWebBtn");
}

#pragma mark 分享
- (void)share
{
    NSLog(@"share-----%@", self.demoID);
    
}


@end
