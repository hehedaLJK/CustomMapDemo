//
//  MapViewController.m
//  ScenicSpotApp
//
//  Created by waycubeios02 on 17/9/25.
//  Copyright © 2017年 weilifang. All rights reserved.
//

#import "MapViewController.h"
#import "LJKPinAnnotation.h"
#import "ToolClass.h"
#import "LJKPinAnnotationMapView.h"
#import "SceneDetailController.h"
@interface MapViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    NSInteger _showDotType;//0未显示 1景点 2wc
    
    NSMutableArray *_searchResultDataArray;
    
    LJKPinAnnotation *_locationDot;
}
@property (nonatomic, strong)LJKPinAnnotationMapView *mapView;
@property (nonatomic, strong)NSMutableArray *sceneDotArray;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (nonatomic, strong)NSMutableArray *wcDotArary;

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewBottomLayout;
@property (weak, nonatomic) IBOutlet UIButton *showSlideViewBtn;
@property (weak, nonatomic) IBOutlet UIButton *allMapBtn;
@property (weak, nonatomic) IBOutlet UIButton *setLocationBtn;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    _mapView = [[LJKPinAnnotationMapView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20 -49)];
    
    _mapView.backgroundColor  = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:214/255.0];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIImage *image = [UIImage imageNamed:@"Map.png"];
    _mapView.minimumZoomScale = 0.1f;
    _mapView.maximumZoomScale = 1.0f;
    [_mapView displayMap:image];
    
    
    _mapView.zoomScale = (_mapView.bounds.size.height + 49)/ image.size.height;//[[UIScreen mainScreen] bounds].size.width / image.size.width;//mapView.bounds.size.height / image.size.height
    
    
    _mapView.minimumZoomScale = _mapView.minimumZoomScale < _mapView.zoomScale ? _mapView.zoomScale : _mapView.minimumZoomScale;
    
    [self.view addSubview:_mapView];
    [self.view bringSubviewToFront:self.scanBtn];
    [self.view bringSubviewToFront:self.showSlideViewBtn];
    [self.view bringSubviewToFront:self.allMapBtn];
    [self.view bringSubviewToFront:self.setLocationBtn];
    [self.view bringSubviewToFront:self.searchView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowDetail:) name:@"ShowDetail" object:nil];
    
    [self.openBtn setTransform:CGAffineTransformMakeRotation(M_PI)];
    
    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 40, 40, 40)];
    [returnBtn setTitle:@"返回" forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
}

- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)sceneDotArray{
    if (!_sceneDotArray) {
        __weak typeof(self) weakSelf = self;
        NSArray *array = [ToolClass getJsonArray:@"scene_list.json"];
        _sceneDotArray = [NSMutableArray arrayWithCapacity:array.count];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *dic= obj;
            LJKPinAnnotation *dot = [LJKPinAnnotation annotationWithPoint:CGPointMake([dic[@"left"] doubleValue], [dic[@"top"] doubleValue])];
            dot.title = dic[@"title"];
            dot.subtitle = dic[@"subtitle"];
            dot.type = Scene;
            [weakSelf.sceneDotArray addObject:dot];
            
        }];
    }
    
    return _sceneDotArray;
}

- (IBAction)showScene:(id)sender {
    

    [_mapView removeAllAnnotaions];
    
    [self.mapView addAnnotations:self.sceneDotArray animated:YES];
    _showDotType = 1;
}

- (IBAction)showWC:(id)sender {
    
    [self.mapView stopPlayAudio];
    
    __weak typeof(self) weakSelf = self;
    
    if (!_wcDotArary) {
        
        NSArray *array = [ToolClass getJsonArray:@"wc_list.json"];
        _wcDotArary = [NSMutableArray arrayWithCapacity:array.count];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *dic= obj;
            LJKPinAnnotation *dot = [LJKPinAnnotation annotationWithPoint:CGPointMake([dic[@"left"] doubleValue], [dic[@"top"] doubleValue])];
            dot.title = dic[@"title"];
            dot.subtitle = dic[@"subtitle"];
            dot.type = WC;
            [weakSelf.wcDotArary addObject:dot];
            
        }];
    }
    
    [_mapView removeAllAnnotaions];
    [self.mapView addAnnotations:_wcDotArary animated:YES];
    _showDotType = 2;
}

- (void)ShowDetail:(NSNotification *)sender{
    
    [self.mapView stopPlayAudio];
    SceneDetailController *DVC;
    if (sender.userInfo) {
        LJKAnnotation *annotaion = sender.userInfo[@"annotation"];
        DVC = [[SceneDetailController alloc] initWithAnnotaion:annotaion];
    }else{
        DVC = [[SceneDetailController alloc] init];
    }
    [self.navigationController pushViewController:DVC animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    CGRect frame = self.searchView.frame;
    frame.origin.y -= 80;
    __weak typeof(self) waekSelf = self;
    [UIView animateWithDuration:0.168 animations:^{
        waekSelf.searchView.frame = frame;
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    CGRect frame = self.searchView.frame;
    frame.origin.y += 80;
    __weak typeof(self) waekSelf = self;
    [UIView animateWithDuration:0.168 animations:^{
        waekSelf.searchView.frame = frame;
    }];
    
    if (!_searchResultDataArray) {
        _searchResultDataArray = @[].mutableCopy;
    }else{
        [_searchResultDataArray removeAllObjects];
    }
    
    [self.sceneDotArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        LJKPinAnnotation *dot = obj;
        if ([dot.title containsString:textField.text]) {
            [_searchResultDataArray addObject:dot];
        }
    }];
    [_resultTableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_searchTextField resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _searchResultDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    LJKPinAnnotation *dot = _searchResultDataArray[indexPath.row];
    cell.textLabel.text = dot.title;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 35;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LJKPinAnnotation *dot = _searchResultDataArray[indexPath.row];
    
    [self openBtnClicked:self.openBtn];
    [self.mapView removeAllAnnotaions];
    [self.mapView addAnnotation:dot animated:YES];
    [self.mapView showCalloutForAnnotation:dot animated:YES];
}
- (IBAction)openBtnClicked:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    CGRect frame = self.searchView.frame;
    
    if (sender.isSelected) {
        [sender setTransform:CGAffineTransformMakeRotation(0)];
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - 300;
        _searchViewBottomLayout.constant = 0;
    }else{
        [sender setTransform:CGAffineTransformMakeRotation(M_PI)];
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - 49;
        _searchViewBottomLayout.constant = -251;
        [_searchTextField resignFirstResponder];
    }
    
    __weak typeof(self) waekSelf = self;
    [UIView animateWithDuration:0.168 animations:^{
        waekSelf.searchView.frame = frame;
    }];
    
}


- (IBAction)allMap:(id)sender {
    
    [_mapView setZoomScale:_mapView.minimumZoomScale animated:YES];
    
}
- (IBAction)setLocation:(id)sender {
    
    if (!_locationDot) {
        _locationDot = [[LJKPinAnnotation alloc] init];
        _locationDot.type = Location;
    }
    LJKPinAnnotation *dot = self.sceneDotArray[arc4random() % self.sceneDotArray.count];
    
    _locationDot.point = dot.point;
    
    
    if (self.openBtn.isSelected) {
        [self openBtnClicked:self.openBtn];
    }
    [self.mapView removeAllAnnotaions];
    [self.mapView addAnnotation:_locationDot animated:YES];
    [self.mapView centerOnPoint:_locationDot.point animated:YES];
    
}

@end
