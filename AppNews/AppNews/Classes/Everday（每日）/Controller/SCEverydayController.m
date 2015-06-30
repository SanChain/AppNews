//
//  SCEverydayController.m
//  AppNews
//
//  Created by SanChain on 15/6/15.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCEverydayController.h"
#import "UIBarButtonItem+Extension.h"
#import "SCEverydayCell.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "SCEverydayDemo.h"
#import "SCEverydayDemoItem.h"
#import "SCEverydayDemoFrame.h"
#import "SCDetailViewController.h"
#import "SCDbTool.h"
#import "SCNetworkTool.h"
#import "UIView+Extension.h"
#import "SCCheckNetworkController.h"

@interface SCEverydayController () <UIAlertViewDelegate>
/** 此刻日期 */
@property (nonatomic, copy) NSMutableString *stringM;
/** 装DemoFrame模型的数组 */
@property (nonatomic, strong) NSMutableArray *frameArrayM;
/** 网络连接状态对象 */
@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, weak) UIView *hudView;
@end

/** 上拉刷新时全局变量保存页码 */
static NSInteger page = 1;
static NSString *ID = @"cell";

typedef enum {
    firstAlertViewTag ,
    secondAlertViewTag
} alertViewTag;

@implementation SCEverydayController

#pragma mark - 各种对象懒加载
// 此刻日期
- (NSMutableString *)stringM
{
    if (!_stringM) {
        _stringM = [NSMutableString string];
        NSDate *now = [NSDate date];
        NSDateFormatter *fortmatter = [[NSDateFormatter alloc] init];
        fortmatter.dateFormat = @"yyy-MM-dd";
        _stringM = (NSMutableString *)[fortmatter stringFromDate:now];
    }
    return _stringM;
}

// DemoFrame模型数组
- (NSMutableArray *)frameArrayM
{
    if (!_frameArrayM) {
        self.frameArrayM = [NSMutableArray array];
    }
    return _frameArrayM;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    // 强制检测网络状态
    [self checkNetworkState];
    
    // 去除cell的分隔线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 1. 初始化两个BarButtonItem
    [self initTwoBarButtonItem];
    
    // 2. 自动刷新加载数据
//    [self autoRefresh];
    
    // 3. 上拉刷新加载旧数据
    [self upRefreshOldData];
}

#pragma mark 自动检测网络状态
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkState) name:kReachabilityChangedNotification object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
}

// 通知中心的网络状态监听
- (void)checkNetworkState
{
    if ([SCNetworkTool isEnableWIFI]) {
        NSLog(@"wifi网络");
        // 自动刷新加载数据
        [self autoRefresh];
        
    } else if ([SCNetworkTool isEnable3G]) {
        NSLog(@"蜂窝网络");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"打开无线局域网可以提高浏览速度，节省流量哦" delegate:self cancelButtonTitle:@"继续使用" otherButtonTitles: @"查看WiFi设置" ,nil];
        alertView.tag = firstAlertViewTag;
        [alertView show];
        
        [self loadOfflineCachesData];
        
    } else {
        NSLog(@"没有网络");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前没有网络，为了不影响您的使用，请检查您的网络设置" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        alertView.tag = secondAlertViewTag;
        [alertView show];
        [self loadOfflineCachesData];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == firstAlertViewTag) { // 3G网络
        if (buttonIndex == 0) { // 继续使用
            NSLog(@"继续使用");
            [self autoRefresh];
        } else if (buttonIndex == 1) { // 第1个按钮：查看WiFi设置
            // 不能跳转到手机的设置界面，用说明的形式向用户展示如何设置wifi
            NSLog(@"查看WiFi设置");
            [self autoRefresh];
            SCCheckNetworkController *checkVc = [[SCCheckNetworkController alloc] init];
            [self.navigationController pushViewController:checkVc animated:YES];
        }
        
    } else if (alertView.tag == secondAlertViewTag){ // 没有网络
        if (buttonIndex == 0) {
            SCCheckNetworkController *checkVc = [[SCCheckNetworkController alloc] init];
            [self.navigationController pushViewController:checkVc animated:YES];
            
        }
    }
    
}

// 释放通知中心的观察者
- (void)dealloc
{
    [self.reachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 自动刷新加载数据
- (void)autoRefresh
{
    // 下拉刷新
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadDemoNewData)];
    
    // 隐藏时间
    self.tableView.header.updatedTimeHidden = YES;
    
    // 马上刷新
    [self.tableView.header beginRefreshing];

}

// 加载离线缓存数据
- (BOOL)loadOfflineCachesData
{
    NSArray *demoArray = [SCDbTool queryDemoData];
    if (demoArray.count > 0) {
        page++;
        [self.frameArrayM removeAllObjects];
        
        // 字典转模型
        NSArray *DemoItemArray = [SCEverydayDemoItem objectArrayWithKeyValuesArray:demoArray];
        
        // DemoFrame模型数组
        for (SCEverydayDemoItem *demoItem in DemoItemArray) {
            SCEverydayDemoFrame *demoF = [[SCEverydayDemoFrame alloc] init];
            demoF.demoItem = demoItem;
            [self.frameArrayM addObject:demoF];
        }
        //        NSLog(@"------读取缓存数据---------");
        
        // 更新表格
        [self.tableView reloadData];
        // 关闭刷新圈圈
        [self.tableView.header endRefreshing];
//        self.tableView.header.hidden = YES;
        return YES;
    } else {
        return NO;
    }
}

