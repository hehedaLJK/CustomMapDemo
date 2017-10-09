//
//  LJKPinAnnotationCallOutView.m
//  Smart_ticket_iOS
//
//  Created by waycubeios02 on 17/9/26.
//  Copyright © 2017年 weilifang. All rights reserved.
//

#import "LJKPinAnnotationCallOutView.h"
#import <AVFoundation/AVFoundation.h>
@interface LJKPinAnnotationCallOutView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sceneImageView;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *audioBtn;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, weak)   LJKPinAnnotationMapView *mapView;
@property (nonatomic, strong)AVAudioPlayer *audioPlayer;

@end

@implementation LJKPinAnnotationCallOutView


- (id)initOnMapView:(LJKPinAnnotationMapView *)mapView{
    
    self = [[NSBundle mainBundle] loadNibNamed:@"LJKPinAnnotationCallOutView" owner:nil options:nil].lastObject;
    if (self) {
        self.mapView = mapView;
        self.hidden  = YES;
    }
    return self;
}

- (void)setMap:(LJKPinAnnotationMapView *)mapView{
    
    self.mapView = mapView;
    self.hidden = YES;
}

- (void)setAnnotation:(LJKPinAnnotation *)annotation
{
    _annotation = annotation;
    self.position = annotation.point;
    self.point = annotation.point;

    [self updatePosition];
    
    self.titleLabel.text = annotation.title;
    self.subtitleLabel.text = annotation.subtitle;
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", annotation.title] ofType:@".jpg"];
    self.sceneImageView.image = [UIImage imageWithContentsOfFile:path];
}

- (void)updatePosition
{
    CGPoint point = [self.mapView zoomRelativePoint:self.position];
    CGFloat xPos = point.x - (self.frame.size.width / 2.0f);
    CGFloat yPos = point.y - (self.frame.size.height) - 26;
    if (self.superview) {
        self.superview.frame = CGRectMake(floor(xPos), yPos, self.frame.size.width, self.frame.size.height);
    }else{
        self.frame = CGRectMake(floor(xPos), yPos, self.frame.size.width, self.frame.size.height);
    }
}

- (IBAction)playAudio:(UIButton *)sender {
    
    if (sender.selected) {
        
        if (!self.audioPlayer) {
            // 1.获取要播放音频文件的URL
            NSURL *fileURL = [[NSBundle mainBundle]URLForResource:@"大美玉" withExtension:@".mp3"];
            // 2.创建 AVAudioPlayer 对象
            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
            // 3.打印歌曲信息
            //    NSString *msg = [NSString stringWithFormat:@"音频文件声道数:%ld\n 音频文件持续时间:%g",self.audioPlayer.numberOfChannels,self.audioPlayer.duration];
            //    NSLog(@"%@",msg);
            // 4.设置循环播放次数
            self.audioPlayer.numberOfLoops = -1;
        }
        // 5.开始播放
        [self.audioPlayer play];
    }else{
        [self.audioPlayer pause];
    }
    
}

- (void)stopPlay{
    if (self.audioPlayer) {
        [self.audioPlayer stop];
    }
}

- (IBAction)showDetail:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDetail" object:nil userInfo:@{@"annotation":self.annotation}];
}

@end
