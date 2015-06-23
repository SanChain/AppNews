//
//  UIBarButtonItem+Extension.h
//  Tony_微博
//
//  Created by Tony on 15/5/3.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

// 工厂方法
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;

@end


