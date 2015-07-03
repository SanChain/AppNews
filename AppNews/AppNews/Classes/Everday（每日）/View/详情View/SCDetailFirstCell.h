//
//  SCDetailFirstCell.h
//  AppNews
//
//  Created by SanChain on 15/6/24.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCDetailDemoAuthor;

@interface SCDetailFirstCell : UITableViewCell
// 加载xib
+ (instancetype)loadFirstCell;

// 初始化cell
+ (instancetype)loadNewCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) SCDetailDemoAuthor *demoAuthor;

@end
