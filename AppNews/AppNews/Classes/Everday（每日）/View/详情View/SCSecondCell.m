//
//  SCSecondCell.m
//  AppNews
//
//  Created by SanChain on 15/6/24.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCSecondCell.h"

@implementation SCSecondCell

- (void)awakeFromNib {
    // Initialization code
}


// 加载xib
+ (instancetype)loadFirstCell
{
    return [[NSBundle mainBundle] loadNibNamed:@"SCSecondCell" owner:nil options:nil][0];
}

// 实例化可重用的cell
+ (instancetype)loadNewCellWithTableView:(UITableView *)tableView
{
    SCSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[SCSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}
@end
