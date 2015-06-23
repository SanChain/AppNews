//
//  SCEverydayController.m
//  SCDemo8
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


@interface SCEverydayController ()
/** 此刻日期 */
@property (nonatomic, copy) NSMutableString *stringM;
/** 装DemoFrame模型的数组 */
@property (nonatomic, strong) NSMutableArray *frameArrayM;

@end

/** 上拉刷新时全局变量保存页码 */
static NSInteger page = 1;

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
    // 去除cell的分隔线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 1. 初始化两个BarButtonItem
    [self initTwoBarButtonItem];
    
    // 2. 自动刷新加载数据
    [self autoRefresh];
    
    // 3. 上拉刷新加载旧数据
    [self upRefreshOldData];
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

// 下拉加载demo新数据
- (void)loadDemoNewData
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    if (self.frameArrayM.count > 0) { // 设置允许上拉刷新一次
        [self.tableView.header endRefreshing];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"http://www.demo8.com/api/product?date=%@&page=%zd", self.stringM, page];

    [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        page++;
        
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
    static NSString *ID = @"cell";
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
    
    // push详情控制器
    SCDetailViewController *detailVC = [[SCDetailViewController alloc] init];
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
