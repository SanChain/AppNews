//
//  SCNewDemoItem.h
//  AppNews
//
//  Created by SanChain on 15/6/18.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCNewDemoItem : NSObject

/** 点赞数量 */
@property (nonatomic, strong) NSNumber *likes;
/** demo的名称 */
@property (nonatomic, copy) NSString *title;
/** demo的描述 */
@property (nonatomic, copy) NSString *intro;
/** demo的网页url */
@property (nonatomic, copy) NSString *website;
/** demo在appStore的下载链接（url) */
@property (nonatomic, copy) NSString *applink;
/** 是否是创业者 */
@property (nonatomic, strong) NSNumber *isfounder;
/** demoItem发布的时间 */
@property (nonatomic, strong) NSNumber *inputtime;

@end
