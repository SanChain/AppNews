//
//  SCSpecialController.m
//  AppNews
//
//  Created by SanChain on 15/6/15.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCSpecialController.h"
#import "SCSpecialCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "SCSpecialItem.h"
#import "SCWorkTool.h"
#import "AFNetworking.h"
#import "SCFlowLayout.h"
#import "Colours.h"
#import "UIView+Extension.h"
#import "SCDbTool.h"

@interface SCSpecialController ()
/** specialItem模型数组 */
@property (nonatomic, strong) NSMutableArray *items;
/** 创业工具箱 */
@property (nonatomic, weak) UIButton *topView;
@end


static NSInteger page = 1; // 记录页码
static CGFloat SCTopViewH = 150; // 创业工具箱宽
static CGFloat SCEdgeInset = 150; // 创业工具箱高
static NSInteger scrollCount = 1; // scrollView滚动的次数

@implementation SCSpecialController

- (NSMutableArray *)items
{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // 0. 添加创业工具箱的topView
    UIButton *topView = [[UIButton alloc] init];
    [topView setImage:[UIImage imageNamed:@"workTool"] forState:UIControlStateNormal];
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    topView.frame = CGRectMake(0, -SCTopViewH, w, SCTopViewH);
    [self.collectionView insertSubview:topView atIndex:0];
    [topView addTarget:self action:@selector(clickTopView) forControlEvents:UIControlEventTouchUpInside];
    self.topView = topView;
    self.collectionView.contentInset = UIEdgeInsetsMake(SCEdgeInset, 0, 0, 0);
    
    // 1. 设置collectionView属性
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    // 2. Register cell classes
    UINib *nib = [UINib nibWithNibName:@"SCSpecialCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.collectionViewLayout = [[SCFlowLayout alloc] init];
    
    // 3. 初始化2个BarButtomItem
    [self initTwoBarButtomItem];
    
    // 4. 下拉加载最新数据
    [self autoRefresh];
    
    // 5. 上拉加载旧数据
    [self upRefresh];

}

#pragma mark 自动刷新\下拉刷新
- (void)autoRefresh
{
    [self.collectionView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewItemData)];
    self.collectionView.header.updatedTimeHidden = YES;
    [self.collectionView.header beginRefreshing];
    
}
// 加载最新的item数据
- (void)loadNewItemData
{
    // 读取缓存数据
    NSArray *array = [SCDbTool querySpecialDemoData];
    if (array.count) {
        [self.items removeAllObjects];
        page = 2;
        
        // 字典数组 转 模型数组
        NSMutableArray *newItems = [NSMutableArray array];
        newItems = [SCSpecialItem objectArrayWithKeyValuesArray:array];
        // 把最新加载的数据添加到总数组最前面（因为不知道请求参数，所以无法筛选到最新的数据）
        NSRange range = NSMakeRange(0, newItems.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.items insertObjects:newItems atIndexes:set];
        
        NSLog(@"------读取缓存--------");
        
        // 刷新cell
        [self.collectionView reloadData];
        // 关闭刷新菊花
        [self.collectionView.header endRefreshing];
        // 隐藏刷新头部
        self.collectionView.header.hidden = YES;
        
        return;
    }
    
    // http请求————item
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSString *url = [NSString stringWithFormat:@"http://www.demo8.com/api/topic?page=1"];
    [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        page++;
        
        // 写入数据库
        [SCDbTool saveSpecialDemoData:responseObject];
        
        // 字典数组 转 模型数组
        NSMutableArray *newItems = [NSMutableArray array];
        newItems = [SCSpecialItem objectArrayWithKeyValuesArray:responseObject];
        // 把最新加载的数据添加到总数组最前面（因为不知道请求参数，所以无法筛选到最新的数据）
        NSRange range = NSMakeRange(0, newItems.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.items insertObjects:newItems atIndexes:set];
        
        NSLog(@"------>>下拉----%zd", self.items.count);

        // 刷新cell
        [self.collectionView reloadData];
        // 关闭刷新菊花
        [self.collectionView.header endRefreshing];
        // 隐藏刷新头部
        self.collectionView.header.hidden = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
        [self.collectionView.header endRefreshing];
    }];
    
}

#pragma mark 上拉刷新
- (void)upRefresh
{
    [self.collectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadOldItemData)];
    [self.collectionView.footer setTitle:@"sanChain为你加载更多demo" forState:MJRefreshFooterStateIdle];
    [self.collectionView.footer setTitle:@"sanChain拼命加载中" forState:MJRefreshFooterStateRefreshing];
    [self.collectionView.footer setTintColor:[UIColor goldenrodColor]];
    self.collectionView.footer.automaticallyRefresh = NO;
}
// 加载旧item数据
- (void)loadOldItemData
{
    // http请求————item
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSString *url = [NSString stringWithFormat:@"http://www.demo8.com/api/topic?page=%zd", page];
    [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        page++;
        
        // 字典数组 转 模型数组
        NSMutableArray *oldItems = [NSMutableArray array];
        oldItems = [SCSpecialItem objectArrayWithKeyValuesArray:responseObject];
        // 把旧item数据添加到总数组后面
        [self.items addObjectsFromArray:oldItems];
        
//        NSLog(@"------>>上拉----%zd", self.items.count);
        
        // 刷新cell
        [self.collectionView reloadData];
        // 关闭刷新菊花
        [self.collectionView.footer endRefreshing];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
        [self.collectionView.footer endRefreshing];
    }];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SCSpecialCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SCSpecialCell" owner:nil options:nil][0];
    }
    // Configure the cell
    cell.specialItem = self.items[indexPath.row];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectItemAtIndexPath");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double distance = -SCEdgeInset - scrollView.contentOffset.y;
    NSLog(@"------scrollview--->%lf", distance);
    if (scrollCount < 5) {
        scrollCount++;
        return;
        
    } else {
        // 最重要的设置在这
        if (distance > 64) {
            self.topView.imageView.contentMode = UIViewContentModeScaleAspectFill; // 等比例伸缩，居中显示
            self.topView.height = SCTopViewH + distance - 64;
            self.topView.y = scrollView.contentOffset.y + 64; // 很重要这一句，64是导航条的高度
        }
    }
    
    
}

#pragma mark - 监听topView点击
- (void)clickTopView
{
    NSLog(@"clickTopView");
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
