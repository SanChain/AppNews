//
//  SCMyAddressController.m
//  AppNews
//
//  Created by SanChain on 15/7/9.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCMyAddressController.h"
#import <MapKit/MapKit.h>
#import "UMSocial.h"
#import "Colours.h"

@interface SCMyAddressController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *mgr;
/** 反地理编码对象 */
@property (nonatomic, strong) CLGeocoder *geocoder;
/** 我的位置 */
@property (nonatomic, copy) NSString *myAddress;

@end

@implementation SCMyAddressController

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

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享位置" style:UIBarButtonItemStyleBordered target:self action:@selector(shareMyAddress)];
    
    self.mapView.delegate = self;
    self.mapView.rotateEnabled = NO;
    // 追踪位置
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    // ios8适配
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        [self.mgr requestAlwaysAuthorization];
    }
}

#pragma mark 分享我的位置
- (void)shareMyAddress
{
    // 友盟分享面板
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"559a30d567e58e51b6002916"
                                      shareText:[NSString stringWithFormat:@"我在：%@", self.myAddress]
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina, UMShareToTencent, UMShareToQzone, UMShareToSms, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToQQ, UMShareToWhatsapp, UMShareToDouban, nil]
                                       delegate:nil];

}

#pragma mark 位置更新就调用
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{ 
    
    // 反向地理编码获取中文地址信息
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        userLocation.title = placemark.locality;
        userLocation.subtitle = placemark.name;
        self.myAddress = placemark.name;
    }];
    
    // 设置检测区域
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.location.coordinate, span);
    [self.mapView setRegion:region animated:YES];
}

#pragma mark 大头针视图的数据源_设置默认的大头针样式
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *ID = @"anno";
    MKPinAnnotationView *annoView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
    }
    
    annoView.pinColor = MKPinAnnotationColorGreen; // 大头针颜色
    annoView.canShowCallout = YES; // 显示标题
    annoView.animatesDrop = YES; // 动画
    
    return annoView;
}


#pragma mark 懒加载
- (CLLocationManager *)mgr
{
    if (!_mgr) {
        _mgr = [[CLLocationManager alloc] init];
    }
    return _mgr;
}

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

@end
