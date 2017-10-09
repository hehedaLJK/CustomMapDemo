//
//  ViewController.m
//  NAMapKitDemo
//
//  Created by waycubeios02 on 17/9/29.
//  Copyright © 2017年 weilifang. All rights reserved.
//

#import "ViewController.h"
#import "NAMapViewController.h"
#import "MapViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)pushNAMapViewController:(id)sender {
    
    NAMapViewController *mapController = [[NAMapViewController alloc] init];
    [self.navigationController pushViewController:mapController animated:YES];
    
}

- (IBAction)PushLJKMapViewController:(id)sender {
    
    MapViewController *mapController = [MapViewController new];
    [self.navigationController pushViewController:mapController animated:YES];
}

@end
