//
//  HomeSectionModel.h
//  视屏直播
//
//  Created by iMac on 17/2/14.
//  Copyright © 2017年 zws. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionCellModel.h"


@interface HomeSectionModel : NSObject

@property (nonatomic, strong) NSString *keyword;

/**
 *  标题：热门直播
 */
@property (nonatomic, strong) NSString *title;

/**
 *  图片
 */
@property (nonatomic, strong) NSString *icon;


@property (nonatomic, strong) NSString *channelIds;
@property (nonatomic, strong) NSString *gameIds;
@property (nonatomic, strong) NSString *moreUrl;
@property (nonatomic, strong) NSString *nums;

/**
 *  列表
 */
@property (nonatomic, strong) NSArray *lists;

/*
 
 {
 "keyword": "index.livenow",
 "title": "热门直播",
 "icon": "https://img1.zhanqi.tv/uploads/2016/10/positionicon-2016101015054959054.png",
 "channelIds": "null",
 "gameIds": "null",
 "moreUrl": "/lives",
 "nums": "5",
 "anchors": [ ],
 "titlex": {
        "s": "热门",
        "e": "直播"
        },
 
 "lists": [
         {
             "id": "114653",
             "uid": "108892673",
             "nickname": "墨战",
             "gender": "2",
             "avatar": "https://img2.zhanqi.tv/avatar/93/c5b/108892673_1460960284.jpg",
             "code": "11527463",
             "url": "/11527463",
             "title": "墨战：信仰男刀 高端局高胜率C 今天迟到了",
             "gameId": "6",
             "spic": "https://img2.zhanqi.tv/live/20170215/114653_dybDr_2017-02-15-10-16-32.jpg",
             "bpic": "https://img2.zhanqi.tv/live/20170215/114653_dybDr_2017-02-15-10-16-32_big.jpg",
             "online": "25496",
             "status": "4",
             "hotsLevel": "20",
             "videoId": "114653_dybDr",
             "verscr": "0",
             "gameName": "英雄联盟",
             "gameUrl": "/games/lol",
             "highlight": 0,
             "fireworks": "",
             "fireworksHtml": ""
         },
         {
             "id": "46397",
             "uid": "22378685",
             "nickname": "鹏鹏博士",
             "gender": "2",
             "avatar": "https://img2.zhanqi.tv/avatar/68/42c/22378685_1477491442.jpg",
             "code": "1151872",
             "url": "/lipeng",
             "title": "一年有365个日出我送你365个祝福！",
             "gameId": "9",
             "spic": "https://img2.zhanqi.tv/live/20170215/46397_h7QoS_2017-02-15-10-16-18.jpg",
             "bpic": "https://img2.zhanqi.tv/live/20170215/46397_h7QoS_2017-02-15-10-16-18_big.jpg",
             "online": "8571",
             "status": "4",
             "hotsLevel": "26",
             "videoId": "46397_h7QoS",
             "verscr": "0",
             "gameName": "炉石传说",
             "gameUrl": "/games/how",
             "highlight": 0,
             "fireworks": "",
             "fireworksHtml": ""
         },
         {
             "id": "111027",
             "uid": "21798200",
             "nickname": "yzjp",
             "gender": "2",
             "avatar": "https://img2.zhanqi.tv/avatar/61/3f9/21798200_1456492922.jpg",
             "code": "11523837",
             "url": "/yzjp",
             "title": "无主之地1，逆袭的小吵闹",
             "gameId": "49",
             "spic": "https://img2.zhanqi.tv/live/20170215/111027_HymJZ_2017-02-15-10-16-56.jpg",
             "bpic": "https://img2.zhanqi.tv/live/20170215/111027_HymJZ_2017-02-15-10-16-56_big.jpg",
             "online": "763",
             "status": "4",
             "hotsLevel": "19",
             "videoId": "111027_HymJZ",
             "verscr": "0",
             "gameName": "单机游戏",
             "gameUrl": "/games/danji",
             "highlight": 0,
             "fireworks": "",
             "fireworksHtml": ""
         },
         {
             "id": "230",
             "uid": "10511",
             "nickname": "冰封解说",
             "gender": "2",
             "avatar": "https://img2.zhanqi.tv/avatar/99/113/10511_1482023249.jpg",
             "code": "213",
             "url": "/213",
             "title": "【冰封】除了吹比杂技，你，还会什么？",
             "gameId": "13",
             "spic": "https://img2.zhanqi.tv/live/20170215/230_Afs6t_2017-02-15-10-17-52.jpg",
             "bpic": "https://img1.zhanqi.tv/live/20170215/230_Afs6t_2017-02-15-10-17-52_big.jpg",
             "online": "17143",
             "status": "4",
             "hotsLevel": "31",
             "videoId": "230_Afs6t",
             "verscr": "0",
             "gameName": "三国杀",
             "gameUrl": "/games/sanguosha",
             "highlight": 0,
             "fireworks": "",
             "fireworksHtml": ""
         },
         {
             "id": "117486",
             "uid": "108002122",
             "nickname": "御龙狂人",
             "gender": "2",
             "avatar": "https://img2.zhanqi.tv/avatar/10/0df/108002122_1486915455.jpg",
             "code": "11530296",
             "url": "/11530296",
             "title": "狂人-1.80御龙合击传奇16点新区",
             "gameId": "35",
             "spic": "https://img2.zhanqi.tv/live/20170215/117486_JxT4U_2017-02-15-10-19-02.jpg",
             "bpic": "https://img2.zhanqi.tv/live/20170215/117486_JxT4U_2017-02-15-10-19-02_big.jpg",
             "online": "12016",
             "status": "4",
             "hotsLevel": "13",
             "videoId": "117486_JxT4U",
             "verscr": "0",
             "gameName": "传奇",
             "gameUrl": "/games/chuanqi",
             "highlight": 0,
             "fireworks": "",
             "fireworksHtml": ""
         }
     ]
 }
 
 
 */


@end
