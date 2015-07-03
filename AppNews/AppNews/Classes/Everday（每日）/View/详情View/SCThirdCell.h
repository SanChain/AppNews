//
//  SCThirdCell.h
//  AppNews
//
//  Created by SanChain on 15/6/24.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCDetailLikesData;

#define SCCellMargin 10
#define SCIconMargin 5

@interface SCThirdCell : UITableViewCell

// 实例化可重用的cell
+ (SCThirdCell *)loadNewCellWithTableView:(UITableView *)tableView;

// cell的高度
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) SCDetailLikesData *likesData;
@property (nonatomic, strong) NSMutableArray *likesArray;

- (void)setupCellWithArray:(NSMutableArray *)likesArray;

@end
