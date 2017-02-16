//
//  HomeCycleView.h
//  视屏直播
//
//  Created by iMac on 17/2/14.
//  Copyright © 2017年 zws. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerModel.h"


@class HomeCycleView;
@protocol HomeCycleViewDelegate <NSObject>

- (void)homeCycleView:(HomeCycleView *)homeCycleView roomId:(NSString *)roomId roomTitle:(NSString *)title;

@end

@interface HomeCycleView : UICollectionReusableView


@property (nonatomic, strong) NSArray *photoDataArray;

/**
 *  名称：（竞技网游）
 */
@property (nonatomic, strong) NSString *titleDataString;


/**
 *  图片：（竞技网游前面的图片地址）
 */
@property (nonatomic, strong) NSString *imageUrl;

@property (nonatomic, weak) id<HomeCycleViewDelegate> delegate;



@end
