//
//  SCDetailViewController.m
//  AppNews
//
//  Created by SanChain on 15/6/22.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCDetailViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "SCConst.h"
#import "Colours.h"
#import "MJExtension.h"
#import "SCDetailDemo.h"
#import "SCDetailDemoAuthor.h"
#import "SCDetailLikesData.h"
#import "SCDetailCommentsData.h"
#import "MBProgressHUD+MJ.h"
#import "SCDetailFirstCell.h"
#import "SCSecondCell.h"
#import "SCThirdCell.h"
#import "SCFourthCell.h"
#import "SCHttpTool.h"
#import "UMSocial.h"



@interface SCDetailViewController ()<UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate>

/** dem模型（包括下面三个嵌套模型）*/
@property (nonatomic, strong) SCDetailDemo *detailDemo;
/** demo作者模型 */
@property (nonatomic, strong) SCDetailDemoAuthor *demoAuthor;
/** 点赞者模型数组 */
@property (nonatomic, strong) NSMutableArray *likesModelArrayM;
/** 评论者模型数组 */
@property (nonatomic, strong) NSMutableArray *commentsModelArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) SCThirdCell *thirdCell;
@end

static NSString *ID = @"cell";

@implementation SCDetailViewController
- (NSMutableArray *)likesModelArrayM
{
    if (!_likesModelArrayM) {
        _likesModelArrayM = [NSMutableArray array];
    }
    return _likesModelArrayM;
}
- (NSMutableArray *)commentsModelArray
{
    if (!_commentsModelArray) {
        _commentsModelArray = [NSMutableArray array];
    }
    return _commentsModelArray;
}

// 显示\隐藏tabBar
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.frame = self.view.bounds;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _tableView;
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.frame = self.view.bounds;
        _webView.scrollView.contentInset = UIEdgeInsetsMake(SCNaviBar, 0, -SCNavigationBarH, 0);
        [_webView setScalesPageToFit:YES];
        _webView.delegate = self;
        _webView.userInteractionEnabled = YES;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    // 导航条设置
    [self setupNavigationBarAttribute];

    // 设置titleView
    [self setupTitleView];
    
    // 加载详情 网络数据
    [self loadDetailData];
    
    // 自动加载详情页面
    [self clickDetailBtn];
    
}

- (void)dealloc
{
    SCLog(@"------detailVC");
}

#pragma mark 加载详情 网络数据
- (void)loadDetailData
{
    [MBProgressHUD showMessage:@"加载中..."];

    NSString *url = [NSString stringWithFormat:@"http://www.demo8.com/api/product/%zd", self.demoID.integerValue];
    [SCHttpTool GET:url params:nil timeoutInterval:8 success:^(id responseObject) {
        // 字典 转 demo模型
        SCDetailDemo *detailDemo = [SCDetailDemo objectWithKeyValues:responseObject];
        self.detailDemo = detailDemo;
        
        // demo作者模型
        SCDetailDemoAuthor *demoAuthor = [SCDetailDemoAuthor objectWithKeyValues:detailDemo.author];
        self.demoAuthor = demoAuthor;
        
        // 装入点赞者模型数组
        for (SCDetailLikesData *likesData in detailDemo.likesData) {
            [self.likesModelArrayM addObject:likesData];
        }
        //        NSLog(@"-----likesModelArrayM:%zd", self.likesModelArrayM.count);
        
        // 装入评论者数组模型
        for (SCDetailCommentsData *commentsData in detailDemo.commentsData) {
            [self.commentsModelArray addObject:commentsData];
        }
        
        [MBProgressHUD hideHUD];
        //        NSLog(@"-----commentsModelArray:%zd", self.commentsModelArray.count);
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"加载失败" message:@"网络不给力，请检查网络设置或稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [MBProgressHUD hideHUD];
    }];
}

