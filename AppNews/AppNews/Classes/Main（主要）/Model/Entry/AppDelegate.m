//
//  AppDelegate.m
//  AppNews
//
//  Created by SanChain on 15/6/13.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "AppDelegate.h"
#import "SCTabBarController.h"
#import "SCNavigationController.h"
#import "SCNewfeatureController.h"
#import "UIWindow+Extension.h"
#import "SCAccount.h"
#import "SCAccountTool.h"
#import "SDWebImageManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/**
 *  程序启动会调用这个方法
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 设置根控制器
    SCAccount *account = [SCAccountTool account];
    if (account) { // 登陆过了
        SCTabBarController *tabC = [[SCTabBarController alloc] init];
        self.window.rootViewController = tabC;
        
    } else { // 没有登陆过
        [self.window switchRootViewController];
    }
    
    [self.window makeKeyAndVisible];
    
    // 取消推送
    application.applicationIconBadgeNumber = 0;

    NSArray *array =  application.scheduledLocalNotifications;
    for (UILocalNotification *localNoti in array) {
        NSDictionary *dict = localNoti.userInfo;
        NSString *string  = dict[@"key"];
        if ([string isEqualToString:@"新的开始"]) {
            [application cancelLocalNotification:localNoti];
        }
    }
    
    return YES;
}

/**
 *  程序在前台会自动调用这个方法
 *  程序在后台点击通知进入前台时会调用这个方法
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    application.applicationIconBadgeNumber = 0;

    // 取消相应的推送
    NSArray *array =  application.scheduledLocalNotifications;
    NSLog(@"---->%@", array);
    for (UILocalNotification *localNoti in array) {
        NSDictionary *dict = localNoti.userInfo;
        NSString *string  = dict[@"key"];
        if ([string isEqualToString:@"新的开始"]) {
            [application cancelLocalNotification:localNoti];
        } else {
            return;
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

// 收到内存警告
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    NSLog(@"内存警告");
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    // 取消所有下载
    [mgr cancelAll];
    // 清除内存中所有图片
    [mgr.imageCache clearMemory];
}

@end
