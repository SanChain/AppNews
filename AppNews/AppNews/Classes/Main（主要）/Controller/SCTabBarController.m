//
//  SCTabBarController.m
//  AppNews
//
//  Created by SanChain on 15/6/15.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCTabBarController.h"
#import "SCNavigationController.h"
#import "SCEverydayController.h"
#import "SCNewController.h"
#import "SCSpecialController.h"
#import "SCProfileController.h"
#import "SCConst.h"

@interface SCTabBarController ()

@end

@implementation SCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1. 创建4个子控制器
    [self initTabBarVC];
    
}

#pragma mark - 创建4个子控制器
- (void)initTabBarVC
{
    // 1. 每日控制器
    SCEverydayController *everdayC = [[SCEverydayController alloc] init];
    [self addChildVC:everdayC withTitle:@"每日" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    // 2. 最新控制器
    SCNewController *newC = [[SCNewController alloc] init];
    [self addChildVC:newC withTitle:@"最新" image:@"radar_card_history" selectedImage:@"radar_card_history_highlighted"];
    
    // 3. 专辑控制器
    SCSpecialController *specialC = [[SCSpecialController alloc] initWithCollectionViewLayout: [[UICollectionViewFlowLayout alloc] init]];
    [self addChildVC:specialC withTitle:@"专辑" image:@"toolbar_unfavorite" selectedImage:@"toolbar_unfavorite_highlighted"];
    
    // 4. 我的控制器
    SCProfileController *profileC = [[SCProfileController alloc] init];
    [self addChildVC:profileC withTitle:@"我的" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
}

#pragma mark - 重构子控制器
- (void)addChildVC:(UIViewController *)childVC withTitle:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    [childVC setTitle:title];
    childVC.tabBarItem.image = [UIImage imageNamed:image];
     childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置tabBarItem字体属性
    NSMutableDictionary *textAttr = [NSMutableDictionary dictionary];
    textAttr[NSForegroundColorAttributeName] = SCColour(123, 123, 123);
    [childVC.tabBarItem setTitleTextAttributes:textAttr forState:UIControlStateNormal];
    
    NSMutableDictionary *selectTextAttr = [NSMutableDictionary dictionary];
    selectTextAttr[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVC.tabBarItem setTitleTextAttributes:selectTextAttr forState:UIControlStateSelected];
    
    // 结构：UITabBarController -> UINavigatioinController -> UIViewController
     SCNavigationController *navC = [[SCNavigationController alloc] initWithRootViewController:childVC];
    [self addChildViewController:navC];
}

@end
