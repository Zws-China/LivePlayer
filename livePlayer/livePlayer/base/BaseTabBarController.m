//
//  BaseTabBarController.m
//  视屏直播
//
//  Created by iMac on 17/2/14.
//  Copyright © 2017年 zws. All rights reserved.
//

#import "BaseTabBarController.h"
#import "HomeController.h"
#import "LiveController.h"
#import "GameController.h"
#import "MineController.h"




@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    HomeController *homePageVC = [[HomeController alloc]init];
    [self setOneChildController:homePageVC title:@"首页" nomarlImage:@"tabbar_home" selectedImage:@"tabbar_home_sel"];
    LiveController *liveVC = [[LiveController alloc]init];
    [self setOneChildController:liveVC title:@"直播" nomarlImage:@"tabbar_room" selectedImage:@"tabbar_room_sel"];
    GameController *gameVC = [[GameController alloc]init];
    [self setOneChildController:gameVC title:@"游戏" nomarlImage:@"tabbar_game" selectedImage:@"tabbar_game_sel"];
    MineController *mineVC = [[MineController alloc]init];
    [self setOneChildController:mineVC title:@"我的" nomarlImage:@"tabbar_me" selectedImage:@"tabbar_me_sel"];
    
    
}
- (void)setOneChildController:(UIViewController *)vc title:(NSString *)title nomarlImage:(NSString *)nomarlImage selectedImage:(NSString *)selectedImage{
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:nomarlImage];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    nav.navigationBar.barTintColor = [UIColor colorWithRed:((0x589FF5 & 0xFF0000) >> 16)/255.0f green:((0x589FF5 & 0x00FF00) >> 8)/255.0f blue:(0x589FF5 & 0x0000FF)/255.0f alpha:1];

    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    [self addChildViewController:nav];
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}



@end
