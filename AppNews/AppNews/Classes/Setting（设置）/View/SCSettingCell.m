//
//  SCSettingCell.m
//  AppNews
//
//  Created by SanChain on 15/7/4.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCSettingCell.h"
#import "SCSettingItem.h"
#import "SCSettingItemFrame.h"
#import "SCConst.h"
#import "Colours.h"


@interface SCSettingCell ()
@property (nonatomic, weak) UILabel *titleL;
@property (nonatomic, weak) UILabel *detailL;
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *exitLoginL;
@property (nonatomic, weak) UIView *cellLine;
@end

@implementation SCSettingCell

+ (instancetype)settingCellWithTableview:(UITableView *)tableview
{
    static NSString *ID = @"cell";
    
    SCSettingCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 添加cell的子控件
        [self setupCellSubviews];
    }
    return self;
}

#pragma mark 设置cell的子控件
- (void)setupCellSubviews
{
    // 标题
    UILabel *titleL = [[UILabel alloc] init];
    titleL.font = SCSettingTitleFont;
    titleL.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleL];
    self.titleL = titleL;
    
    // 标题详情
    UILabel *detaiL = [[UILabel alloc] init];
    detaiL.textAlignment = NSTextAlignmentRight;
    detaiL.font = SCSettingDetailFont;
    detaiL.textColor = [UIColor black75PercentColor];
    [self.contentView addSubview:detaiL];
    self.detailL = detaiL;
    
    // 头像
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    imageView.backgroundColor = [UIColor orangeColor];
    imageView.layer.cornerRadius = SCSettingIconWH * 0.5;
    imageView.clipsToBounds = YES;
    self.iconImageView = imageView;
    
    // 退出登陆
    UILabel *exitLoginL = [[UILabel alloc] init];
    exitLoginL.textColor = [UIColor orangeColor];
    exitLoginL.font = SCSettingTitleFont;
    [self.contentView addSubview:exitLoginL];
    self.exitLoginL = exitLoginL;
    
    // cell的分隔线
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor wheatColor];
    view.frame = CGRectMake(0, 0, SCScreenWith, 0.5);
    [self.contentView addSubview:view];
    self.cellLine = view;
}

#pragma mark 设置cell分隔线
- (void)setIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 1) {
        self.cellLine.hidden = NO;
    } else {
        self.cellLine.hidden = YES;
    }
}


#pragma mark 设置cell的内容和frame
- (void)setItemFrame:(SCSettingItemFrame *)itemFrame
{
    _itemFrame = itemFrame;
    SCSettingItem *settingItem = itemFrame.settingItem;
    
    if (settingItem.exitLogin == nil) {
        // 标题
        self.titleL.text = settingItem.title;
        self.titleL.frame = itemFrame.titleF;
        
        if (settingItem.detailTitle != nil) {
            // 标题详情
            self.detailL.text = settingItem.detailTitle;
            self.detailL.frame = itemFrame.detailTitleF;
        } else if (settingItem.icon != nil){
            // 头像
            self.iconImageView.image = [UIImage imageNamed:settingItem.icon];
            self.iconImageView.frame = itemFrame.iconF;
        }
        
    } else {
        // 退出登陆
        self.exitLoginL.text = settingItem.exitLogin;
        self.exitLoginL.frame = itemFrame.exitLoginF;
    }
    
    if (settingItem.type == CellAccessoryDisclosureIndicator) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
