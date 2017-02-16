//
//  WSPlayer.m
//  视屏直播
//
//  Created by iMac on 17/2/16.
//  Copyright © 2017年 zws. All rights reserved.
//


#define WeakSealf(weakself) __weak typeof(self) weakself = self;
#import "WSPlayer.h"
#import "UIDevice+JWDevice.h"
#import "WSFullViewController.h"
@interface WSPlayer()
{
    BOOL isIntoBackground;
    BOOL isShowToolbar;
    NSTimer *_timer;
    AVPlayerItem *_playerItem;
    AVPlayerLayer *_playerLayer;
    id _playTimeObserver; // 播放进度观察者
    UIActivityIndicatorView*loadActivity;
    BOOL isFull;
}
//@property (weak, nonatomic) IBOutlet UIView *playerView;
//@property (weak, nonatomic) IBOutlet UIButton *totateBtn;
//@property (strong, nonatomic) IBOutlet UIView *topView;
//@property (strong, nonatomic) IBOutlet UIButton *backBtn;
//@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIView *playerView;

@property (strong, nonatomic) IBOutlet UIButton *totateBtn;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic,assign)CGRect oldFrame;
@property(nonatomic,strong)UIView*oldView;
@property(nonatomic,strong)UIViewController*SuperVC;
@property(nonatomic,strong)WSFullViewController*fullVC;
@property (nonatomic, strong) CADisplayLink *link;//以屏幕刷新率进行定时操作
@property (nonatomic, assign) NSTimeInterval lastTime;
@end
@implementation WSPlayer
-(void)awakeFromNib
{
    [super awakeFromNib];
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle] loadNibNamed:@"WSPlayer" owner:self options:nil] firstObject];
        self.frame=frame;
        _oldFrame=frame;
        [self setPortraitLayout];
        self.player = [[AVPlayer alloc] init];
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        [self.playerView.layer addSublayer:_playerLayer];
        loadActivity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:loadActivity];
        
    }
    return self;
}

-(void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    self.titleLabel.text = titleString;
}

-(void)showInSuperView:(UIView*)SuperView andSuperVC:(UIViewController *)SuperVC
{
    [SuperView addSubview:self];
    _oldView=SuperView;
    _SuperVC=SuperVC;
}
// 后台
- (void)resignActiveNotification{
    NSLog(@"进入后台");
    isIntoBackground = YES;
    [self pause];
}

// 前台
- (void)enterForegroundNotification
{
    NSLog(@"回到前台");
    isIntoBackground = NO;
    [self play];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _playerLayer.frame = self.bounds;
    loadActivity.center=self.center;
}
- (void)updatePlayerWith:(NSURL *)url{
    _playerItem = [AVPlayerItem playerItemWithURL:url];
    [_player replaceCurrentItemWithPlayerItem:_playerItem];
    [self addObserverAndNotification];
    [loadActivity startAnimating];
}

- (void)addObserverAndNotification{
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听缓冲进度
    [self addNotification];
}
-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // 后台&前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignActiveNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
}
-(void)loadedReady:(NSNotification*)noti
{
    NSLog(@"noti----%@",noti);
    [loadActivity stopAnimating];
}
-(void)loadUp:(NSNotification*)noti
{
    NSLog(@"loadUp------%@",noti.userInfo);
    [loadActivity startAnimating];
}
-(void)playbackFinished:(NSNotification *)notification{
    NSLog(@"视频播放完成.");
    _playerItem = [notification object];
    [_playerItem seekToTime:kCMTimeZero];
    [self pause];
}

#pragma mark - KVO - status
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if (isIntoBackground) {
            return;
        }else{
            if ([item status] == AVPlayerStatusReadyToPlay) {
                NSLog(@"AVPlayerStatusReadyToPlay");
                [self play];
                [loadActivity stopAnimating];
            }else if([item status] == AVPlayerStatusFailed) {
                NSLog(@"AVPlayerStatusFailed");
            }else{
                NSLog(@"AVPlayerStatusUnknown");
            }
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
    }else if (object == _playerItem && [keyPath isEqualToString:@"playbackBufferEmpty"])
    {
        if (_playerItem.playbackBufferEmpty) {
            //Your code here
            NSLog(@"bufer Empty---");
        }
    }
    
    else if (object == _playerItem && [keyPath isEqualToString:@"playbackLikelyToKeepUp"])
    {
        if (_playerItem.playbackLikelyToKeepUp)
        {
            //Your code here
            NSLog(@"keep   up");
            
        }
    }
    
}

