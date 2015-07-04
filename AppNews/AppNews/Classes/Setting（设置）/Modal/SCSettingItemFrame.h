//
//  SCSettingItemFrame.h
//  AppNews
//
//  Created by SanChain on 15/7/4.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCSettingItem;

@interface SCSettingItemFrame : NSObject

/** 标题Frame */
@property (nonatomic, assign) CGRect titleF;
/** 退出登陆Frame */
@property (nonatomic, assign) CGRect exitLoginF;
/** 头像Frame */
@property (nonatomic, assign) CGRect iconF;
/** 标题详情Frame */
@property (nonatomic, assign) CGRect detailTitleF;
/** cellHeight */
@property (nonatomic, assign) CGFloat cellHeight;

/** SCSettingItem模型 */
@property (nonatomic, strong) SCSettingItem *settingItem;

@end
