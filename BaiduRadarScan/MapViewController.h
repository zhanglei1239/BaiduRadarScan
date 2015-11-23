//
//  MapViewController.h
//  促利汇_门户
//
//  Created by zhanglei on 15/11/10.
//  Copyright © 2015年 lei.zhang. All rights reserved.
//

#import <BaiduMapAPI/BMKGeocodeSearch.h>
#import <BaiduMapAPI/BMKLocationService.h>
#import <BaiduMapAPI/BMKMapView.h>
#import <BaiduMapAPI/BMKRouteSearch.h>
#import <BaiduMapAPI/BMKPointAnnotation.h>
@interface MapViewController : UIViewController<BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,BMKMapViewDelegate,BMKRouteSearchDelegate>
@property (nonatomic,assign) CLLocationCoordinate2D coordate;
@end
