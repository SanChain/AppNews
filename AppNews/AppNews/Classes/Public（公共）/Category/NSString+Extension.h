//
//  NSString+Extension.h
//  01_正则表达式基本使用
//
//  Created by Tony on 15/5/30.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Extension)

/**
 *  正则表达式的封装
 */
// QQ
- (BOOL)isQQ;
// 手机号码
- (BOOL)isPhoneNumber;
// ip地址
- (BOOL)isIPAddress;
// 邮箱
- (BOOL)isEmail;
// 身份证
- (BOOL)isIdentityCard;
// 是否包含字母
- (BOOL)isContainGraphema;

/*******************************************************************/

/**
 *  根据文字属性计算宽高
 */
// 根据NSString 的text font 来计算 宽高
- (CGSize)sizeWithfont:(UIFont *)font;

// 返回CGSize, 计算一大块文字的尺寸(size)
- (CGSize)sizeWithfont:(UIFont *)font maxW:(CGFloat)maxW;

// 计算文件大小(字节）
- (NSInteger)fileSize;


@end
