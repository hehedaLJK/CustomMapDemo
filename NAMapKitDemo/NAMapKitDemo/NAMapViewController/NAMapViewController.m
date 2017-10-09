//
//  NAMapViewController.m
//  NAMapKitDemo
//
//  Created by waycubeios02 on 17/9/29.
//  Copyright © 2017年 weilifang. All rights reserved.
//

#import "NAMapViewController.h"
#import "NAPinAnnotationMapView.h"
#import "NAPinAnnotation.h"
#import "ToolClass.h"

@interface NAMapViewController ()

@end

@implementation NAMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*注意
     #import "NAMapView.h"
     #import "NAAnnotation.h"
     这两个是最基础的基类 第一个是最基本的显示地图（点击别针没有气泡） 第二个是最基础的地图上的点
     如果需要别针效果需要使用（NAPinAnnotation）如果需要点击别针的气泡效果需使用（NAPinAnnotationMapView）
     */
    
    NAPinAnnotationMapView *map = [[NAPinAnnotationMapView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20)];
    map.backgroundColor  = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:214/255.0];
    map.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIImage *image = [UIImage imageNamed:@"Map.png"];
    map.minimumZoomScale = 0.1f;
    map.maximumZoomScale = 1.0f;
    [map displayMap:image];
    
    map.zoomScale = map.bounds.size.height / image.size.height;
    
    map.minimumZoomScale = map.minimumZoomScale < map.zoomScale ? map.zoomScale : map.minimumZoomScale;
    [self.view addSubview:map];
    
    NSArray *array = [ToolClass getJsonArray:@"scene_list.json"];
    NSMutableArray *sceneDotArray = [NSMutableArray arrayWithCapacity:array.count];
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *dic= obj;
        NAPinAnnotation *dot = [NAPinAnnotation annotationWithPoint:CGPointMake([dic[@"left"] doubleValue], [dic[@"top"] doubleValue])];
        dot.title = dic[@"title"];
        dot.subtitle = dic[@"subtitle"];
        dot.color = NAPinColorRed;
        [sceneDotArray addObject:dot];
        
    }];
    
    [map addAnnotations:sceneDotArray animated:YES];
    
    
    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 40, 40, 40)];
    [returnBtn setTitle:@"返回" forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
}

- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
