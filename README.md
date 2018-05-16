# AudioVideoProject
一些关于iOS的多媒体技术Demo
## 音效
```
在iOS中音频播放从形式上可以分为音效播放和音乐播放。前者主要指的是一些短音频播放，通常作为点缀音频，对于这类音频不需要进行进度、循环等控制。后者指的是一些较长的音频，通常是主音频，对于这些音频的播放通常需要进行精确的控制。在iOS中播放两类音频分别使用AudioToolbox.framework和AVFoundation.framework来完成音效和音乐播放。

音效
AudioToolbox.framework是一套基于C语言的框架，使用它来播放音效其本质是将短音频注册到系统声音服务（System Sound Service）。System Sound Service是一种简单、底层的声音播放服务，但是它本身也存在着一些限制：

音频播放时间不能超过30s
数据必须是PCM或者IMA4格式
音频文件必须打包成.caf、.aif、.wav中的一种（注意这是官方文档的说法，实际测试发现一些.mp3也可以播放）
使用System Sound Service 播放音效的步骤如下：

调用AudioServicesCreateSystemSoundID(   CFURLRef  inFileURL, SystemSoundID*   outSystemSoundID)函数获得系统声音ID。
如果需要监听播放完成操作，则使用AudioServicesAddSystemSoundCompletion(  SystemSoundID inSystemSoundID,
CFRunLoopRef  inRunLoop, CFStringRef  inRunLoopMode, AudioServicesSystemSoundCompletionProc  inCompletionRoutine, void*  inClientData)方法注册回调函数。
调用AudioServicesPlaySystemSound(SystemSoundID inSystemSoundID) 或者AudioServicesPlayAlertSound(SystemSoundID inSystemSoundID) 方法播放音效（后者带有震动效果）。

```

## 音乐播放
```
如果播放较大的音频或者要对音频有精确的控制则System Sound Service可能就很难满足实际需求了，通常这种情况会选择使用AVFoundation.framework中的AVAudioPlayer来实现。AVAudioPlayer可以看成一个播放器，它支持多种音频格式，而且能够进行进度、音量、播放速度等控制。首先简单看一下AVAudioPlayer常用的属性和方法：

|属性|说明|
@property(readonly, getter=isPlaying) BOOL playing    是否正在播放，只读
@property(readonly) NSUInteger numberOfChannels    音频声道数，只读
@property(readonly) NSTimeInterval duration    音频时长
@property(readonly) NSURL *url    音频文件路径，只读
@property(readonly) NSData *data    音频数据，只读
@property float pan    立体声平衡，如果为-1.0则完全左声道，如果0.0则左右声道平衡，如果为1.0则完全为右声道
@property float volume    音量大小，范围0-1.0
@property BOOL enableRate    是否允许改变播放速率
@property float rate    播放速率，范围0.5-2.0，如果为1.0则正常播放，如果要修改播放速率则必须设置enableRate为YES
@property NSTimeInterval currentTime    当前播放时长
@property(readonly) NSTimeInterval deviceCurrentTime    输出设备播放音频的时间，注意如果播放中被暂停此时间也会继续累加
@property NSInteger numberOfLoops    循环播放次数，如果为0则不循环，如果小于0则无限循环，大于0则表示循环次数
@property(readonly) NSDictionary *settings    音频播放设置信息，只读
@property(getter=isMeteringEnabled) BOOL meteringEnabled    是否启用音频测量，默认为NO，一旦启用音频测量可以通过updateMeters方法更新测量值
对象方法    说明
- (instancetype)initWithContentsOfURL:(NSURL *)url error:(NSError **)outError    使用文件URL初始化播放器，注意这个URL不能是HTTP URL，AVAudioPlayer不支持加载网络媒体流，只能播放本地文件
- (instancetype)initWithData:(NSData *)data error:(NSError **)outError    使用NSData初始化播放器，注意使用此方法时必须文件格式和文件后缀一致，否则出错，所以相比此方法更推荐使用上述方法或- (instancetype)initWithData:(NSData *)data fileTypeHint:(NSString *)utiString error:(NSError **)outError方法进行初始化
- (BOOL)prepareToPlay;    加载音频文件到缓冲区，注意即使在播放之前音频文件没有加载到缓冲区程序也会隐式调用此方法。
- (BOOL)play;    播放音频文件
- (BOOL)playAtTime:(NSTimeInterval)time    在指定的时间开始播放音频
- (void)pause;    暂停播放
- (void)stop;    停止播放
- (void)updateMeters    更新音频测量值，注意如果要更新音频测量值必须设置meteringEnabled为YES，通过音频测量值可以即时获得音频分贝等信息
- (float)peakPowerForChannel:(NSUInteger)channelNumber;    获得指定声道的分贝峰值，注意如果要获得分贝峰值必须在此之前调用updateMeters方法
- (float)averagePowerForChannel:(NSUInteger)channelNumber    获得指定声道的分贝平均值，注意如果要获得分贝平均值必须在此之前调用updateMeters方法
@property(nonatomic, copy) NSArray *channelAssignments    获得或设置播放声道
代理方法    说明
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag    音频播放完成
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error    音频解码发生错误

```

