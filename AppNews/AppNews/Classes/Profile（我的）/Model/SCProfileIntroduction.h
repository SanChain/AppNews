//
//  SCProfileIntroduction.h
//  AppNews
//
//  Created by SanChain on 15/6/21.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCProfileIntroduction : NSObject
/** 头像名 */
@property (nonatomic, copy) NSString *nickname;
/** 个人描述 */
@property (nonatomic, copy) NSString *intro;
/** 喜欢的app */
@property (nonatomic, copy) NSString *likesApp;

@end
