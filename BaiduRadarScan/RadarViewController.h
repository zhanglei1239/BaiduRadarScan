//
//  RadarViewController.h
//  促利汇_门户
//
//  Created by zhanglei on 15/10/19.
//  Copyright © 2015年 lei.zhang. All rights reserved.
//

#import <BaiduMapAPI/BMKRadarManager.h>
#import <BaiduMapAPI/BMKGeocodeSearch.h>
#import <BaiduMapAPI/BMKLocationService.h>
#import <BaiduMapAPI/BMKMapView.h>
@interface RadarViewController : UIViewController<BMKRadarManagerDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,BMKMapViewDelegate>

@end
