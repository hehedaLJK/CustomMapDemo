//
//  LJKPinAnnotation.h
//  NAMapKitDemo
//
//  Created by waycubeios02 on 17/9/29.
//  Copyright © 2017年 weilifang. All rights reserved.
//

#import "NAAnnotation.h"

typedef enum {
    WC,
    Scene,
    Location
} PinType;//点的类型 根据需要做修改 用于决定点显示的图片

//仿照"NAPinAnnotation"写的点信息类 用于存储你点的信息
@interface LJKPinAnnotation : NAAnnotation

// 点类型
@property (nonatomic, assign) PinType type;
// 点标题
@property (nonatomic, copy) NSString *title;
// 点信息
@property (nonatomic, copy) NSString *subtitle;

// 根据点初始化
- (id)initWithPoint:(CGPoint)point;

@end
