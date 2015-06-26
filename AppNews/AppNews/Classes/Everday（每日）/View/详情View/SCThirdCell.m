//
//  SCThirdCell.m
//  AppNews
//
//  Created by SanChain on 15/6/24.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCThirdCell.h"
#import "UIButton+WebCache.h"
#import "SCConst.h"

@interface SCThirdCell ()
@property (nonatomic, weak) UIButton *likesBtn;

@end
@implementation SCThirdCell

// 实例化可重用的cell
+ (SCThirdCell *)loadNewCellWithTableView:(UITableView *)tableView
{
    SCThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"thirdCell"];
    if (cell == nil) {
        cell = [[SCThirdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"thirdCell"];
    }
    return cell;
}

- (void)setupCellWithArray:(NSMutableArray *)likesArray
{
    NSInteger count = likesArray.count;
    for (NSInteger i = 0; i < count; i++) {
        // 创建头像按钮
        UIButton *iconBtn = [[UIButton alloc]init];
        SCDetailLikesData *likesData = likesArray[i];
        if (i == (count-1)) { // 最后一个点赞按钮
            [iconBtn setImage:[UIImage imageNamed:@"toolbar_icon_like"] forState:UIControlStateNormal];
            NSString *likesN = [NSString stringWithFormat:@"%zd", count];
            [iconBtn setTitle: likesN forState:UIControlStateNormal];
        }
        [iconBtn sd_setImageWithURL:[NSURL URLWithString: likesData.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"tabbar_profile_selected"]];
        
        // 设置尺寸
        CGFloat iconWH = (SCScreenWith - 2*SCCellMargin - 6*SCIconMargin) / 7;
        CGFloat iconX = 0;
        CGFloat iconY = 0;
        self.cellHeight = 0;
        if (i <= 6) { // 第一行
            iconX = SCCellMargin + i * iconWH + i * SCIconMargin;
            iconY = SCCellMargin;
            self.cellHeight = iconY + iconWH + SCCellMargin;
        } else { // 第二行
            iconX = SCCellMargin + i * iconWH + i * SCIconMargin;
            iconY = SCCellMargin + iconWH + SCIconMargin;
            self.cellHeight = iconY + iconWH + SCCellMargin;
        }
        iconBtn.frame = CGRectMake(iconX, iconY, iconWH, iconWH);
        
        iconBtn.layer.cornerRadius = iconWH * 0.5;
        iconBtn.clipsToBounds = YES;
        
        // 添加到contentView
        [self.contentView addSubview:iconBtn];
    }
}


#pragma mark 设置cell的内容和frame
//- (void)setLikesArray:(NSMutableArray *)likesArray
//{
//    _likesArray = [NSMutableArray array];
//    _likesArray = likesArray;
//    
//}


@end
