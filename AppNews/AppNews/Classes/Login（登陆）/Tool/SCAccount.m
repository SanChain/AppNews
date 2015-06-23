//
//  SCAccount.m
//  AppNews
//
//  Created by SanChain on 15/6/16.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCAccount.h"

@implementation SCAccount

// 归档时调用
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.loginAccount forKey:@"loginAccount"];
    [aCoder encodeObject:self.loginPassword forKey:@"loginPassword"];
}

// 解档时调用
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
       self.loginAccount = [aDecoder decodeObjectForKey:@"loginAccount"];
       self.loginPassword = [aDecoder decodeObjectForKey:@"loginPassword"];
    }
    return self;
}

@end
