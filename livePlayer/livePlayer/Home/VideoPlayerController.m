//
//  VideoPlayerController.m
//  视屏直播
//
//  Created by iMac on 17/2/15.
//  Copyright © 2017年 zws. All rights reserved.
//

#import "VideoPlayerController.h"
#import "WSPlayer.h"


#define VIDEO_URL @"http://dlhls.cdn.zhanqi.tv/zqlive/"
#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface VideoPlayerController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) id popGestureDelegate;

@end

@implementation VideoPlayerController {
    WSPlayer*player;
    UIImageView *imgV;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatPlayer];//创建播放器
    
    self.popGestureDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    UIPanGestureRecognizer *popPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.popGestureDelegate action:action];
    popPanGesture.maximumNumberOfTouches = 1;
    popPanGesture.delegate = self;
    [self.view addGestureRecognizer: popPanGesture];

}

- (void)creatPlayer {
    NSString *urlString = [NSString stringWithFormat:@"%@%@.m3u8",VIDEO_URL , self.videoID];
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    player=[[WSPlayer alloc]initWithFrame:CGRectMake(0, 0, WIDTH,9.0*WIDTH/16.0)];
    player.titleString = self.videoTitle;
    [player updatePlayerWith:[NSURL URLWithString: urlString]];
    [player showInSuperView:self.view andSuperVC:self];
    
    __weak typeof(self) weakSelf = self;
    [player setBlock:^void (NSString *text){
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];

    
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // Prevent Pan Gesture From Right To Left
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) return NO;
    
    // Root View Controller Can Not Begin The Pop Gesture
    if (self.navigationController.viewControllers.count <= 1) return NO;
    
    return YES;
}


//
//-(UIImage *)thumbnailImageRequest:(CGFloat )timeBySecond{   //截取视图某一秒的图片
//    //创建URL
//    NSString *urlString = @"http://120.25.226.186:32812/resources/videos/minion_01.mp4";
//    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url=[NSURL URLWithString:urlString];
//    //根据url创建AVURLAsset
//    AVURLAsset *urlAsset=[AVURLAsset assetWithURL:url];
//    //根据AVURLAsset创建AVAssetImageGenerator
//    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
//    /*截图
//     * requestTime:缩略图创建时间
//     * actualTime:缩略图实际生成的时间
//     */
//    NSError *error=nil;
//    CMTime time=CMTimeMakeWithSeconds(timeBySecond, 10);//CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
//    CMTime actualTime;
//    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
//    if(error){
//        NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
//        return nil;
//    }
//    CMTimeShow(actualTime);
//    UIImage *image=[UIImage imageWithCGImage:cgImage];//转化为UIImage
//    
//    return image;
//}
//


//因为想要手动旋转，所以先关闭自动旋转
- (BOOL)shouldAutorotate{
    return NO;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

@end
