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
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"

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
    
    
    /***********************友盟分享*****************************/
    
    
    [UMSocialData setAppKey:@"559a30d567e58e51b6002916"];
    
    // 新浪微博SSO授权,打开开关（非原生SDK)
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx0134f38466aeeabc" appSecret:@"d027f0cbb9615d98ffee253effb83ae1" url:@"http://www.umeng.com/social"];
    //设置手机QQ 的AppId，Appkey，和分享URL
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    
    return YES;
}

// 友盟分享_系统回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}





/****************************本地推送********************************/


/**
 *  程序在前台会自动调用这个方法
 *  程序在后台点击通知进入前台时会调用这个方法
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    application.applicationIconBadgeNumber = 0;

    // 取消相应的推送
    NSArray *array =  application.scheduledLocalNotifications;
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
    NSLog(@"内存警告了SanChain..");
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    // 取消所有下载
    [mgr cancelAll];
    // 清除内存中所有图片
    [mgr.imageCache clearMemory];
    
}

@end
