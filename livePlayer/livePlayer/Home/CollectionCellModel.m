//
//  CollectionCellModel.m
//  视屏直播
//
//  Created by iMac on 17/2/14.
//  Copyright © 2017年 zws. All rights reserved.
//

#import "CollectionCellModel.h"

@implementation CollectionCellModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    if([key isEqualToString:@"id"])
        self.ID = value;
}


@end
