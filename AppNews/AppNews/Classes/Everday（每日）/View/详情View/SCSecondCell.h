//
//  SCSecondCell.h
//  AppNews
//
//  Created by SanChain on 15/6/24.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCDetailDemo;

@interface SCSecondCell : UITableViewCell
// 实例化可重用的cell
+ (SCSecondCell *)loadNewCellWithTableView:(UITableView *)tableView;

/** detailDemo模型 */
@property (nonatomic, strong) SCDetailDemo *detailDemo;
@end
