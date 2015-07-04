//
//  SCSettingItem.m
//  AppNews
//
//  Created by SanChain on 15/7/4.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCSettingItem.h"

@implementation SCSettingItem

- (instancetype)itemWith:(NSString *)title exitLogin:(NSString *)exitLogin icon:(NSString *)icon detailTitle:(NSString *)detailTitle type:(cellAccessoryType)type
{
    self.title = title;
    self.exitLogin = exitLogin;
    self.icon = icon;
    self.detailTitle = detailTitle;
    self.type = type;
    return self;
}
@end
