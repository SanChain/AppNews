//
//  SCDetailCommentsData.h
//  AppNews
//
//  Created by SanChain on 15/6/23.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDetailCommentsData : NSObject

/** 评论内容 */
@property (nonatomic, copy) NSString *message;
/** 对评论者点赞的数量 */
@property (nonatomic, strong) NSNumber *likes;
/** 评论者头像url */
@property (nonatomic, copy) NSString *author_avatar;
/** 评论者名字 */
@property (nonatomic, copy) NSString *author_name;
/** 评论者个人信息字典 要再搞个模型*/
@property (nonatomic, strong) NSDictionary *author;


/*******************回复评论者信息**************************/

/** demo作者回复评论者的信息 */
@property (nonatomic, strong) NSArray *childData;

@end
