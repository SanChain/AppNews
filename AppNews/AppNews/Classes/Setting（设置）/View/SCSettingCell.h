//
//  SCSettingCell.h
//  AppNews
//
//  Created by SanChain on 15/7/4.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCSettingItemFrame;

@interface SCSettingCell : UITableViewCell

/** itemFrame模型 */
@property (nonatomic, strong) SCSettingItemFrame *itemFrame;

/** 创建cell */
+ (instancetype)settingCellWithTableview:(UITableView *)tableview;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
