//
//  LJKPinAnnotation.m
//  NAMapKitDemo
//
//  Created by waycubeios02 on 17/9/29.
//  Copyright © 2017年 weilifang. All rights reserved.
//

#import "LJKPinAnnotation.h"
#import "LJKPinAnnotationView.h"
#import "NAMapView.h"

@interface LJKPinAnnotation ()
@property (nonatomic, readonly, weak) LJKPinAnnotationView *view;
@end

@implementation LJKPinAnnotation
@dynamic view;

- (id)initWithPoint:(CGPoint)point
{
    self = [super initWithPoint:point];
    if (self) {
        self.type = WC;
        self.title = nil;
        self.subtitle = nil;
    }
    return self;
}

- (UIView *)createViewOnMapView:(NAMapView *)mapView
{   //继承自父类 创建view显示在地图上的方法 必须重写
    return [[LJKPinAnnotationView alloc] initWithAnnotation:self onMapView:mapView];
}

- (void)addToMapView:(NAMapView *)mapView animated:(BOOL)animate
{
    [super addToMapView:mapView animated:animate];
    
    [mapView addSubview:self.view];
    
    if (animate) {
        self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0f, 0.0f);
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.168 animations:^{
            weakSelf.view.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)updatePosition
{
    [self.view updatePosition];
}

@end
