//
//  UIView+SMScreenRecording.h
//  SMScreenRecording
//
//  Created by 朱思明 on 16/8/23.
//  Copyright © 2016年 朱思明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void(^FinishBlock) (NSError *error, NSString *videoPath);
typedef void(^FailureBlock) (NSError *error);

// 录屏保存位置
#define kMoviePath ([NSHomeDirectory() stringByAppendingPathComponent:@"Documents/screen.mp4"])

// 录屏倍数
#define kScreenScale ([UIScreen mainScreen].scale)

// 视频录制每秒的帧数
#define kFrames (20)


//#define kScreenScale 1
@interface UIView (SMScreenRecording)

/*
 *  开始录制屏幕
 *
 *  params: 指定视图的填充位置，可以录制指定区域
 */
- (void)startScreenRecordingWithCapInsets:(UIEdgeInsets) capInsets failureBlock:(FailureBlock) failureBlock;

/*
 *  停止录制屏幕
 *
 *  return: 视频地址
 */
- (void)endScreenRecordingWithFinishBlock:(FinishBlock) finishBlock;

@end
