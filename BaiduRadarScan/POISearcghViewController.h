//
//  POISearcghViewController.h
//  BaiduRadarScan
//
//  Created by zhanglei on 15/11/23.
//  Copyright © 2015年 lei.zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMKPoiSearch.h>
#import <BaiduMapAPI/BMKGeocodeSearch.h>
#import <BaiduMapAPI/BMKMapView.h>
#import <BaiduMapAPI/BMKLocationService.h>
@interface POISearcghViewController : UIViewController<BMKPoiSearchDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,UITextFieldDelegate,BMKGeoCodeSearchDelegate>

@end
