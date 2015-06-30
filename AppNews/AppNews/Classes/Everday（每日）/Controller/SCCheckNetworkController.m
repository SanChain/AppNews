//
//  SCCheckNetworkController.m
//  AppNews
//
//  Created by SanChain on 15/6/30.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCCheckNetworkController.h"

@interface SCCheckNetworkController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation SCCheckNetworkController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"检查网络连接";
    self.navigationItem.backBarButtonItem.title = @"返回";
}

// 修改scrollView的contentSize
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    self.scrollView.contentSize = CGSizeMake(0, [UIScreen mainScreen].bounds.size.height * 1.2);
}

@end
