//
//  BannerModel.h
//  视屏直播
//
//  Created by iMac on 17/2/14.
//  Copyright © 2017年 zws. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerModel : NSObject

/**
 *  游戏ID
 */
@property (nonatomic, strong) NSString *gameId;

/**
 *  ID
 */
@property (nonatomic, strong) NSString *ID;

/**
 *  房间ID
 */
@property (nonatomic, strong) NSString *roomId;

/**
 *  图片
 */
@property (nonatomic, strong) NSString *spic;

/**
 *  名称
 */
@property (nonatomic, strong) NSString *title;

/**
 *  网址
 */
@property (nonatomic, strong) NSString *url;

/**
 *  房间信息（字典）
 */
@property (nonatomic, strong) NSDictionary *room;


/*
 
 {
    "id": "13069",
    "roomId": "5331",
    "spic": "https://img2.zhanqi.tv/uploads/2017/02/recommendspic-2017021100134365181.png",
    "title": "炉石欧洲冬季赛",
    "gameId": "0",
    "url": "/topic/baoxuetv",
    "room": {
        "id": "5331",
        "uid": "100237059",
        "url": "/topic/baoxuetv",
        "code": "99109",
        "flashvars": null
    }
 }
 
 */


@end
