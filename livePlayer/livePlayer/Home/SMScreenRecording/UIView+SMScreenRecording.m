//
//  UIView+SMScreenRecording.m
//  SMScreenRecording
//
//  Created by 朱思明 on 16/8/23.
//  Copyright © 2016年 朱思明. All rights reserved.
//

#import "UIView+SMScreenRecording.h"

#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

const void *screenRecording_inRect;
const void *screenRecording_timer;
const void *screenRecording_thread;
const void *screenRecording_videoWriter;
const void *screenRecording_writerInput;
const void *screenRecording_adaptor;
const void *screenRecording_failureBlock;
const void *screenRecording_queue;
// 记录录制帧数
static int frames_number = 1;

@implementation UIView (SMScreenRecording)

/*
 *  开始录制屏幕
 *
 *  params: 指定视图的填充位置，可以录制指定区域
 */
- (void)startScreenRecordingWithCapInsets:(UIEdgeInsets) capInsets failureBlock:(FailureBlock)failureBlock
{
    // 01 初始化帧数
    frames_number = 1;
    // 02 添加当前截取图片位置的属性
    CGRect inRect = CGRectMake(capInsets.left * kScreenScale, capInsets.top * kScreenScale, (self.frame.size.width - capInsets.left - capInsets.right) * kScreenScale, (self.frame.size.height - capInsets.top - capInsets.bottom) * kScreenScale);
    objc_setAssociatedObject(self, &screenRecording_inRect, [NSValue valueWithCGRect:inRect], OBJC_ASSOCIATION_RETAIN);
    // 03 移除路径里面的数据
    [[NSFileManager defaultManager] removeItemAtPath:kMoviePath error:NULL];
    // 04 视频转换设置
    NSError *error = nil;
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:kMoviePath]
                                                           fileType:AVFileTypeMPEG4
                                                              error:&error];

    NSParameterAssert(videoWriter);
    
    NSDictionary *videoSettings = @{AVVideoCodecKey: AVVideoCodecH264,
                                    AVVideoWidthKey: [NSNumber numberWithInt:inRect.size.width],
                                    AVVideoHeightKey: [NSNumber numberWithInt:inRect.size.height]};
    
    AVAssetWriterInput* writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                                         outputSettings:videoSettings];
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput
                                                                                                                     sourcePixelBufferAttributes:nil];
    // 05 保存属性
    objc_setAssociatedObject(self, &screenRecording_videoWriter, videoWriter, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, &screenRecording_writerInput, writerInput, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, &screenRecording_adaptor, adaptor, OBJC_ASSOCIATION_RETAIN);
    // 保存block
    objc_setAssociatedObject(self, &screenRecording_failureBlock, failureBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    [videoWriter addInput:writerInput];
    //Start a session:
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    // 06 创建写入队列
    dispatch_queue_t serial_queue = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);
    // 记录多线程队列
    objc_setAssociatedObject(self, &screenRecording_queue, serial_queue, OBJC_ASSOCIATION_RETAIN);
    // 06 创建多线程开启定时器
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(multiThreadingTask) object:nil];
    [thread start];
    // 记录多线程
    objc_setAssociatedObject(self, &screenRecording_thread, thread, OBJC_ASSOCIATION_RETAIN);
    
}

/*
 *  停止录制屏幕
 *
 *  FinishBlock: 错误信息，视频地址
 */
- (void)endScreenRecordingWithFinishBlock:(FinishBlock) finishBlock;
{
    // 01 通知多线程停止操作
    NSThread *thread = objc_getAssociatedObject(self, &screenRecording_thread);
    [self performSelector:@selector(threadend) onThread:thread withObject:nil waitUntilDone:YES];
    
    dispatch_queue_t serial_queue = objc_getAssociatedObject(self, &screenRecording_queue);
    dispatch_async(serial_queue, ^{
        AVAssetWriter *videoWriter = objc_getAssociatedObject(self, &screenRecording_videoWriter);
        AVAssetWriterInput *writerInput = objc_getAssociatedObject(self, &screenRecording_writerInput);
        
        [writerInput markAsFinished];
        
        [videoWriter finishWritingWithCompletionHandler:^{
            NSLog(@"Successfully closed video writer");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (videoWriter.status == AVAssetWriterStatusCompleted) {
                    NSLog(@"成功");
                    if (finishBlock != nil) {
                        finishBlock(nil, kMoviePath);
                    }
                } else {
                    NSLog(@"失败");
                    if (finishBlock != nil) {
                        NSError *error = [NSError errorWithDomain:@"录制失败" code:-1 userInfo:nil];
                        finishBlock(error, nil);
                    }
                }
                
                // 释放对象
                objc_setAssociatedObject(self, &screenRecording_videoWriter, nil, OBJC_ASSOCIATION_RETAIN);
                objc_setAssociatedObject(self, &screenRecording_writerInput, nil, OBJC_ASSOCIATION_RETAIN);
                objc_setAssociatedObject(self, &screenRecording_adaptor, nil, OBJC_ASSOCIATION_RETAIN);
                // 03 释放多线程
                objc_setAssociatedObject(self, &screenRecording_thread, nil, OBJC_ASSOCIATION_RETAIN);
                objc_setAssociatedObject(self, &screenRecording_queue, nil, OBJC_ASSOCIATION_RETAIN);
            });
        }];
    });
    
    
}

