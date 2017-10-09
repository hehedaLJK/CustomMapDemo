//
//  LJKPinAnnotationCallOutView.h
//  Smart_ticket_iOS
//
//  Created by waycubeios02 on 17/9/26.
//  Copyright © 2017年 weilifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJKPinAnnotationMapView.h"
#import "LJKPinAnnotation.h"
@interface LJKPinAnnotationCallOutView : UIView

// 在地图上创建气泡
- (id)initOnMapView:(LJKPinAnnotationMapView *)mapView;

// 更新气泡位置
- (void)updatePosition;

@property(readwrite, nonatomic, weak) LJKPinAnnotation *annotation;

- (void)stopPlay;

@end
