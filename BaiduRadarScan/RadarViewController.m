//
//  RadarViewController.m
//  促利汇_门户
//
//  Created by zhanglei on 15/10/19.
//  Copyright © 2015年 lei.zhang. All rights reserved.
//


#import "RadarViewController.h"
#import <BaiduMapAPI/BMKRadarManager.h>
#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI/BMKLocationService.h>
#import <BaiduMapAPI/BMKSearchComponent.h>
#import "RadarView.h"
#import <BaiduMapAPI/BMKRadarOption.h>
#import <BaiduMapAPI/BMKGeometry.h>
#import "RadarContentView.h"
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
@interface RadarViewController ()
{
    BMKRadarManager *_radarManager;
    BMKGeoCodeSearch* _geocodesearch;
    BMKLocationService * _locService;
    BMKMapView * _mapView;
    UIView * bottomView;
    float lat;
    float lng;
    
    RadarView * radarView;
    RadarContentView * radarCView;
    
    NSMutableArray * anoArr;
    BOOL mapMove;
    UIButton * btnReLocate;
    
    CLLocationCoordinate2D coordinate;
    
    UIView * bottomBgView;
    
    UILabel * lblRadius;
    UIButton * btnRadiusIntro;
    UILabel * lblRadiusTip;
    UIButton * btnAddRadius;
    CLLocationDistance distance;
    
    int radius;
    
    float circleWidth;
    
    UIButton * btnSend;
    
    UIView * coverBg;
    UIButton * btnCover;
    UITableView * localMemberTableView;
    UIButton * btnSendAll;
    
    NSMutableArray * localMemberArr;
    
    NSString * intro;
    CLLocationCoordinate2D coor;
    
    NSString * memberNumber;
    NSMutableArray * locationArray;
    NSString * canPushTimes;
}
@end

@implementation RadarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mapMove = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // Do any additional setup after loading the view.
    distance = 0;
    circleWidth = 0;
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 60, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-60)];
    _mapView.delegate = self;
    _mapView.showMapScaleBar = NO;
    _mapView.maxZoomLevel = 20;
    _mapView.zoomEnabledWithTap = YES;
    _mapView.alpha = .75;
    [self.view addSubview:_mapView];
    [self initUI];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_locService startUserLocationService];
}

-(void)initUI{
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _locService = [[BMKLocationService alloc]init];
    _geocodesearch.delegate = self;
    _locService.delegate = self;
    
    //注册雷达信息
    _radarManager = [BMKRadarManager getRadarManagerInstance];
    [_radarManager addRadarManagerDelegate:self];
    
    float circleWidth = 280;
    _mapView.zoomLevel = 16.68;
    
    _mapView.minZoomLevel = _mapView.zoomLevel;
    
    float bottomOffy = 20;
    
    if (radarView) {
        [radarView removeFromSuperview];
    }
    
    //添加雷达动画
    radarView = [[RadarView alloc] initWithFrame:CGRectMake(0, 60, circleWidth, circleWidth)];
    radarView.center = CGPointMake(_mapView.center.x, _mapView.center.y-bottomOffy/2);
    [radarView setBgView];
    [radarView setRadarLine];
    [self.view insertSubview:radarView aboveSubview:_mapView];
    
    float w = 30;
    if (btnReLocate) {
        [btnReLocate removeFromSuperview];
    }
    
    btnReLocate = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, w, w)];
    [btnReLocate setBackgroundImage:[UIImage imageNamed:@"radar_icon"] forState:UIControlStateNormal];
    [self.view addSubview:btnReLocate];
    
    [btnReLocate addTarget:self action:@selector(reSearchByFilter:) forControlEvents:UIControlEventTouchUpInside];
    btnReLocate.center = radarView.center;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [BMKRadarManager releaseRadarManagerInstance];
    [_radarManager removeRadarManagerDelegate:self];
    _geocodesearch.delegate = nil;
    _locService.delegate = nil;
}

