//
//  SCAccountTool.m
//  AppNews
//
//  Created by SanChain on 15/6/16.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCAccountTool.h"
#import "SCAccount.h"

@implementation SCAccountTool

/** 沙盒路径 */
+ (NSString *)path
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *accountPath = [path stringByAppendingPathComponent:@"account.plist"];
    return accountPath;
}


/** 归档接口 */
+ (void)saveAccountWith:(SCAccount *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:self.path];
}

/** 解档接口 */
+ (SCAccount *)account
{
    SCAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile: self.path];
    return account;
}
@end
