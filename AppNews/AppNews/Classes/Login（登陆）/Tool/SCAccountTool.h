//
//  SCAccountTool.h
//  AppNews
//
//  Created by SanChain on 15/6/16.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCAccount;

@interface SCAccountTool : NSObject
@property (nonatomic, strong) SCAccount *account;

/** 归档接口 */
+ (void)saveAccountWith:(SCAccount *)account;

/** 解档接口 */
+ (SCAccount *)account;
@end