// 获取当前屏幕的截图图片
- (CGImageRef)getScreenRecordingImage
{
    // 01 获取当前视图的截图
//    UIGraphicsBeginImageContext(self.frame.size);
    // 判断是否为retina屏, 即retina屏绘图时有放大因子
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(self.bounds.size);
    }
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.frame.size.width * kScreenScale , self.frame.size.height * kScreenScale), YES,  kScreenScale);
//    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    // 02 修正当前图片的大小位置和尺寸
    CGRect inRect = [objc_getAssociatedObject(self, &screenRecording_inRect) CGRectValue];
    if ([NSStringFromCGRect(self.bounds) isEqualToString: NSStringFromCGRect(inRect)]) {
        return screenshotImage.CGImage;
    } else {
        CGImageRef newImageRef = CGImageCreateWithImageInRect(screenshotImage.CGImage, inRect);
        UIImage *newImage = [UIImage imageWithCGImage:newImageRef];//] scale:1.0 orientation:UIImageOrientationUp];
        // 释放对象
        CGImageRelease(newImageRef);
        return newImage.CGImage;
    }
    
}

// 图片转换成流视频对象
- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image{
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    
    CVPixelBufferRef pxbuffer = NULL;
    // 获取图片的大小
    CGFloat frameWidth = CGImageGetWidth(image);
    CGFloat frameHeight = CGImageGetHeight(image);
    // 转流设置
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          frameWidth,
                                          frameHeight,
                                          kCVPixelFormatType_32ARGB,
                                          (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pxdata,
                                                 frameWidth,
                                                 frameHeight,
                                                 8,
                                                 CVPixelBufferGetBytesPerRow(pxbuffer),
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    CGContextConcatCTM(context, CGAffineTransformIdentity);
    CGContextDrawImage(context, CGRectMake(0,
                                           0,
                                           frameWidth,
                                           frameHeight),
                       image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

#pragma mark - 多线程入口
- (void)multiThreadingTask
{
    @autoreleasepool {
        // 创建定时器
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / kFrames) target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        // 记录定时器
        objc_setAssociatedObject(self, &screenRecording_timer, timer, OBJC_ASSOCIATION_RETAIN);
        // 设置线程活跃
        [[NSRunLoop currentRunLoop] run];
    }
}

// 结束多线程和定时器
- (void)threadend
{
    // 01 关闭定时器
    NSTimer *timer = objc_getAssociatedObject(self, &screenRecording_timer);
    [timer invalidate];
    
    // 02 关闭runloop
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
    
}

// 定时器事件
- (void)timerAction:(NSTimer *)timer
{
    dispatch_queue_t serial_queue = objc_getAssociatedObject(self, &screenRecording_queue);
    dispatch_async(serial_queue, ^{
        @autoreleasepool {
            AVAssetWriterInputPixelBufferAdaptor *adaptor = objc_getAssociatedObject(self, &screenRecording_adaptor);
            NSLog(@"耗时开始");
            CGImageRef imageRef = [self getScreenRecordingImage]; // cpu 15
            //                      CVPixelBufferRef buffer = (CVPixelBufferRef)[self pixelBufferFromCGImage:imageRef size:inRect.size];
            NSLog(@"耗时图片1");
            CVPixelBufferRef buffer = [self pixelBufferFromCGImage:imageRef]; // cpu 15
            
            if (buffer) {
                if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frames_number, kFrames)]) {
                    NSLog(@"FAIL");
                    // 1.停止定时器
                    [timer invalidate];
                    AVAssetWriter *videoWriter = objc_getAssociatedObject(self, &screenRecording_videoWriter);
                    AVAssetWriterInput *writerInput = objc_getAssociatedObject(self, &screenRecording_writerInput);
                    [writerInput markAsFinished];
                    [videoWriter finishWritingWithCompletionHandler:^{
                        NSLog(@"Successfully closed video writer");
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 2.释放对象
                            objc_setAssociatedObject(self, &screenRecording_videoWriter, nil, OBJC_ASSOCIATION_RETAIN);
                            objc_setAssociatedObject(self, &screenRecording_writerInput, nil, OBJC_ASSOCIATION_RETAIN);
                            objc_setAssociatedObject(self, &screenRecording_adaptor, nil, OBJC_ASSOCIATION_RETAIN);
                            // 3.释放多线程
                            objc_setAssociatedObject(self, &screenRecording_thread, nil, OBJC_ASSOCIATION_RETAIN);
                            // 4.回调失败的block
                            FailureBlock failureBlock = objc_getAssociatedObject(self, &screenRecording_failureBlock);
                            if (failureBlock != Nil) {
                                NSError *error = [NSError errorWithDomain:@"录制失败" code:-1 userInfo:nil];
                                failureBlock(error);
                            }
                        });
                    }];
                    // 5.关闭runloop
                    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
                } else {
                    CFRelease(buffer);
                }
            }
            NSLog(@"耗时写入2");
            NSLog(@"%d",frames_number);
            // 帧数改变
            frames_number++;
        }
    });
    
}

@end
