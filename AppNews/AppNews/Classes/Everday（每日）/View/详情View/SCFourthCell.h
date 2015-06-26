//
//  SCFourthCell.h
//  AppNews
//
//  Created by SanChain on 15/6/24.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCDetailCommentsData;

@interface SCFourthCell : UITableViewCell
//加载xib
+ (instancetype)loadFirstCell;

// 实例化可重用的cell
+ (instancetype)loadNewCellWithTableView:(UITableView *)tableView;


@property (nonatomic, strong) SCDetailCommentsData *commentsData;

@end
