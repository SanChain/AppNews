//
//  SCNewController.m
//  AppNews
//
//  Created by SanChain on 15/6/15.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCNewController.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "SCNewDemoItem.h"
#import "SCNewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "SCDbTool.h"
#import "SCHttpTool.h"

@interface SCNewController ()
/** demoItems模型数组 */
@property (nonatomic, strong) NSMutableArray *demoItems;
@end

// 上拉刷新时全局变量保存页码
static NSInteger page = 1;
static NSString *ID = @"cell";

@implementation SCNewController

- (NSMutableArray *)demoItems
{
    if (!_demoItems) {
        _demoItems = [NSMutableArray array];
    }
    return _demoItems;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 0. 注册xib
    UINib *nib = [UINib nibWithNibName:@"SCNewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:ID];
    
    // 1. 初始化2个BarButtomItem
    [self initTwoBarButtomItem];
    
    // 2. 自动刷新加载数据
    [self autoRefresh];
    
    // 3. 上拉加载旧数据
    [self upRefresh];
}

#pragma mark - 下拉刷新加载数据
- (void)autoRefresh
{
    // 刷新加载demo数据
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewDemo)];
    
    // 隐藏时间
    self.tableView.header.updatedTimeHidden = YES;
    
    // 马上刷新
    [self.tableView.header beginRefreshing];
    
}

// 下拉加载最新的demo数据
- (void)loadNewDemo
{
    // 查询缓存数据
    NSArray *demoArray = [SCDbTool queryNewDemoData];
    if (demoArray.count) {
        [self.demoItems removeAllObjects];
        page = 2;
        
        // 字典数组转demoItem模型数组
        NSMutableArray *oldDemoItems = [SCNewDemoItem objectArrayWithKeyValuesArray:demoArray];
        
        // 把新数据插入到数组最前面
        NSRange range = NSMakeRange(0, oldDemoItems.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.demoItems insertObjects:oldDemoItems atIndexes:set];

        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        NSLog(@"-----------读取缓存----------------");
    }

    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pagesize"] = @20;
    if (self.demoItems.count > 0) { // 设置允许上拉刷新一次
        [self.tableView.header endRefreshing];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://www.demo8.com/api/product?page=%zd&pagesize=20&sort=inputtime", page];
    
    [SCHttpTool GET:url params:params timeoutInterval:8 success:^(id responseObject) {
        page++;
        
        // 写入数据库
        [SCDbTool saveNewDemoData:responseObject[@"items"]];
        SCLog(@"-----------写入缓存----------------");
        
        // 字典数组转demoItem模型数组
        NSMutableArray *oldDemoItems = [SCNewDemoItem objectArrayWithKeyValuesArray:responseObject[@"items"]];
        
        // 把新数据插入到数组最前面
        NSRange range = NSMakeRange(0, oldDemoItems.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.demoItems insertObjects:oldDemoItems atIndexes:set];
        
        
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        SCLog(@"请求失败");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"加载失败" message:@"网络不给力，请检查网络设置或稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
}

#pragma mark - 上拉刷新加载旧数据
- (void)upRefresh
{
    // 刷新加载demo数据
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadOldDemo)];
    [self.tableView.footer setTitle:@"sanChain为你加载更多demo" forState:MJRefreshFooterStateIdle];
    [self.tableView.footer setTitle:@"sanChain拼命加载中" forState:MJRefreshFooterStateRefreshing];
    // 取消自动刷新
    self.tableView.footer.automaticallyRefresh = NO;
    
}

// 加载旧的demo数据
- (void)loadOldDemo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pagesize"] = @20;
    NSString *url = [NSString stringWithFormat:@"http://www.demo8.com/api/product?page=%zd&pagesize=20&sort=inputtime", page];
    
    [SCHttpTool GET:url params:params timeoutInterval:8 success:^(id responseObject) {
        page++;
        
        // 字典数组转demoItem模型数组
        NSMutableArray *oldDemoItems = [SCNewDemoItem objectArrayWithKeyValuesArray:responseObject[@"items"]];
        // 添加旧数据到demoItems数组的后面
        [self.demoItems addObjectsFromArray:oldDemoItems];
        
        SCLog(@"<--------上拉--------》%zd", self.demoItems.count);
        
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    } failure:^(NSError *error) {
        SCLog(@"请求失败");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"加载失败" message:@"网络不给力，请检查网络设置或稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.demoItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SCNewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 加载xib自定义的cell
        cell = [SCNewCell newsCell];
    }
    // 接口
    cell.demoItem = self.demoItems[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 动态计算cell的高度（用第三方库，一句代码搞定）
    return [tableView fd_heightForCellWithIdentifier:ID  cacheByIndexPath:indexPath configuration:^(id cell) {
        // 配置 cell 的数据源，和 "cellForRow" 干的事一致
        SCNewCell *newCell = cell;
        newCell.demoItem = self.demoItems[indexPath.row];
    }];
    
    
    /**********AutoLayout动态计算cell高度的使用步骤************/
    /* 
     1. 自定义一个uitableviewcell的子类SCNewCell并勾选xib（即新建类的同时也新建与之关联的xib)
     2. 在SCNewCell创建一个接口用来加载xib文件，初始化cell。+ (id)newsCell
     3. 在tableviewcontroller里，tableview要注册xib通过重用标识。这步很重要
     4. cellForRow方法中按平常来做， 记得要调用第2步的初始化方法来加载xib文件，就是使用自定义的cell
     5. 引入第三方库的头文件：#import "UITableView+FDTemplateLayoutCell.h"
     6. 在heightForRow这个代理方法中用一句代码动态计算cell的高度并返回。
     - (CGFloat)fd_heightForCellWithIdentifier:(NSString *)identifier cacheByIndexPath:(NSIndexPath *)indexPath configuration:(void (^)(id))configuration
     
     7. 在上面方法里面的block里要配置cell的数据源，和cellForRow的做法一样。
     
     */
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark - 初始化2个BarButtonItem
- (void)initTwoBarButtomItem
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
