//
//  SCTextView.h
//  AppNews
//
//  Created by SanChain on 15/7/5.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCTextView : UITextView
// 占位文字
@property (nonatomic, strong) NSString *placeholder;
// 占位文字的颜色
@property (nonatomic, weak) UIColor *placeholderColor;

@end
