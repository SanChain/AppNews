//
//  SCEverydayDemo.h
//  AppNews
//
//  Created by SanChain on 15/6/17.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCEverydayDemo : NSObject
/** 日期 */
@property (nonatomic, copy) NSString *date;
/** 当前页所有item的内容 */
@property (nonatomic, strong) NSArray *items;

@end
