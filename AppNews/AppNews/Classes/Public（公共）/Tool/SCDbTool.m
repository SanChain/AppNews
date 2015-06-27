//
//  SCDbTool.m
//  AppNews
//
//  Created by SanChain on 15/6/27.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//


/** 
 *  做离线缓存用到：
 *  FMDB
 *  用到三条SQL语句：1、创表. 2、插入数据. 3、查询数据.
 *  四个模块要用到离线缓存，就需要创建四张表，存不同的数据。
 */

#import "SCDbTool.h"
#import "FMDB.h"

static FMDatabase *_fd;

@implementation SCDbTool

#pragma mark 初始化数据库
// 使用类之前会调用
+ (void)initialize
{
    // 创建数据库并找开
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [path stringByAppendingPathComponent:@"demo.sqlite"];
    _fd = [FMDatabase databaseWithPath:dbPath];
    [_fd open];
    
    // 创表
    [_fd executeUpdate:@"CREATE TABLE IF NOT EXISTS t_demo(id integer PRIMARY KEY, demo blob NOT NULL, demoID integer);"];
    [_fd executeUpdate:@"CREATE TABLE IF NOT EXISTS t_newDemo(id integer PRIMARY KEY, newDemo blob NOT NULL, demoID integer);"];
    [_fd executeUpdate:@"CREATE TABLE IF NOT EXISTS t_specialDemo(id integer PRIMARY KEY, specialDemo blob NOT NULL, demoID integer);"];
    [_fd executeUpdate:@"CREATE TABLE IF NOT EXISTS t_profileDemo(id integer PRIMARY KEY, profileDemo blob NOT NULL, demoID integer);"];
    
}

#pragma mark 写入数据库
// 每日模块写入数据库
+ (void)saveDemoData:(NSArray *)data
{
    // 存储数组里每一个字典对象，字典对象就是一条demo新闻
    for (NSDictionary *demo in data) {
        // 数据库只存储NSData，将NSDictionary转NSData
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:demo];
        [_fd executeUpdateWithFormat:@"INSERT INTO t_demo(demo, demoID)VALUES(%@,%@);", data, demo[@"id"]];
    }
}

// 最新模块写入数据
+ (void)saveNewDemoData:(NSArray *)data
{
    for (NSDictionary *dict in data) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
        [_fd executeUpdateWithFormat:@"INSERT INTO t_newDemo(newDemo, demoID)VALUES(%@, %@);", data, dict[@"id"]];
    }
}

// 专辑模块写入数据库
+ (void)saveSpecialDemoData:(NSArray *)data
{
    for (NSDictionary *dict in data) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
        [_fd executeUpdateWithFormat:@"INSERT INTO t_specialDemo(specialDemo,demoID)VALUES(%@,%@);", data, dict[@"id"]];
    }
}

// 我的模块写入数据库
+ (void)saveProfileData:(NSArray *)data
{
    for (NSDictionary *dict in data) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
        [_fd executeUpdateWithFormat:@"INSERT INTO t_profileDemo(profileDemo, demoID)VALUES(%@,%@);", data, dict[@"id"]];
    }
}


#pragma mark 查询数据库
// 查询我的模块数据库
+ (NSArray *)queryDemoData
{
    // sql语句：降序查询10条语句
    NSString *sql = @"SELECT * FROM t_demo ORDER BY demoID DESC LIMIT 10;";
    
    // 执行sql语句
    FMResultSet *set = [_fd executeQuery:sql];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    while (set.next) {
        NSData *data = [set objectForColumnName:@"demo"];
        // NSData转NSDictionary
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [arrayM addObject:dict];
    }
    return arrayM;
}

// 查询最新模块数据库
+ (NSArray *)queryNewDemoData
{
    // sql语句
    NSString *sql = @"SELECT * FROM t_newDemo ORDER BY demoID DESC LIMIT 20;";
    
    // 执行sql语句
    FMResultSet *set = [_fd executeQuery:sql];
    NSMutableArray *array = [NSMutableArray array];
    while (set.next) {
        NSData *data = [set objectForColumnName:@"newDemo"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [array addObject:dict];
    }
    return array;
}

// 查询专辑模块数据库
+ (NSArray *)querySpecialDemoData
{
    // sql语句
    NSString *sql = @"SELECT * FROM t_specialDemo ORDER BY demoID DESC LIMIT 20;";
    
    // 执行sql语句
    FMResultSet *set = [_fd executeQuery:sql];
    NSMutableArray *array = [NSMutableArray array];
    while (set.next) {
        NSData *data = [set objectForColumnName:@"specialDemo"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [array addObject:dict];
    }
    return array;
    
}

// 查询我的模块数据库
+ (NSArray *)queryProfileData
{
    // sql语句
    NSString *sql = @"SELECT * FROM t_profileDemo ORDER BY demoID DESC LIMIT 10;";
    
    // 执行sql语句
    FMResultSet *set = [_fd executeQuery:sql];
    NSMutableArray *array = [NSMutableArray array];
    while (set.next) {
        NSData *data = [set objectForColumnName:@"profileDemo"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [array addObject:dict];
    }
    return array;
}


@end