// 下拉加载demo新数据
- (void)loadDemoNewData
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];

    // 加载离线缓存的数据
    BOOL isLoadSuccess = [self loadOfflineCachesData];
    if (isLoadSuccess) { // 成功加载了缓存数据
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"http://www.demo8.com/api/product?date=%@&page=%zd", self.stringM, page];

    [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        page++;
//        NSLog(@"------写入数据库---------");
        
        // 把数组写入SQLite数据库
        [SCDbTool saveDemoData:responseObject[@"items"]];
        
        // 字典转模型
        SCEverydayDemo *everydayDemo = [SCEverydayDemo objectWithKeyValues:responseObject];
        
        // DemoFrame模型数组
        NSMutableArray *newFrameArrayM = [NSMutableArray array];
        for (SCEverydayDemoItem *demoItem in everydayDemo.items) {
            SCEverydayDemoFrame *demoF = [[SCEverydayDemoFrame alloc] init];
            demoF.demoItem = demoItem;
            [newFrameArrayM addObject:demoF];
        }
        
        // 把新的数据添加到总数组的前面
        NSRange range = NSMakeRange(0, newFrameArrayM.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.frameArrayM insertObjects: newFrameArrayM atIndexes:set];

//        NSLog(@"<<----下拉刷新------->>%zd", self.frameArrayM.count);
        
        
        // 更新表格
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.header endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
        [self.tableView.header endRefreshing];
    }];
}

#pragma mark - 上拉刷新加载旧数据
- (void)upRefreshOldData
{
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadDemoOldData)];
    [self.tableView.footer setTitle:@"sanChain为你加载更多demo" forState:MJRefreshFooterStateIdle];
    [self.tableView.footer setTitle:@"sanChain拼命加载中" forState:MJRefreshFooterStateRefreshing];
    self.tableView.footer.automaticallyRefresh = NO;
}

// 上拉加载demo数据
- (void)loadDemoOldData
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSString *url = [NSString stringWithFormat:@"http://www.demo8.com/api/product?date=%@&page=%zd", self.stringM, page];
    
    [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
        NSInteger pages = [responseObject[@"pages"] integerValue];
        
        // 解决了上拉刷新数据加载的算法
        if (page < pages) {
            ++page;
            
        } else { // 算法、逻辑
            // 新的一天，重置页码
            page = 1;

            // 日期递减1天算法步骤
            
            // 先将日期转为秒NSTimeInterval
            NSDateFormatter *fort = [[NSDateFormatter alloc] init];
            fort.dateFormat = @"yyy-MM-dd";
            NSDate *currentDate = [fort dateFromString:self.stringM];
            NSTimeInterval currentTime = [currentDate timeIntervalSince1970];
            
            // 减去3600秒
            NSTimeInterval nextTime = currentTime - 3600;
            
            // 然后将秒转为日期NSDate
            NSDate *nextDate = [NSDate dateWithTimeIntervalSince1970:nextTime];
            NSLog(@"nextDate--%@", nextDate);
            // 再将日期转为日期字符串NSString
            NSString *nextDateString = [fort stringFromDate:nextDate];
            NSLog(@"nextDateString--%@", nextDateString);
            
            // 用全局变量记录递减后的日期stringM
            self.stringM = (NSMutableString *)nextDateString;
        }
        
        // 字典转demo模型
        SCEverydayDemo *everydayDemo = [SCEverydayDemo objectWithKeyValues:responseObject];
        // demoItem数组模型 转 demoFrame数组模型
        NSMutableArray *oldDemoArray = [NSMutableArray array];
        for (SCEverydayDemoItem *demoItem in everydayDemo.items) {
            SCEverydayDemoFrame *demoFrame = [[SCEverydayDemoFrame alloc] init];
            demoFrame.demoItem = demoItem;
            [oldDemoArray addObject:demoFrame];
        }
        
        [self.frameArrayM addObjectsFromArray:oldDemoArray];
        
//        NSLog(@"<-----上拉刷新-------%zd", self.frameArrayM.count);
        
        // 更新表格
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.frameArrayM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCEverydayCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SCEverydayCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.demoFrame = self.frameArrayM[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCEverydayDemoFrame *demoFrame = self.frameArrayM[indexPath.row];
    return demoFrame.cellHeight;
}


#pragma mark - push详情控制器
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    // 取出当前cell显示的demo id
    NSNumber *ID = [self.frameArrayM[indexPath.row] demoItem].ID;

    // push详情控制器
    SCDetailViewController *detailVC = [[SCDetailViewController alloc] init];
    detailVC.demoID = ID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 初始化2个BarButtonItem
- (void)initTwoBarButtonItem
{
    // leftBarButtonItem
    UIImage *leftImage = [[UIImage imageNamed:@"navigationbar_search_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStyleDone target:self action:@selector(clickSearchItem)];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    // rightBarButtonItem
    UIImage *rightImage = [[UIImage imageNamed:@"tabbar_compose_background_icon_add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStyleDone target:self action:@selector(clickAddItem)];
}

#pragma mark - 监听leftBarButtonItem
- (void)clickSearchItem
{
#warning TODO 搜索VC
    NSLog(@"%s", __func__);
    
}

#pragma mark - 监听rightBarButtonItem
- (void)clickAddItem
{
#warning TODO 发布DEMO
    NSLog(@"%s", __func__);
}



@end
