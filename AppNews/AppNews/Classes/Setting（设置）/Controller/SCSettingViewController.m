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
#import "SDImageCache.h"
#import "NSString+Extension.h"
#import "SCIntroViewController.h"
#import "SCNickNameController.h"

@interface SCSettingViewController ()<UIAlertViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *itemGroup;
@property (nonatomic, copy) NSString *introString;
@property (nonatomic, copy) NSString *iconUrl;

@end

typedef enum {
    iconActionSheetTag,
    exitloginActionSheetTag
}actionSheetTag;

@implementation SCSettingViewController
- (NSMutableArray *)itemGroup
{
    if (!_itemGroup) {
        _itemGroup = [NSMutableArray array];
    }
    return _itemGroup;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
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
    
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveIntroData:) name:SCIntroMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNickData:) name:SCNickMessage object:nil];
}

#pragma mark 监听各种通知
- (void)receiveNickData:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    NSString *nickMessage = dict[SCNickNameMassage];
    SCSettingItemFrame *itemF = self.itemGroup[1][0];
    itemF.settingItem.detailTitle = nickMessage;
    [self.tableView reloadData];
}

- (void)receiveIntroData:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    NSString *introMessage = dict[SCTextViewMassage];
    SCSettingItemFrame *itemF = self.itemGroup[1][1];
    itemF.settingItem.detailTitle = introMessage;
    [self.tableView reloadData];
}

#pragma mark 计算缓存
- (NSString *)caculateCaches
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cachesSize = [NSString stringWithFormat:@"缓存大小:%.1fM", [cachesPath fileSize] / 1000.0/1000.0];
    return cachesSize;
}

- (NSString *)getIconUrl
{
//    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"abc.jpg"];
//    SCLog(@"%@", path);
    if (self.iconUrl == nil) {
        self.iconUrl  = @"me";
        return self.iconUrl;
    } else {
        return self.iconUrl;
    }
}

#pragma mark 设定模型数据
- (void)setupModalData
{
    // 第1组
    SCSettingItem *item1 = [[SCSettingItem alloc] itemWith:@"头像" exitLogin:nil icon:[self getIconUrl] detailTitle:nil type:CellAccessoryDisclosureIndicator];
    item1.operation = ^{
        UIActionSheet *iconSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片的方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"相机", nil];
        iconSheet.tag = iconActionSheetTag;
        [iconSheet showInView:self.view];
    };
    SCSettingItemFrame *itemFrame1 = [[SCSettingItemFrame alloc] init];
    itemFrame1.settingItem = item1;
    [self.itemGroup addObject:@[itemFrame1]];
    
    // 第2组
    SCSettingItem *item2 = [[SCSettingItem alloc] itemWith:@"姓名" exitLogin:nil icon:nil detailTitle:@"SanChain" type:CellAccessoryDisclosureIndicator];
    item2.operation = ^{
        SCNickNameController *nickVc = [[SCNickNameController alloc] init];
        [self.navigationController pushViewController:nickVc animated:YES];
    };
    SCSettingItemFrame *itemFrame2 = [[SCSettingItemFrame alloc] init];
    itemFrame2.settingItem = item2;
    
    SCSettingItem *item3 = [[SCSettingItem alloc] itemWith:@"简介" exitLogin:nil icon:nil detailTitle:@"coder" type:CellAccessoryDisclosureIndicator];
    item3.operation = ^{
        SCIntroViewController *introVc = [[SCIntroViewController alloc] init];
        [self.navigationController pushViewController:introVc animated:YES];
    };
    SCSettingItemFrame *itemFrame3 = [[SCSettingItemFrame alloc] init];
    itemFrame3.settingItem = item3;
    [self.itemGroup addObject:@[itemFrame2, itemFrame3]];
    
    // 第3组
    SCSettingItem *item4 = [[SCSettingItem alloc] itemWith:@"修改密码" exitLogin:nil icon:nil detailTitle:nil type:CellAccessoryDisclosureIndicator];
    SCSettingItemFrame *itemFrame4 = [[SCSettingItemFrame alloc] init];
    itemFrame4.settingItem = item4;
    [self.itemGroup addObject:@[itemFrame4]];
    
    // 第4组
    SCSettingItem *item5 = [[SCSettingItem alloc] itemWith:@"清理缓存" exitLogin:nil icon:nil detailTitle:[self caculateCaches] type:CellAccessoryDisclosureIndicator];
    item5.operation = ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"清理缓存" message:@"清理主要缓存可以加快手机运行速度" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    };
    SCSettingItemFrame *itemFrame5 = [[SCSettingItemFrame alloc] init];
    itemFrame5.settingItem = item5;
    [self.itemGroup addObject:@[itemFrame5]];

    // 第5组
    SCSettingItem *item6 = [[SCSettingItem alloc] itemWith:nil exitLogin:@"退出登陆" icon:nil detailTitle:nil type:CellAccessoryDisclosureNone];
    item6.operation = ^{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"退出后不可以对任何发布的产品进行赞同，评论，以及查看我赞同评论的产品" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登陆" otherButtonTitles: nil];
        actionSheet.tag = exitloginActionSheetTag;
        [actionSheet showInView:self.view];
    };
    SCSettingItemFrame *itemFrame6 = [[SCSettingItemFrame alloc] init];
    itemFrame6.settingItem = item6;
    [self.itemGroup addObject:@[itemFrame6]];
}

#pragma mark 退出登陆、调用相册|相机
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == exitloginActionSheetTag) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (actionSheet.tag == iconActionSheetTag){
        if (buttonIndex == 0) { // 相册
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
            UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
            imagePick.delegate = self;
            imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePick animated:YES completion:nil];
            
        } else if (buttonIndex == 1) { // 相机
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
            UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
            imagePick.delegate = self;
            imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePick animated:YES completion:nil];
            
        } else {
            SCLog(@"取消");
        }
    }
    
}

/**
 *  选择完图片后调用（拍完照或者从相册里取图片后调用）
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    SCLog(@"%@", info[UIImagePickerControllerReferenceURL]);
//    UIImage *image = [info valueForKeyPath:UIImagePickerControllerOriginalImage];
//    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
//    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"abc.jpg"];
//    [imageData writeToFile:path atomically:YES];
    
//    NSString *iconUrl = info[UIImagePickerControllerReferenceURL];
//    SCSettingItemFrame *itemF = self.itemGroup[0][0];
//    itemF.settingItem.icon = iconUrl;
//    self.iconUrl = path;
//    [self.tableView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark 清理缓存
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // 清除缓存（删除SDWebImage下载的图片）
        [[SDImageCache sharedImageCache] clearDisk];
        
        // 更新页面的缓存数据
        SCSettingItemFrame *itemF = self.itemGroup[3][0];
        itemF.settingItem.detailTitle = [self caculateCaches];
        [self.tableView reloadData];
    }
}
    
    

#pragma mark tableView数据源/代理Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemGroup.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.itemGroup[section]count];
}

// cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建cell
    SCSettingCell *cell = [SCSettingCell settingCellWithTableview:tableView];
    // 传模型数据给cell
    cell.itemFrame = self.itemGroup[indexPath.section][indexPath.row];
    cell.indexPath = indexPath;
    
    return cell;
}

// 选中cell
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

// cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCSettingItemFrame *itemFrame = self.itemGroup[indexPath.section][indexPath.row];
    return itemFrame.cellHeight;
    
}

@end