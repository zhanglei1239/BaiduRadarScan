//
//  RadarView.h
//  促利汇_门户
//
//  Created by zhanglei on 15/10/19.
//  Copyright © 2015年 lei.zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadarContentView.h"
@interface RadarView : UIView
@property (nonatomic,strong) UIImageView * rView; 
@property (nonatomic,strong) UIImageView * bg; 
-(void)setRadarLine;
-(void)stopRunAnimation;
-(void)setBgView;
@end