- (NSTimeInterval)availableDurationRanges {
    NSArray *loadedTimeRanges = [_playerItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}
#pragma mark - 移除通知&KVO
- (void)removeObserverAndNotification{
    [_player replaceCurrentItemWithPlayerItem:nil];
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [_player removeTimeObserver:_playTimeObserver];
    _playTimeObserver = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setlandscapeLayout{
    self.isLandscape = YES;
    [self landscapeHide];
    
    self.frame=[UIScreen mainScreen].bounds;
    
    [self.totateBtn setImage:[UIImage imageNamed:@"MoviePlayer_小屏"] forState:UIControlStateNormal];
}

- (void)setPortraitLayout{
    self.isLandscape = NO;
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self portraitHide];
    self.frame=_oldFrame;
    
    [self.totateBtn setImage:[UIImage imageNamed:@"MoviePlayer_Full"] forState:UIControlStateNormal];
}

- (IBAction)rotationChanged:(id)sender {
    [self chickToolBar];
    if (isFull) {
        [UIDevice setOrientation:UIInterfaceOrientationPortrait];
        if (self.SuperVC!=nil) {
            [self.fullVC dismissViewControllerAnimated:NO completion:^{
                
                [_oldView addSubview:self];
                [self setPortraitLayout];
                
            }];
        }else{
            [self setPortraitLayout];
        }
        isFull=NO;
        
    }else{
        [UIDevice setOrientation:UIInterfaceOrientationLandscapeRight];
        if (_SuperVC!=nil) {
            [_SuperVC presentViewController:self.fullVC animated:NO completion:^{
                [self.fullVC.view addSubview:self];
                [self setlandscapeLayout];
                
            }];
        }else{
            [self setlandscapeLayout];
        }
        isFull=YES;
        
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchBegan");
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchEnd");
    if (self.isLandscape) {
        if (isShowToolbar) {
            [self landscapeHide];
        }else{
            [self landscapeShow];
        }
    }else{
        if (isShowToolbar) {
            [self portraitHide];
        }else{
            [self portraitShow];
        }
    }
    
}


- (void)portraitShow{
    isShowToolbar = YES;
    self.totateBtn.hidden = NO;
    self.topView.hidden = NO;
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:5]; //fireDate
    [_timer invalidate];
    _timer = nil;
    _timer = [[NSTimer alloc] initWithFireDate:date interval: 1 target:self selector:@selector(portraitHide) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)chickToolBar{
    if (self.isLandscape) {
        [self landscapeShow];
    }else{
        [self portraitShow];
    }
}

- (void)portraitHide{
    isShowToolbar = NO;
    self.totateBtn.hidden=YES;
    self.topView.hidden = YES;
    
}

- (void)landscapeShow{
    isShowToolbar = YES;
    self.totateBtn.hidden = NO;
    self.topView.hidden = NO;
    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:5]; //fireDate
    [_timer invalidate];
    _timer = nil;
    _timer = [[NSTimer alloc] initWithFireDate:date interval: 1 target:self selector:@selector(landscapeHide) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)landscapeHide{
    isShowToolbar = NO;
    self.totateBtn.hidden = YES;
    self.topView.hidden = YES;
    
//    if (self.isLandscape) {
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//    }
}

- (void)play{
    _isPlaying = YES;
    [_player play];
    if (!self.link) {
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(upadte)];//和屏幕频率刷新相同的定时器
        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
}
//刷新，看播放是否卡顿
- (void)upadte
{
    NSTimeInterval current = CMTimeGetSeconds(_player.currentTime);
    if (current == self.lastTime) {
        //卡顿
        [loadActivity startAnimating];
    }else{//没有卡顿
        [loadActivity stopAnimating];
    }
    self.lastTime = current;
}

- (void)pause{
    _isPlaying = NO;
    [_player pause];
}

- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}
-(WSFullViewController*)fullVC
{
    if (_fullVC==nil) {
        _fullVC=[[WSFullViewController alloc]init];
    }
    return _fullVC;
}

- (IBAction)backAction:(id)sender {
    if (isFull) {
        [UIDevice setOrientation:UIInterfaceOrientationPortrait];
        if (self.SuperVC!=nil) {
            [self.fullVC dismissViewControllerAnimated:NO completion:^{
                
                [_oldView addSubview:self];
                [self setPortraitLayout];
                
            }];
        }else{
            [self setPortraitLayout];
        }
        isFull=NO;
        
    }else{
        
        //返回上一页
        if (_block != nil) {
            
            _block(@"返回的Block");
        }
        
    }
}


//因为想要手动旋转，所以先关闭自动旋转
- (BOOL)shouldAutorotate{
    return NO;
}


@end
