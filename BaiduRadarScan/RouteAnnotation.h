//
//  RouteAnnotation.h
//  促利汇_门户
//
//  Created by zhanglei on 15/11/10.
//  Copyright © 2015年 lei.zhang. All rights reserved.
//

#import <BaiduMapAPI/BMKPointAnnotation.h>
@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end
