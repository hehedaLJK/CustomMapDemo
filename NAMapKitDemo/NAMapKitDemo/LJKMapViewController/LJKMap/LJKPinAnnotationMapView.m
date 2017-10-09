//
//  LJKPinAnnotationMapView.m
//  NAMapKitDemo
//
//  Created by waycubeios02 on 17/9/29.
//  Copyright © 2017年 weilifang. All rights reserved.
//

#import "LJKPinAnnotationMapView.h"
#import "LJKPinAnnotationCallOutView.h"
#import "LJKPinAnnotation.h"
#import "LJKPinAnnotationView.h"

@interface LJKPinAnnotationMapView ()
@property (nonatomic, strong) LJKPinAnnotationCallOutView *calloutView;
@property (nonatomic, strong) UIView *calloutViewBackView;
@property (nonatomic, readonly) NSMutableArray *annotations;
- (void)showCallOut:(id)sender;
- (void)hideCallOut;

@end

@implementation LJKPinAnnotationMapView

- (void)setupMap
{
    [super setupMap];
    
    _calloutView = [[LJKPinAnnotationCallOutView alloc] initOnMapView:self];
    _calloutViewBackView = [[UIView alloc] initWithFrame:_calloutView.frame];
    [_calloutViewBackView addSubview:_calloutView];
    _calloutView.userInteractionEnabled = YES;
    _calloutViewBackView.userInteractionEnabled = YES;
    [self addSubview:self.calloutViewBackView];
    
    _annotations = @[].mutableCopy;
}

- (void)addAnnotation:(NAAnnotation *)annotation animated:(BOOL)animate
{
    
    [annotation addToMapView:self animated:animate];
    [self.annotations addObject:annotation];
    if ([annotation.view isKindOfClass:NSClassFromString(@"LJKPinAnnotationView")]) {
        LJKPinAnnotation *annot = (LJKPinAnnotation *)annotation;
        
        if (annot.type == Scene) {//我这里只有点击景点别针才显示气泡 根据需求修改
            LJKPinAnnotationView *annotationView = (LJKPinAnnotationView *) annotation.view;
            [annotationView addTarget:self action:@selector(showCallOut:) forControlEvents:UIControlEventTouchDown];
        }
    }
    
    [self bringSubviewToFront:self.calloutViewBackView];
}

- (void)selectAnnotation:(NAAnnotation *)annotation animated:(BOOL)animate
{
    [self hideCallOut];
    if([annotation isKindOfClass:NSClassFromString(@"LJKAnnotation")]) {
        [self showCalloutForAnnotation:(LJKPinAnnotation *)annotation animated:animate];
    }
}

- (void)removeAnnotation:(NAAnnotation *)annotation
{
    [self hideCallOut];
    [annotation removeFromMapView];
    [self.annotations removeObject:annotation];
}

- (void)removeAllAnnotaions{
    
    [self hideCallOut];
    
    [self.annotations enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        LJKPinAnnotation *annot = obj;
        [annot removeFromMapView];
        [self.annotations removeObject:annot];
    }];
    
}

- (void)showCallOut:(id)sender
{
    if([sender isKindOfClass:[LJKPinAnnotationView class]]) {
        LJKPinAnnotationView *annontationView = (LJKPinAnnotationView *)sender;
        
        if ([self.mapViewDelegate respondsToSelector:@selector(mapView:tappedOnAnnotation:)]) {
            [self.mapViewDelegate mapView:self tappedOnAnnotation:annontationView.annotation];
        }
        
        [self showCalloutForAnnotation:annontationView.annotation animated:YES];
    }
}

- (void)showCalloutForAnnotation:(LJKPinAnnotation *)annotation animated:(BOOL)animated
{
    [self hideCallOut];
    
    self.calloutView.annotation = annotation;
    
    [self centerOnPoint:annotation.point animated:animated];
    
    CGFloat animationDuration = animated ? 0.1f : 0.0f;
    
    self.calloutView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4f, 0.4f);
    self.calloutView.hidden = NO;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:animationDuration animations:^{
        weakSelf.calloutView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hideCallOut
{
    self.calloutView.hidden = YES;
    [self.calloutView stopPlay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.superview endEditing:YES];
    
    UITouch *touch =  [touches anyObject];
    
    if (touch.view != self) {
        return;
    }
    
    if (!self.dragging) {
        [self hideCallOut];
    }
    
    [super touchesEnded:touches withEvent:event];
}

- (void)updatePositions
{
    [self.calloutView updatePosition];
    [super updatePositions];
}

- (void)stopPlayAudio{
    [self.calloutView stopPlay];
}


@end
