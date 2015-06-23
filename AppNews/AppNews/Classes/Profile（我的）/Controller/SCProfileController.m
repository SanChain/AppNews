//
//  SCProfileController.m
//  AppNews
//
//  Created by SanChain on 15/6/15.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCProfileController.h"
#import "UIBarButtonItem+Extension.h"
#import "SCTableViewCell.h"
#import "SCIntroductionView.h"
#import "SCOptionMenuView.h"
#import "UIView+Extension.h"
#import "SCConst.h"
#import "Colours.h"
#import "SCProfileLikes.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MBProgressHUD+MJ.h"

@interface SCProfileController ()
/** 选项菜单 */
@property (nonatomic, weak) SCOptionMenuView *optionMenu;
/** 点赞产品的模型数组 */
@property (nonatomic, strong) NSMutableArray *likesDemos;

@end

static NSString * const ID = @"cell";
// 上拉刷新时全局变量保存页码
static NSInteger page = 1;

@implementation SCProfileController

- (NSMutableArray *)likesDemos
{
    if (!_likesDemos) {
        _likesDemos = [NSMutableArray array];
    }
    return _likesDemos;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initTwoBarButtomItem];

    // 注册自定义cell
    UINib *nib = [UINib nibWithNibName:@"SCTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:ID];
    
    [self setupNavBar];
    
    [self insertTwoViewToTableView];
    
    [self setupLikes];
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentClick) name:@"commentBtn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LikesClick) name:@"LikesBtn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PublishClick) name:@"PublishBtn" object:nil];
    
}

#pragma mark 监听产品栏的通知
- (void)commentClick
{
    NSLog(@"commentClickNotification");
    [self setupLikes];
}
- (void)LikesClick
{
    NSLog(@"LikesClickNotification");
    [self setupLikes];
}
- (void)PublishClick
{
    NSLog(@"PublishClickNotification");
    [self setupLikes];
}
- (void)dealloc
{
    NSLog(@"delloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 加载点赞产品
- (void)setupLikes
{
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(loadLikesData:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
    [refresh beginRefreshing];
    [self loadLikesData:refresh];
    
}
- (void)loadLikesData:(UIRefreshControl *)refresh
{
    [MBProgressHUD showMessage:@"加载中..."];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pagesize"] = @10;
    
    if (self.likesDemos.count > 0) {
        [self.likesDemos removeAllObjects];
        page = 1;
    }
#warning todo 读取离线缓存_待做
    NSString *url = [NSString stringWithFormat:@"http://www.demo8.com/api/product?page=%zd&pagesize=10&sort=inputtime", page];
    
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        page++;
        
        // 字典数组转demoItem模型数组
        NSMutableArray *oldDemoItems = [NSMutableArray array];
        oldDemoItems = [SCProfileLikes objectArrayWithKeyValuesArray:responseObject[@"items"]];
        
        // 把新数据插入到数组最前面
        NSRange range = NSMakeRange(0, oldDemoItems.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.likesDemos insertObjects:oldDemoItems atIndexes:set];
#warning todo 写入离线缓存_待做
        
        [self.tableView reloadData];
        [refresh endRefreshing];
        [MBProgressHUD hideHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
        [refresh endRefreshing];
        [MBProgressHUD hideHUD];
    }];
}

#pragma mark - 导航条属性的设置
- (void)setupNavBar
{
    self.tableView.backgroundColor = [UIColor creamColor];
    self.navigationItem.title = @"  ";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationController.navigationBar.barTintColor = [UIColor wheatColor];
}

#pragma mark 添加两个UIView到tableView的顶部
- (void)insertTwoViewToTableView
{
    SCIntroductionView *introView = [SCIntroductionView loadIntroductionView];
    introView.frame = CGRectMake(0, -(SCIntroViewH + SCOptionH), SCSreenW, SCIntroViewH);
    [self.tableView insertSubview:introView atIndex:0];
    
    SCOptionMenuView *optionMenu = [SCOptionMenuView loadOptionMenuView];
    optionMenu.frame = CGRectMake(0, -SCOptionH, SCSreenW, SCOptionH);
    [self.tableView insertSubview:optionMenu atIndex:1];
    optionMenu.userInteractionEnabled = YES;
    self.optionMenu = optionMenu;
    // tableView的内边距设置
    self.tableView.contentInset = UIEdgeInsetsMake((SCOptionH + SCIntroViewH), 0, 0, 0);
}

#pragma mark - dataSourceMethod
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.likesDemos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [SCTableViewCell newCell];
    }
    cell.profileLikes = self.likesDemos[indexPath.row];
    
    return cell;
}
// 返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:ID cacheByIndexPath:indexPath configuration:^(id cell) {
        SCTableViewCell *tableViewCell = cell;
        tableViewCell.profileLikes = self.likesDemos[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark 设置选项栏卡在导航条下面
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
#warning 有bug,当点击其它tabBarItem时选项栏还会卡在导航条
    NSLog(@"-------->> %f", -scrollView.contentOffset.y);
    double deltaDistance = -scrollView.contentOffset.y;
    if (deltaDistance <= (SCNaviBar + SCOptionH)) { // 卡住
        self.optionMenu.userInteractionEnabled = YES;
        self.optionMenu.frame = CGRectMake(0, SCNaviBar, SCSreenW, SCOptionH);
        UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
        [window addSubview:self.optionMenu];
        self.navigationItem.title = @"SanChain";
        
    } else { // 不卡住
        self.optionMenu.hidden = NO;
        self.optionMenu.userInteractionEnabled = YES;
        self.optionMenu.frame = CGRectMake(0, -SCOptionH, SCSreenW, SCOptionH);
        [self.tableView insertSubview:self.optionMenu atIndex:1];
        self.navigationItem.title = @" ";
    }
}

#pragma mark - 初始化2个BarButtonItem
- (void)initTwoBarButtomItem
{
    // leftBarButtonItem
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickSettingItem) image:@"navigationbar_setting" highImage:@"navigationbar_setting_highlighted"];
    
    // rightBarButtonItem
    UIImage *rightImage = [[UIImage imageNamed:@"tabbar_compose_background_icon_add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStyleDone target:self action:@selector(clickAddItem)];
}

#pragma mark - 监听leftBarButtonI tem
- (void)clickSettingItem
{
#warning TODO 个人设置
    NSLog(@"%s", __func__);
}

#pragma mark - 监听rightBarButtonItem
- (void)clickAddItem
{
#warning TODO 二维码、百度地图
    NSLog(@"%s", __func__);
}

@end
