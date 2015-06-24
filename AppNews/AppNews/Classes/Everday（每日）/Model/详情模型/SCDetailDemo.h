//
//  SCDetailDemo.h
//  AppNews
//
//  Created by SanChain on 15/6/23.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDetailDemo : NSObject
/** demoID */
@property (nonatomic, strong) NSNumber *ID;
/** 点赞数量 */
@property (nonatomic, strong) NSNumber *likes;
/** 评论数量（包含回复数量） */
@property (nonatomic, strong) NSNumber *comments;
/** demo的名称 */
@property (nonatomic, copy) NSString *title;
/** demo的描述 */
@property (nonatomic, copy) NSString *intro;
/** demo的网页url */
@property (nonatomic, copy) NSString *website;
/** 发布demo的用户id */
@property (nonatomic, copy) NSString *userid;
/** demo在appStore的下载链接（url) */
@property (nonatomic, copy) NSString *applink;
/** 是否是创业者 */
@property (nonatomic, strong) NSNumber *isfounder;
/** 净回复数量 */
@property (nonatomic, strong) NSNumber *comments2;

/*****************************以下嵌套模型*********************************/

/** 发布demo的作者信息 */
@property (nonatomic, strong) NSDictionary *author;
/** 点赞者所有的数据 */
@property (nonatomic, strong) NSArray *likesData;
/** 评论者所有的数据 */
@property (nonatomic, strong) NSArray *commentsData;

@end
