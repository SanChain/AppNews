//
//  SCNetworkTool.m
//  AppNews
//
//  Created by SanChain on 15/6/29.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCNetworkTool.h"
#import "Reachability.h"

@implementation SCNetworkTool

// 检测是否wifi网络
+ (BOOL)isEnableWIFI
{
    return ([[Reachability reachabilityForLocalWiFi]  currentReachabilityStatus] != NotReachable);
}

// 检测是否4G\3G\2.5G网络
+ (BOOL)isEnable3G
{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

@end
