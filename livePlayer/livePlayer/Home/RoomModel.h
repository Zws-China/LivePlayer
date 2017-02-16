//
//  RoomModel.h
//  视屏直播
//
//  Created by iMac on 17/2/14.
//  Copyright © 2017年 zws. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomModel : NSObject


@property (nonatomic, strong) NSString *code;

@property (nonatomic, strong) NSString *flashvars;

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *uid;

@property (nonatomic, strong) NSString *url;


/*
 
 {
 "id": "5331",
 "uid": "100237059",
 "url": "/topic/baoxuetv",
 "code": "99109",
 "flashvars": null
 }
 */

@end
