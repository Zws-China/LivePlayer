//
//  UIDevice+JWDevice.m
//  FMGAVPlayerDemo
//
//  Created by jarvis on 2016/11/12.
//  Copyright © 2016年 FMG. All rights reserved.
//

#import "UIDevice+JWDevice.h"

@implementation UIDevice (JWDevice)
+ (void)setOrientation:(UIInterfaceOrientation)orientation {
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[self currentDevice]];
    int val = orientation;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
}
+ (BOOL)isOrientationLandscape {
    //if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return YES;
    } else {
        return NO;
    }
}

@end
