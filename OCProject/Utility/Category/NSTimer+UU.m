//
//  NSTimer+UU.m
//  OCProject
//
//  Created by Pan on 2020/9/18.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "NSTimer+UU.h"

@implementation NSTimer (UU)

+ (NSTimer *)timerExtensionInterval:(NSTimeInterval)interval repaat:(BOOL)repeat action:(void (^)(void))block {
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(timerAction:) userInfo:block repeats:repeat];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    return timer;
}

+ (void)timerAction:(NSTimer *)timer {
    void (^block)(void) = timer.userInfo;
    if (block) block();
}

@end
