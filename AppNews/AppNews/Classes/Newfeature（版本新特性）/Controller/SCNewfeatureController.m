//
//  SCNewfeatureController.m
//  AppNews
//
//  Created by SanChain on 15/6/16.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCNewfeatureController.h"
#import "SCConst.h"
#import "UIView+Extension.h"
#import "SCLoginViewController.h"

@interface SCNewfeatureController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIPageControl *pageC;
@end

@implementation SCNewfeatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 创建scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame: SCScreenFrame];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES; // 分页效果
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(SCScreenWith * SCImageCount, SCScreenHeight);
    scrollView.delegate = self;
    
    // 2. 添加imageView到scrollView
    for (NSInteger i = 0; i < SCImageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *imageName = [NSString stringWithFormat:@"new_feature_%zd", i + 1];
        imageView.image = [UIImage imageNamed: imageName];
        CGFloat imageViewX = i * SCScreenWith;
        CGFloat imageViewY = 0;
        CGFloat imageViewW = SCScreenWith;
        CGFloat imageViewH = SCScreenHeight;
        imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
        
        if (i == SCImageCount - 1) {
            [self addButtonInImageView:imageView];
        }
        
        [scrollView addSubview:imageView];
    }
    
    // 3. 添加页码
    UIPageControl *pageC = [[UIPageControl alloc] init];
    pageC.numberOfPages = SCImageCount;
    CGFloat pageCenterX = SCScreenWith * 0.5;
    CGFloat pageCenterY = SCScreenHeight * 0.95;
    pageC.center = CGPointMake(pageCenterX, pageCenterY);
    
    pageC.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageC.pageIndicatorTintColor = SCColour(124, 124, 124);
    [self.view addSubview:scrollView];
    [self.view addSubview:pageC];
    self.pageC = pageC;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / SCScreenWith;
    self.pageC.currentPage = page;
}

#pragma mark - 设置最后一页
- (void)addButtonInImageView:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES; // 交互
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"欢迎来到APP的世界" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    button.size = CGSizeMake(200, 80);
    CGFloat btnCentX = SCScreenWith * 0.5;
    CGFloat btnCentY = SCScreenHeight * 0.9;
    button.center = CGPointMake(btnCentX, btnCentY);
    
    [button addTarget:self action:@selector(clickLoginButton) forControlEvents:UIControlEventTouchUpInside];
    
    [imageView addSubview:button];
}

#pragma mark - 进入登陆界面的接口
- (void)clickLoginButton
{
    SCLoginViewController *loginVC = [[SCLoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
}

@end