#pragma mark 监听titleView点击
- (void)clickSegmentedControll:(UISegmentedControl *)seg
{
    NSInteger indext = seg.selectedSegmentIndex;
    switch (indext) {
        case 0:
            [self clickDetailBtn]; // 详情
            break;
         case 1:
            [self clickWebBtn]; // 网站
            break;
        default:
            break;
    }
}

#pragma mark 详情页面
- (void)clickDetailBtn
{
    [self.tableView removeFromSuperview]; // 内存优化
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.likesModelArrayM.count) {
        return 3 ;
    } else {
        return 2 ;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.row) {
        case SCDetailFirstCellNumber:
        {
            // 第一行cell
            SCDetailFirstCell *firstCell = [SCDetailFirstCell loadNewCellWithTableView:tableView];
            firstCell.demoAuthor = self.demoAuthor;
            cell = (UITableViewCell *)firstCell;
            break;
        }
 
        case SCDetailSecondCellNumber:
        {
            // 第二行cell
            SCSecondCell *secondCell = [SCSecondCell loadNewCellWithTableView:tableView];
            secondCell.detailDemo = self.detailDemo;
            cell = (UITableViewCell *)secondCell;
            break;
        }
            
//        case SCDetailThirdCellNumber:
//        {
//            // 第三行cell
//            SCThirdCell *thirdCell = [SCThirdCell loadNewCellWithTableView:tableView];
//            [thirdCell setupCellWithArray:self.likesModelArrayM];
//            cell = (UITableViewCell *)thirdCell;
//            break;
//        }
    
        default:
        {
            // 第三行cell
            SCThirdCell *thirdCell = [SCThirdCell loadNewCellWithTableView:tableView];
            [thirdCell setupCellWithArray:self.likesModelArrayM];
            cell = (UITableViewCell *)thirdCell;
            break;
        }
    }
  
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case SCDetailFirstCellNumber:
            return 60;
            break;
  
        case SCDetailSecondCellNumber:
            
            return 100;
            break;
            
            
//        case SCDetailThirdCellNumber:
//            return 100;
//            break;
            
        default:
            return 120;
            break;
            
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark 加载demo网页
- (void)clickWebBtn
{
    [MBProgressHUD showMessage:@"加载中..."];
    [self.webView removeFromSuperview]; // 内存优化
    
    // 设置网络请求超时时间
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.detailDemo.website] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0];
    
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.scrollView.contentInset = UIEdgeInsetsMake(SCNaviBar, 0, 0, 0);
    
    [MBProgressHUD hideHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"加载失败" message:@"网络不给力，请检查网络设置或稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    [MBProgressHUD hideHUD];
}


#pragma mark 集成分享
- (void)share
{
    NSLog(@"share-----%@", self.demoID);
    // 友盟分享面板
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"559a30d567e58e51b6002916"
                                      shareText:nil
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina, UMShareToTencent, UMShareToQzone, UMShareToSms, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToQQ, UMShareToWhatsapp, UMShareToDouban, nil]
                                       delegate:nil];
    // 分享demoWebsite(demo的网页)
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:self.detailDemo.website];
    
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.detailDemo.website;
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.detailDemo.website;

}

#pragma mark 导航条属性设置
- (void)setupNavigationBarAttribute
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor: [UIColor emeraldColor]];
}

#pragma mark 添加navigationBar的titleView
- (void)setupTitleView
{
    NSArray *array = [[NSArray alloc] initWithObjects:@"详情", @"网站", nil];
    UISegmentedControl *segC = [[UISegmentedControl alloc] initWithItems:array];
    segC.selectedSegmentIndex = 0;
    [segC addTarget:self action:@selector(clickSegmentedControll:) forControlEvents:UIControlEventValueChanged];
    segC.width = SCScreenWith * 0.6;
    segC.height = SCNavigationBarH * 0.65;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, [UIColor emeraldColor], NSForegroundColorAttributeName, nil, nil];
    [segC setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    [segC setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil, nil] forState:UIControlStateHighlighted];
    
    self.navigationItem.titleView = segC;
}

@end
