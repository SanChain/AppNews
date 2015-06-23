//
//  SCReplyCommentAuthor.h
//  AppNews
//
//  Created by SanChain on 15/6/24.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCReplyCommentAuthor : NSObject

/** 回复评论者的内容 */
@property (nonatomic, copy) NSString *message;
/** 回复评论者的回复者名字 */
@property (nonatomic, copy) NSString *author_name;

@end
