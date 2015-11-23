//
//  POISearcghViewController.m
//  BaiduRadarScan
//
//  Created by zhanglei on 15/11/23.
//  Copyright © 2015年 lei.zhang. All rights reserved.
//

#import "POISearcghViewController.h"
#import <BaiduMapAPI/BMKPoiSearch.h>
#import <BaiduMapAPI/BMKMapView.h>
#import <BaiduMapAPI/BMKLocationService.h>
#import <BaiduMapAPI/BMKPointAnnotation.h>
#import <BaiduMapAPI/BMKRadarOption.h>
#import <BaiduMapAPI/BMKSearchComponent.h>
#import "MapViewController.h"
@interface POISearcghViewController ()
{
    UIButton * btnBack;
    BMKLocationService * _locService;
    BMKPoiSearch * _search;
    BMKMapView * _map;
    UILabel * lblTitle;
    UITextField * utfSearchKey;
    UITextField * utfSearchRadius;
    UIButton * btnPOISearch;
    CLLocationCoordinate2D coor;
    UIButton * btnSearch;
    NSMutableArray * locationArr;
    
    BMKGeoCodeSearch* _geocodesearch;
    
    float lat;
    float lng;
}
@end

@implementation POISearcghViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    locationArr = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, UI_SCREEN_WIDTH, 40)];
    [lblTitle setText:@"POI检索"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:lblTitle];
    
    btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [btnBack setTitle:@"返回" forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [btnBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btnBack];
    
    btnSearch = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-40, 20, 40, 40)];
    [btnSearch setTitle:@"搜索" forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [btnSearch setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btnSearch];
    
    _map = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 60, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-60)];
    _map.delegate = self;
    _map.zoomEnabled = YES;
    _map.zoomEnabledWithTap =YES;
    _map.zoomLevel = 13;
    [self.view addSubview:_map];
    
    utfSearchKey = [[UITextField alloc] initWithFrame:CGRectMake(5, 65, (UI_SCREEN_WIDTH)/2-10, 30)];
    [utfSearchKey.layer setBorderWidth:.5];
    [utfSearchKey.layer setBorderColor:[UIColor grayColor].CGColor];
    utfSearchKey.delegate = self;
    [utfSearchKey.layer setMasksToBounds:YES];
    [utfSearchKey.layer setCornerRadius:2];
    [utfSearchKey setBackgroundColor:[UIColor whiteColor]];
    utfSearchKey.placeholder = @"输入搜索关键字";
    [self.view addSubview:utfSearchKey];
    
    utfSearchRadius = [[UITextField alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2+5, 65, (UI_SCREEN_WIDTH/2-10), 30)];
    [utfSearchRadius.layer setBorderWidth:.5];
    [utfSearchRadius.layer setBorderColor:[UIColor grayColor].CGColor];
    [utfSearchRadius.layer setMasksToBounds:YES];
    [utfSearchRadius.layer setCornerRadius:2];
    [utfSearchRadius setBackgroundColor:[UIColor whiteColor]];
    utfSearchRadius.delegate = self;
    utfSearchRadius.placeholder = @"输入搜索半径";
    [self.view addSubview:utfSearchRadius];
    
    _search = [[BMKPoiSearch alloc] init];
    _search.delegate = self;
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _geocodesearch.delegate = self;
    
    [_locService startUserLocationService];
}

-(void)dismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)search:(id)sender{
    if ([utfSearchKey.text isEqualToString:@""]) {
        return;
    }
    BMKNearbySearchOption * option = [[BMKNearbySearchOption alloc] init];
    option.pageCapacity = 50;
    option.pageIndex = 0;
    option.location = coor;
    option.keyword = utfSearchKey.text;
    option.radius = [utfSearchRadius.text doubleValue];
    BOOL flag = [_search poiSearchNearBy:option];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    coor = userLocation.location.coordinate;
    [_map setCenterCoordinate:coor];
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
    item.coordinate = coor;
    [_map addAnnotation:item];
    [_map setZoomLevel:18];
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        
    }
    else
    {
        
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
  
}

//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"%@",poiResultList);
        NSArray * array = poiResultList.poiInfoList;
        locationArr = [NSMutableArray arrayWithArray:array];
        for (BMKPoiInfo * info in array) {
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = info.pt;
            [_map addAnnotation:item];
            [_map setZoomLevel:16];
        }
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
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
    annotationView.canShowCallout = YES;
    if (((BMKPointAnnotation*)annotation).coordinate.latitude == coor.latitude && ((BMKPointAnnotation*)annotation).coordinate.longitude == coor.longitude) {
        NSLog(@"noPaopao");
    }else{
        annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:[self createPaoPaoView:((BMKPointAnnotation*)annotation).coordinate.latitude]];
    }
    return annotationView;
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    BMKAddressComponent * address = result.addressDetail;
    NSString * city = address.city;
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:city forKey:@"cityName"];
    [ud synchronize];
}

-(UIView *)createPaoPaoView:(double)latitude{
    BMKPoiInfo * info;
    NSInteger selectIdx = 0;
    
    for (BMKPoiInfo * poiInfo in locationArr) {
        if (poiInfo.pt.latitude == latitude) {
            info = poiInfo;
            break;
        }
        selectIdx ++;
    }
    UIView * view;
    if (info.phone&&![info.phone isEqualToString:@""]&&![info.phone isEqualToString:@"(null)"]) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 80)];
    }else{
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 60)];
    }
    [view setBackgroundColor:[UIColor whiteColor]];
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius:2];
    float offy = 0;
    
    UILabel * lblName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 20)];
    [lblName setFont:[UIFont systemFontOfSize:14]];
    [lblName setTextColor:[UIColor redColor]];
    [lblName setText:info.name];
    [view addSubview:lblName];
    
    offy += 20;
    
    UILabel * lblAddress = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 240, 20)];
    [lblAddress setText:[NSString stringWithFormat:@"店铺地址:%@",info.address]];
    [lblAddress setFont:[UIFont systemFontOfSize:14]];
    [lblAddress setTextColor:[UIColor redColor]];
    [view addSubview:lblAddress];
    
    offy += 20;
    
    if (info.phone&&![info.phone isEqualToString:@""]&&![info.phone isEqualToString:@"(null)"]) {
        UILabel * lblPhone = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 240,20)];
        [lblPhone setText:[NSString stringWithFormat:@"联系电话:%@",info.phone]];
        [lblPhone setFont:[UIFont systemFontOfSize:14]];
        [lblPhone setTextColor:[UIColor redColor]];
        [view addSubview:lblPhone];
        offy +=20;
    }
    
    UIButton * btnGoThere = [[UIButton alloc] initWithFrame:CGRectMake(0, offy, 240, 20)];
    [btnGoThere setBackgroundColor:[UIColor redColor]];
    [btnGoThere setTag:selectIdx];
    [btnGoThere.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnGoThere setTitle:@"到那去" forState:UIControlStateNormal];
    [btnGoThere addTarget:self action:@selector(goThere:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnGoThere];
    
    return view;
}

-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    
}

-(UIImage *)getImageFromView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)goThere:(id)sender{
    UIButton * btn = (UIButton *)sender;
    NSInteger idx = btn.tag;
    BMKPoiInfo * pinfo = [locationArr objectAtIndex:idx];
    NSLog(@"goThere");
    MapViewController * mapRoute = [[MapViewController alloc] init];
    mapRoute.coordate = pinfo.pt;
    [self presentViewController:mapRoute animated:YES completion:^{
        
    }];
}

#pragma mark --- UITextfiledDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
