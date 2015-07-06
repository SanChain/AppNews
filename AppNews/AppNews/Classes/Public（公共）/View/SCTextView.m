//
//  SCTextView.m
//  AppNews
//
//  Created by SanChain on 15/7/5.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCTextView.h"

@implementation SCTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        // 通知
        // 当UITextView的文字发生改变时，UITextView自己会发出一个UITextViewTextDidChangeNotification通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
        self.placeholderColor = [UIColor grayColor];
    }
    return self;
    
    //     UITextViewTextDidBeginEditingNotification; 当开始输入文字时
    //     UITextViewTextDidChangeNotification; 当文字发生改变时（有文字或者没有文字)
    //     UITextViewTextDidEndEditingNotification; 当结束输入文字时
}

/**
 *  监听文字改变
 */
- (void)textDidChange
{
    // 重绘(重新调用 drawRect） ,setNeedDisplay会在下一个消息循环时刻，调用drawRect
    [self setNeedsDisplay];
}

// 画占位文字
- (void)drawRect:(CGRect)rect
{
    // self.hasText 检测textView是否有文字， 如果有输入文字，就直接返回，不画占位文字
    if (self.hasText) return;
    
    // 文字属性
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = self.placeholderColor;
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    
    // 画文字
    CGFloat x = 5;
    CGFloat y = 8;
    CGFloat w = rect.size.width - 2 * x;
    CGFloat h = rect.size.height - 2 * y;
    CGRect placeholderRect = CGRectMake(x, y, w, h);
    [self.placeholder drawInRect:placeholderRect withAttributes:attr];
}


/**
 *  自定义控件， 重写setter
 */
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
