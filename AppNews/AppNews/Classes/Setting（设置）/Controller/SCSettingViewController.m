//
//  SCSettingViewController.m
//  AppNews
//
//  Created by SanChain on 15/7/4.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCSettingViewController.h"
#import "SCSettingItem.h"
#import "SCSettingItemFrame.h"
#import "SCSettingCell.h"
#import "SCConst.h"

@interface SCSettingViewController ()
@property (nonatomic, strong) NSMutableArray *itemGroup;
@end

@implementation SCSettingViewController
- (NSMutableArray *)itemGroup
{
    if (!_itemGroup) {
        _itemGroup = [NSMutableArray array];
    }
    return _itemGroup;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.tableView.backgroundColor = SCColour(240, 237, 245);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = YES;

    // 设置cell的间距
    // group状态下，sectionFooterHeight和sectionHeaderHeight默认是有值
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = SCSettingCellMargin;
    // ios7之后要设置contentInset,35是一个特殊值，必须要用。
    self.tableView.contentInset = UIEdgeInsetsMake(SCSettingCellMargin - 35, 0, 0, 0);
    
    // 设定模型数据
    [self setupModalData];
}

#pragma mark 设定模型数据
- (void)setupModalData
{
    // 第1组
    SCSettingItem *item1 = [[SCSettingItem alloc] itemWith:@"头像" exitLogin:nil icon:@"me" detailTitle:nil type:CellAccessoryDisclosureIndicator];
    item1.operation = ^{
        NSLog(@"头像Block");
    };
    SCSettingItemFrame *itemFrame1 = [[SCSettingItemFrame alloc] init];
    itemFrame1.settingItem = item1;
    [self.itemGroup addObject:@[itemFrame1]];
    
    // 第2组
    SCSettingItem *item2 = [[SCSettingItem alloc] itemWith:@"姓名" exitLogin:nil icon:nil detailTitle:@"SanChain" type:CellAccessoryDisclosureIndicator];
    SCSettingItemFrame *itemFrame2 = [[SCSettingItemFrame alloc] init];
    itemFrame2.settingItem = item2;
    
    SCSettingItem *item3 = [[SCSettingItem alloc] itemWith:@"简介" exitLogin:nil icon:nil detailTitle:@"coder" type:CellAccessoryDisclosureIndicator];
    SCSettingItemFrame *itemFrame3 = [[SCSettingItemFrame alloc] init];
    itemFrame3.settingItem = item3;
    [self.itemGroup addObject:@[itemFrame2, itemFrame3]];
    
    // 第3组
    SCSettingItem *item4 = [[SCSettingItem alloc] itemWith:@"修改密码" exitLogin:nil icon:nil detailTitle:nil type:CellAccessoryDisclosureIndicator];
    SCSettingItemFrame *itemFrame4 = [[SCSettingItemFrame alloc] init];
    itemFrame4.settingItem = item4;
    [self.itemGroup addObject:@[itemFrame4]];
    
    // 第4组
    SCSettingItem *item5 = [[SCSettingItem alloc] itemWith:@"清理缓存" exitLogin:nil icon:nil detailTitle:@"缓存大小" type:CellAccessoryDisclosureIndicator];
    SCSettingItemFrame *itemFrame5 = [[SCSettingItemFrame alloc] init];
    itemFrame5.settingItem = item5;
    [self.itemGroup addObject:@[itemFrame5]];
    
    // 第5组
    SCSettingItem *item6 = [[SCSettingItem alloc] itemWith:nil exitLogin:@"退出登陆" icon:nil detailTitle:nil type:CellAccessoryDisclosureNone];
    SCSettingItemFrame *itemFrame6 = [[SCSettingItemFrame alloc] init];
    itemFrame6.settingItem = item6;
    [self.itemGroup addObject:@[itemFrame6]];
}

#pragma mark tableView数据源/代理Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.itemGroup[section]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建cell
    SCSettingCell *cell = [SCSettingCell settingCellWithTableview:tableView];
    // 传模型数据给cell
    cell.itemFrame = self.itemGroup[indexPath.section][indexPath.row];
    cell.indexPath = indexPath;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCSettingItemFrame *itemFrame = self.itemGroup[indexPath.section][indexPath.row];
    SCSettingItem *item = itemFrame.settingItem;
    // 执行block
    if (item.operation) {
        item.operation();
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCSettingItemFrame *itemFrame = self.itemGroup[indexPath.section][indexPath.row];
    return itemFrame.cellHeight;
    
}

@end
