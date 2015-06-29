//
//  SCNetworkTool.h
//  AppNews
//
//  Created by SanChain on 15/6/29.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface SCNetworkTool : NSObject
// 检测是否wifi网络
+ (BOOL)isEnableWIFI;

// 检测是否4G\3G\2.5G网络
+ (BOOL)isEnable3G;
@end
