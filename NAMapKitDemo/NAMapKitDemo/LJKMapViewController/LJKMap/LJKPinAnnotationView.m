//
//  LJKPinAnnotationView.m
//  NAMapKitDemo
//
//  Created by waycubeios02 on 17/9/29.
//  Copyright © 2017年 weilifang. All rights reserved.
//

#import "LJKPinAnnotationView.h"

const CGFloat LJKMapViewAnnotationPinWidth = 55.0f;//自己的控件宽
const CGFloat LJKMapViewAnnotationPinHeight = 40.0f;//自己的控件高
const CGFloat LJKMapViewAnnotationPinPointX = 18.0f;//减少会向左偏移
const CGFloat LJKMapViewAnnotationPinPointY = 38.0f;//减少会向上偏移

@interface LJKPinAnnotationView()
@property (nonatomic, weak) NAMapView *mapView;
@end

@implementation LJKPinAnnotationView

- (id)initWithAnnotation:(LJKPinAnnotation *)annotation onMapView:(NAMapView *)mapView
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.mapView = mapView;
        self.annotation = annotation;
        
        NSString *pinImageName;
        switch (annotation.type) {
            case WC:
                pinImageName = @"wc";
                break;
            case Scene:
                pinImageName = @"guanguang";
                break;
            case Location:
                pinImageName = @"定位 (2)";
                break;
        }
        UIImage *pinImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pinImageName ofType:@"png"]];
        [self setImage:pinImage forState:UIControlStateNormal];
        [[self imageView] setContentMode:UIViewContentModeScaleAspectFill];
        
    }
    return self;
}

- (void)updatePosition
{
    CGPoint point = [self.mapView zoomRelativePoint:self.annotation.point];
    point.x = point.x - (self.annotation.type == Location ? 28 : LJKMapViewAnnotationPinPointX);
    point.y = point.y - LJKMapViewAnnotationPinPointY;
    self.frame = CGRectMake(point.x, point.y, LJKMapViewAnnotationPinWidth, LJKMapViewAnnotationPinHeight);
}

@end
