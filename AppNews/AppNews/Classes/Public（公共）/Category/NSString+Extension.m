//
//  NSString+Extension.m
//  01_正则表达式基本使用
//
//  Created by Tony on 15/5/30.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

#pragma mark - 正则表达式封装
// 抽取出来
- (BOOL)matchWithPattern:(NSString *)pattern
{
    // 创建正则表达式
    NSRegularExpression *regex = [[NSRegularExpression alloc]initWithPattern:pattern options:0 error:nil];
    
    // 匹配结果
    NSArray *array = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    return array.count > 0;
}

// 匹配
- (BOOL)isQQ
{
    // 规则
    // 1.不能以0开头
    // 2.全部是数字
    // 3.5-11位
    return [self matchWithPattern:@"^[1-9]\\d{4,10}$"];
}

- (BOOL)isPhoneNumber
{
    return [self matchWithPattern:@"^1[3578]\\d{9}$"];
}

- (BOOL)isIPAddress
{
    return [self matchWithPattern:@"^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$"];
}

- (BOOL)isEmail
{
    return [self matchWithPattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

- (BOOL)isIdentityCard
{
    return [self matchWithPattern:@"^(\\d{14}|\\d{17})(\\d|[xX])$"];
}

- (BOOL)isContainGraphema
{
    return [self matchWithPattern:@"[A-Za-z]"];
}



/*********************************华丽分隔线************************************/



#pragma mark - 根据文字属性计算宽高
// 根据NSString 的text font 来计算 宽高
- (CGSize)sizeWithfont:(UIFont *)font
{
    return [self sizeWithfont:font maxW:MAXFLOAT];
}

// 返回CGSize, 计算一大块文字的尺寸(size)
- (CGSize)sizeWithfont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT); // 最大size
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
}




/*********************************华丽分隔线************************************/




// 计算文件大小
- (NSInteger)fileSize
{
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 判断是否为文件
    BOOL dir = NO;
    BOOL exist = [mgr fileExistsAtPath:self isDirectory:&dir];
    
    // 文件或文件夹不存在
    if (exist == NO) return 0;
    
    if (dir) { // 是文件夹
        // 遍历cachesPath里面所有的内容---直接和间接内容
        NSArray *subpath = [mgr subpathsAtPath:self];
        NSInteger totalByteSize = 0;
        for (NSString *filePath in subpath) {
            // 子文件或子文件夹的全路径
            NSString *fullPath = [self stringByAppendingPathComponent:filePath];
            
            // 判断是否为文件
            BOOL dir = NO;
            [mgr fileExistsAtPath:fullPath isDirectory:&dir];
            if (!dir) { // 是文件
                
                // 计算所有文件的大小
                NSDictionary *dict = [mgr attributesOfItemAtPath:fullPath error:nil];
                totalByteSize += [dict[NSFileSize]integerValue];
            }
        }
        return totalByteSize;
    } else { // 是文件
        
        return [[mgr attributesOfItemAtPath:self error:nil][NSFileSize] integerValue];
    }
    
}

@end
