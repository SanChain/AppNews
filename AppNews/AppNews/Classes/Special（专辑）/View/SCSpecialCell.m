//
//  SCSpecialCell.m
//  AppNews
//
//  Created by SanChain on 15/6/20.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCSpecialCell.h"
#import "SCSpecialItem.h"
#import "UIImageView+WebCache.h"

@implementation SCSpecialCell

- (void)awakeFromNib {
    // Initialization code
    // 设置cell的宽高
    
    // cell的间距
    
}

#pragma mark - 专辑item
- (void)setSpecialItem:(SCSpecialItem *)specialItem
{
    _specialItem = specialItem;
    
    // 设置cell的内容
    NSURL *url = [NSURL URLWithString:specialItem.thumb];
    [self.itemImage sd_setImageWithURL:url];
    self.itemTitle.text = specialItem.title;
}

@end
