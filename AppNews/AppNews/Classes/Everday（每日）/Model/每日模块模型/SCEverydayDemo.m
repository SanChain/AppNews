//
//  SCEverydayDemo.m
//  AppNews
//
//  Created by SanChain on 15/6/17.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCEverydayDemo.h"
#import "MJExtension.h"

@implementation SCEverydayDemo

// 模型里的数组属性items 装着SCEverydayDemoItem模型
// 关联两个有关系的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"items" : @"SCEverydayDemoItem"};
}

@end
