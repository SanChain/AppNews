//
//  SCDetailDemoAuthor.h
//  AppNews
//
//  Created by SanChain on 15/6/23.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDetailDemoAuthor : NSObject
/** 作者id */
@property (nonatomic, strong) NSNumber *userid;
/** 作者名字 */
@property (nonatomic, copy) NSString *nickname;
/** 作者描述 */
@property (nonatomic, copy) NSString *desc;
/** 评论过的demo数量 */
@property (nonatomic, strong) NSNumber *comments;
/** 发布过的demo数量 */
@property (nonatomic, strong) NSNumber *publishs;
/** 点赞过的demo数量 */
@property (nonatomic, strong) NSNumber *likes;
/** 作者头像url */
@property (nonatomic, copy) NSString *avatar;


@end
