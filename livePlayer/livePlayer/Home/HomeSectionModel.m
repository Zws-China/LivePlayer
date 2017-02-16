//
//  HomeSectionModel.m
//  视屏直播
//
//  Created by iMac on 17/2/14.
//  Copyright © 2017年 zws. All rights reserved.
//

#import "HomeSectionModel.h"

@implementation HomeSectionModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"
             };
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"lists" : @"CollectionCellModel"
             };
}
@end
