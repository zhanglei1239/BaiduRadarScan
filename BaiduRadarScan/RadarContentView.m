//
//  RadarContentView.m
//  促利汇_实体店
//
//  Created by zhanglei on 15/10/23.
//  Copyright © 2015年 lei.zhang. All rights reserved.
//

#import "RadarContentView.h"

@implementation RadarContentView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    CGPoint p = CGPointMake(rect.size.width/2, rect.size.height/2);
    float r = rect.size.width/2;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context,1,1,1,.3);
    CGContextSetLineWidth(context, 5.0);
    //    圆1
    r = r - 40;
    CGContextAddArc(context, p.x, p.y, r, 0, 2*PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    //    圆2
    r = r - 40;
    CGContextAddArc(context, p.x, p.y, r, 0, 2*PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGPoint aPoints[2];//坐标点
    aPoints[0] =CGPointMake(0, p.y);//坐标1
    aPoints[1] =CGPointMake(rect.size.width, p.y);//坐标2
    CGContextSetLineWidth(context, 2.0);
    
    //left->right
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke);
    
    aPoints[0] =CGPointMake(p.x, 0);//坐标1
    aPoints[1] =CGPointMake(p.x, rect.size.height);//坐标2
    
    //top->bottom
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke);
    
    aPoints[0] =CGPointMake(0, 0);//坐标1
    aPoints[1] =CGPointMake(rect.size.width, rect.size.height);//坐标2
    
    //left-top->right-bottom;
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke);
    
    aPoints[0] =CGPointMake(0, rect.size.height);//坐标1
    aPoints[1] =CGPointMake(rect.size.width, 0);//坐标2
    
    //left-bottom->right-top;
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke);
    
}

@end
