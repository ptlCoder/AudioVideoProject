//
//  ViewController.m
//  iOS系统音效
//
//  Created by soliloquy on 2018/5/16.
//  Copyright © 2018年 soliloquy. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


void AudioServicesSystemSoundCompletion(SystemSoundID ssID,void* __nullable    clientData) {
    NSLog(@"播放完成---");
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
        NSString *audioFile = [[NSBundle mainBundle]pathForResource:@"call.caf" ofType:nil];
        NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
        // 1.获得系统声音ID
        SystemSoundID soundID = 0;
        /**
         * inFileUrl:音频文件url
         * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
         */
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(fileUrl), &soundID);
        //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
        AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, AudioServicesSystemSoundCompletion, NULL);
        // 2.播放音频
         AudioServicesPlaySystemSound(soundID);//播放音效
    //    AudioServicesPlayAlertSound(soundID);//播放音效并震动
}



@end
