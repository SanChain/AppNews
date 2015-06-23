//
//  SCDetailDemo.m
//  AppNews
//
//  Created by SanChain on 15/6/23.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCDetailDemo.h"
#import "MJExtension.h"

@implementation SCDetailDemo

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

// 模型 嵌套 模型的关联
+ (NSDictionary *)objectClassInArray
{
    return @{
             
             @"likesData" : @"SCDetailLikesData",
             @"commentsData" : @"SCDetailCommentsData"
             };
}

@end
