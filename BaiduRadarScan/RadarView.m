//
//  RadarView.m
//  促利汇_门户
//
//  Created by zhanglei on 15/10/19.
//  Copyright © 2015年 lei.zhang. All rights reserved.
//

#import "RadarView.h"
#import <QuartzCore/QuartzCore.h>
 @implementation RadarView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:self.frame.size.width/2];
        [self setUserInteractionEnabled:NO];
        
        UIView * vcircle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [vcircle setBackgroundColor:[UIColor blackColor]];
        [vcircle.layer setMasksToBounds:YES];
        [vcircle.layer setCornerRadius:10];
        vcircle.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self addSubview:vcircle];
    }
    return self;
}

-(void)setBgView{
    if (self.bg) {
        [self.bg removeFromSuperview];
    }
    self.bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.bg setImage:[UIImage imageNamed:@"radar_bg_1"]];
    [self addSubview:self.bg];
    
}
-(void)setRadarLine{
    
    self.rView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.rView setImage:[UIImage imageNamed:@"radar_scan"]];
    [self addSubview:self.rView];
    
    CAKeyframeAnimation *rubbitrightearanimation= [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    rubbitrightearanimation.duration = 2;
    rubbitrightearanimation.removedOnCompletion = YES;
    rubbitrightearanimation.fillMode = kCAFillModeForwards;
    rubbitrightearanimation.repeatCount=MAXFLOAT;
    NSMutableArray *value1 = [NSMutableArray array];
    [value1 addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 0)]];
    [value1 addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)]];
    [value1 addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/2, 0, 0, 1)]];
    [value1 addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)]];
    rubbitrightearanimation.values = value1;
    [self.rView.layer addAnimation: rubbitrightearanimation forKey:nil];
}

-(void)stopRunAnimation{
    [self.bg setImage:[UIImage imageNamed:@"radar_bg"]];
    [self.rView.layer removeAllAnimations];
    [self.rView removeFromSuperview];
}

@end
