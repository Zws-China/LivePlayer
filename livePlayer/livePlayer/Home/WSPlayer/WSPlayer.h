//
//  WSPlayer.h
//  视屏直播
//
//  Created by iMac on 17/2/16.
//  Copyright © 2017年 zws. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>



typedef void(^ReturnBlock)(NSString *text);



@interface WSPlayer : UIView

@property(nonatomic,copy)ReturnBlock block;


/**
 *  AVPlayer播放器
 */
@property (nonatomic, strong) AVPlayer *player;
/**
 *  播放状态，YES为正在播放，NO为暂停
 */
@property (nonatomic, assign) BOOL isPlaying;
/**
 *  是否横屏，默认NO -> 竖屏
 */
@property (nonatomic, assign) BOOL isLandscape;

/**
 *  传入视频地址
 *
 *   string 视频url
 */
- (void)updatePlayerWith:(NSURL *)url;


/**
 *  视屏标题
 */
@property (nonatomic, strong) NSString *titleString;




/**
 *  移除通知&KVO
 */
- (void)removeObserverAndNotification;

/**
 *  横屏Layout
 */
- (void)setlandscapeLayout;

/**
 *  竖屏Layout
 */
- (void)setPortraitLayout;

/**
 *  播放
 */
- (void)play;

/**
 *  暂停
 */
- (void)pause;
/**
 *在父视图显示
 */
-(void)showInSuperView:(UIView*)SuperView andSuperVC:(UIViewController*)SuperVC;


@end
