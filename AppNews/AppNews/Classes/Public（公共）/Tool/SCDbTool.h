//
//  SCDbTool.h
//  AppNews
//
//  Created by SanChain on 15/6/27.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDbTool : NSObject

/************************查询数据库操作************************/

// 查询每日模块数据库
+ (NSArray *)queryDemoData;

// 查询最新模块数据库
+ (NSArray *)queryNewDemoData;

// 查询专辑模块数据库
+ (NSArray *)querySpecialDemoData;

// 查询我的模块数据库
+ (NSArray *)queryProfileData;

/************************写入数据库操作************************/

// 每日模块写入数据库
+ (void)saveDemoData:(NSArray *)data;

// 最新模块写入数据库
+ (void)saveNewDemoData:(NSArray *)data;

// 专辑模块写入数据库
+ (void)saveSpecialDemoData:(NSArray *)data;

// 我的模块写入数据库
+ (void)saveProfileData:(NSArray *)data;

@end
