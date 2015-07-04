//
//  SCSettingItem.h
//  AppNews
//
//  Created by SanChain on 15/7/4.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CellAccessoryDisclosureNone,
    CellAccessoryDisclosureIndicator
}cellAccessoryType;

@interface SCSettingItem : NSObject
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 退出登陆 */
@property (nonatomic, copy) NSString *exitLogin;
/** 头像 */
@property (nonatomic, copy) NSString *icon;
/** 标题详情描述 */
@property (nonatomic, copy) NSString *detailTitle;
/** 样式的类型 */
@property (nonatomic, assign) cellAccessoryType  type;
/** 点击cell的操作 */
@property (nonatomic, copy) void(^operation)();

/** 初始化模型 */
- (instancetype)itemWith:(NSString *)title exitLogin:(NSString *)exitLogin icon:(NSString *)icon detailTitle:(NSString *)detailTitle type:(cellAccessoryType)type;

@end
