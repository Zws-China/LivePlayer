//
//  WSPlayer.h
//  视屏直播
//
//  Created by iMac on 17/2/16.
//  Copyright © 2017年 zws. All rights reserved.
//


#import "WSFullViewController.h"

@interface WSFullViewController ()

@end

@implementation WSFullViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}



//因为想要手动旋转，所以先关闭自动旋转
- (BOOL)shouldAutorotate{
    return NO;
}
@end
