//
//  SCDetailLikesData.h
//  AppNews
//
//  Created by SanChain on 15/6/23.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDetailLikesData : NSObject
/** 点赞者id */
@property (nonatomic, strong) NSNumber *userid;
/** 点赞者名字 */
@property (nonatomic, copy) NSString *nickname;
/** 点赞者描述 */
@property (nonatomic, copy) NSString *desc;
/** 评论过的demo数量 */
@property (nonatomic, strong) NSNumber *comments;
/** 发布过的demo数量 */
@property (nonatomic, strong) NSNumber *publishs;
/** 点赞过的demo数量 */
@property (nonatomic, strong) NSNumber *likes;
/** 点赞者头像url */
@property (nonatomic, copy) NSString *avatar;
@end
