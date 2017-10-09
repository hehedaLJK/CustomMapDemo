//
//  SceneDetailController.m
//  Smart_ticket_iOS
//
//  Created by waycubeios02 on 17/9/27.
//  Copyright © 2017年 weilifang. All rights reserved.
//

#import "SceneDetailController.h"
#import <AVFoundation/AVFoundation.h>
#import "LJKPinAnnotation.h"
@interface SceneDetailController ()<AVAudioPlayerDelegate>{
    
    NSTimer *timer;                 //监控音频播放进度
    LJKPinAnnotation *_anntaion;
}
@property (weak, nonatomic) IBOutlet UILabel *audioNowTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *progress;
@property (nonatomic, strong)AVAudioPlayer *audioPlayer;


@property (weak, nonatomic) IBOutlet UILabel *sceneNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation SceneDetailController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (instancetype)initWithAnnotaion:(LJKPinAnnotation *)annotaion
{
    self = [super init];
    if (self) {
        _anntaion = annotaion;
        
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _audioPlayer.currentTime = 0;
    [self.audioPlayer stop];
    [timer invalidate];
    timer = nil;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"景点详情";
    
    if (_anntaion) {
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_anntaion.title ofType:@"jpg"]];
        self.sceneNameLabel.text = _anntaion.title;
        self.imageView1.image = img;
        self.imageView2.image = img;
        self.messageLabel.text = _anntaion.subtitle;
    }
    
}


//播放进度条
- (void)playProgress
{
    //通过音频播放时长的百分比,给progressview进行赋值;
     _progress.value = _audioPlayer.currentTime/_audioPlayer.duration;
    
    NSInteger min = _audioPlayer.currentTime / 60;
    NSInteger sec = _audioPlayer.currentTime - min * 60;
    
    _audioNowTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", min, sec];
}

//播放完成时调用的方法  (代理里的方法),需要设置代理才可以调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [timer invalidate]; //NSTimer暂停   invalidate  使...无效;
}
- (IBAction)playBtn:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        if (!self.audioPlayer) {

            NSURL *fileURL = [[NSBundle mainBundle]URLForResource:@"大美玉" withExtension:@".mp3"];
            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
            self.audioPlayer.delegate = self;
            self.audioPlayer.numberOfLoops = 0;
            
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self
                                                   selector:@selector(playProgress)
                                                   userInfo:nil repeats:YES];
        }
        [self.audioPlayer play];
    }else{
        [self.audioPlayer pause];
    }
    
}

@end
