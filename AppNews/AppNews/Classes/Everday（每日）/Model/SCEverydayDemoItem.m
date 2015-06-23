//
//  SCEverydayDemoItem.m
//  AppNews
//
//  Created by SanChain on 15/6/17.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCEverydayDemoItem.h"
#import "MJExtension.h"

@implementation SCEverydayDemoItem

//+ (void)setupReplacedKeyFromPropertyName:(MJReplacedKeyFromPropertyName)replacedKeyFromPropertyName
//{
//    [self setupReplacedKeyFromPropertyName:^NSDictionary *{
//        return @{@"ID" : @"id"};
//    }];
//}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

@end
