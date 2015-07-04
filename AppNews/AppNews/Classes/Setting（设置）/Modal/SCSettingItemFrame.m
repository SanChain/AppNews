//
//  SCSettingItemFrame.m
//  AppNews
//
//  Created by SanChain on 15/7/4.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCSettingItemFrame.h"
#import "SCSettingItem.h"
#import "SCConst.h"
#import "UIView+Extension.h"
#import "NSString+Extension.h"

@implementation SCSettingItemFrame

- (void)setSettingItem:(SCSettingItem *)settingItem
{
    _settingItem = settingItem;
    
    if (settingItem.exitLogin == nil) {
        // 标题
        CGFloat titleX = SCSettingItemMargin;
        CGFloat titleY = SCSettingItemMargin;
        CGSize titleSize = [settingItem.title sizeWithfont:SCSettingTitleFont];
        self.titleF = CGRectMake(titleX, titleY, titleSize.width, titleSize.height);
        self.cellHeight = CGRectGetMaxY(self.titleF) + SCSettingItemMargin;
        
        if (settingItem.detailTitle != nil) {
            // 标题详情
            CGSize detailSize = [settingItem.detailTitle sizeWithfont:SCSettingTitleFont];
            CGFloat detailX = CGRectGetMaxX(self.titleF) + SCSettingItemMargin;
            CGFloat detailY = SCSettingItemMargin;
            CGFloat detailW = SCScreenWith - detailX - SCSettingItemRightMargin;
            self.detailTitleF = CGRectMake(detailX, detailY, detailW, detailSize.height);
        } else if (settingItem.icon != nil){
            // 头像
            CGFloat iconWH = SCSettingIconWH;
            CGFloat iconX = SCScreenWith - iconWH - SCSettingItemRightMargin;
            CGFloat iconY = SCSettingItemMargin;
            self.iconF = CGRectMake(iconX, iconY, iconWH, iconWH);
            self.cellHeight = CGRectGetMaxY(self.iconF) + SCSettingItemMargin;
            
            // 标题
            CGFloat titleX = SCSettingItemMargin;
            CGSize titleSize = [settingItem.title sizeWithfont:SCSettingTitleFont];
            CGFloat titleY = 0;
            self.titleF = CGRectMake(titleX, titleY, titleSize.width, self.cellHeight);
        }
        
    } else {
        // 退出登陆
        CGSize exitSize = [settingItem.exitLogin sizeWithfont: SCSettingTitleFont];
        CGFloat exitX = (SCScreenWith - exitSize.width) * 0.5;
        CGFloat exitY = SCSettingItemMargin;
        self.exitLoginF = CGRectMake(exitX, exitY, exitSize.width, exitSize.height);
        self.cellHeight = CGRectGetMaxY(self.exitLoginF) + SCSettingItemMargin;
    }
    
}



@end