#pragma mark BaiduMapDelegate

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"startLocating");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_locService stopUserLocationService];
    _mapView.centerCoordinate = userLocation.location.coordinate;
    coordinate = userLocation.location.coordinate;
    
    //定位后位置信息上传
    lat =userLocation.location.coordinate.latitude;
    lng = userLocation.location.coordinate.longitude;
    BMKRadarUploadInfo *myinfo = [[BMKRadarUploadInfo alloc] init];

    myinfo.extInfo = @"IOSTest";//扩展信息
    myinfo.pt = CLLocationCoordinate2DMake(lat, lng);//我的地理坐标
    //上传我的位置信息
    BOOL res = [_radarManager uploadInfoRequest:myinfo];
    if (res) {
        NSLog(@"upload 成功");
        //周边检索
        BMKRadarNearbySearchOption *option = [[BMKRadarNearbySearchOption alloc] init]
        ;
        option.radius = 8000;//检索半径
        option.sortType = BMK_RADAR_SORT_TYPE_DISTANCE_FROM_NEAR_TO_FAR;//排序方式
        option.centerPt = CLLocationCoordinate2DMake(lat, lng);//检索中心点
        //发起检索
        BOOL result = [_radarManager getRadarNearbySearchRequest:option];
        if (result) {
            NSLog(@"get 成功");
        } else {
            NSLog(@"get 失败");
        }
    } else {
        NSLog(@"upload 失败");
    }
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stopLocating");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"failedError:%@",error);
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
}

#pragma mark -- 雷达周边检索回调
- (void)onGetRadarNearbySearchResult:(BMKRadarNearbyResult *)result error:(BMKRadarErrorCode)error {
    NSLog(@"onGetRadarNearbySearchResult  %d", error);
    if (error == BMK_RADAR_NO_ERROR) {
        
        [radarView stopRunAnimation];
    }else if(error == BMK_RADAR_NO_RESULT){
        
        [radarView stopRunAnimation];
    }
}

-(void)setMapAnnotation{
    [_mapView removeAnnotations:anoArr];
    for (NSDictionary * info in locationArray) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        NSString * latString = [info objectForKey:@"portalLatitude"];
        NSString * lngString = [info objectForKey:@"portalLongitude"];
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){ [latString doubleValue],[lngString doubleValue]};
        item.coordinate = pt;
        [_mapView addAnnotation:item];
        [anoArr addObject:item];
        
    }
    [radarView performSelector:@selector(stopRunAnimation) withObject:nil afterDelay:2];
    [btnSend setEnabled:YES];
}

//原理类似 UITableView 循环委托加载 CellforRowWithIndexPath
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"annotationViewID";
    
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    float w = 0;
    float h = 0;
    
    w = 48;
    h = 64;
    
    UIView *viewForImage=[[UIView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
    [imageview setImage:[UIImage imageNamed:@"red_position"]];
    [viewForImage addSubview:imageview];
    
    annotationView.image=[self getImageFromView:viewForImage];
    annotationView.annotation = annotation;//绑定对应的标点经纬度
    return annotationView;
}

-(UIImage *)getImageFromView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    //用于测试半径距离
    //    CLLocationCoordinate2D cl = [_mapView convertPoint:CGPointMake((UI_SCREEN_WIDTH-circleWidth)/2, radarView.center.y-60) toCoordinateFromView:_mapView];
    //    CLLocationCoordinate2D center = mapView.centerCoordinate;
    //    CLLocationDistance dis;
    //    dis = BMKMetersBetweenMapPoints(BMKMapPointForCoordinate(cl), BMKMapPointForCoordinate(center)) ;
}

//重新扫描
-(void)reSearchByFilter:(id)sender{
    [_locService startUserLocationService];
}

-(void)reRadarScan{
    _mapView.centerCoordinate = coor;
    _mapView.minZoomLevel = _mapView.zoomLevel;
    [_mapView removeAnnotations:anoArr];
    [[radarView class] cancelPreviousPerformRequestsWithTarget:radarView selector:@selector(stopRunAnimation) object:nil];
    [radarView stopRunAnimation];
    [radarView setBgView];
    [radarView setRadarLine];
    [self performSelector:@selector(setMapAnnotation) withObject:nil afterDelay:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
