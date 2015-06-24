//
//  SCFourthCell.m
//  AppNews
//
//  Created by SanChain on 15/6/24.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCFourthCell.h"

@implementation SCFourthCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

// 加载xib
+ (instancetype)loadFirstCell
{
    return [[NSBundle mainBundle] loadNibNamed:@"SCSecondCell" owner:nil options:nil][0];
}

// 实例化可重用的cell
+ (instancetype)loadNewCellWithTableView:(UITableView *)tableView
{
    SCFourthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[SCFourthCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

@end
