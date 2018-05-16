//
//  ViewController.m
//  iOS音乐播放
//
//  Created by soliloquy on 2018/5/16.
//  Copyright © 2018年 soliloquy. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//播放器
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ViewController

-(NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    }
    return _timer;
}

-(AVAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        NSString *fileStr = [[NSBundle mainBundle]pathForResource:@"1.mp3" ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:fileStr];
        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        //设置为0不循环
        _audioPlayer.numberOfLoops = 0;
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];
    }
    return _audioPlayer;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
  
    self.slider.minimumValue = 0;
    self.slider.maximumValue = self.audioPlayer.duration;
    [self.slider addTarget:self action:@selector(updateValueChanged:) forControlEvents:UIControlEventValueChanged];
    
}

#pragma mark - 拖动进度条
- (void)updateValueChanged:(UISlider *)slider {
     NSLog(@"%s",__FUNCTION__);
    self.audioPlayer.currentTime = slider.value;
}

- (void)updateProgress{

    NSLog(@"%s",__FUNCTION__);
    [self.slider setValue:self.audioPlayer.currentTime animated:YES];
}

#pragma mark - ▶️
- (IBAction)playing:(id)sender {
    
    [self ptl_play];
}
#pragma mark - ⏸
- (IBAction)pause:(id)sender {
    
    [self ptl_pasue];
}

- (void)ptl_play {
    if (!self.audioPlayer.isPlaying) {
        
        [self.audioPlayer play];
        //恢复定时器
        self.timer.fireDate = [NSDate distantPast];
    }
}

- (void)ptl_pasue {
    if (self.audioPlayer.isPlaying) {
        
        [self.audioPlayer pause];
        //暂停定时器，注意不能调用invalidate方法，此方法会取消，之后无法恢复
        self.timer.fireDate = [NSDate distantFuture];
    }
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"%s",__FUNCTION__);
    [self.timer invalidate];
    self.timer = nil;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    NSLog(@"%s",__FUNCTION__);
}

@end
