//
//  UIBarButtonItem+Extension.m
//  Tony_微博
//
//  Created by Tony on 15/5/3.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"

@implementation UIBarButtonItem (Extension)

/**
 *  创建一个item
 *  target  点击item后调用哪个对象的方法
 *  action  点击item后调用的方法
 *  image   图片
 *  highImage 高亮的图片
 */
+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    // 设置尺寸
    btn.size = btn.currentBackgroundImage.size;
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}

@end
