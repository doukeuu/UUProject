//
//  UUDeviceCheck.m
//  OCProject
//
//  Created by Pan on 2020/6/10.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUDeviceCheck.h"
#import <sys/utsname.h>

@implementation UUDeviceCheck

// 设备名称
+ (NSString*)deviceName {
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine
                                                 encoding:NSUTF8StringEncoding];
    // simulator
    if ([deviceString isEqualToString:@"x86_64"]) return @"Simulator";
    // iPhone
    if ([deviceString isEqualToString:@"iPhone4,1"])   return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])   return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])   return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])   return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])   return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])   return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])   return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])   return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])   return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])   return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])   return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,3"])   return @"iPhoneSE";
    if ([deviceString isEqualToString:@"iPhone8,4"])   return @"iPhoneSE";
    if ([deviceString isEqualToString:@"iPhone9,1"])   return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])   return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])  return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])  return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])  return @"iPhone X";
    // iPad
    if ([deviceString isEqualToString:@"iPad2,1"])  return @"iPad2";
    if ([deviceString isEqualToString:@"iPad2,2"])  return @"iPad2";
    if ([deviceString isEqualToString:@"iPad2,3"])  return @"iPad2";
    if ([deviceString isEqualToString:@"iPad2,4"])  return @"iPad2";
    if ([deviceString isEqualToString:@"iPad3,1"])  return @"iPad3";
    if ([deviceString isEqualToString:@"iPad3,2"])  return @"iPad3";
    if ([deviceString isEqualToString:@"iPad3,3"])  return @"iPad3";
    if ([deviceString isEqualToString:@"iPad3,4"])  return @"iPad4";
    if ([deviceString isEqualToString:@"iPad3,5"])  return @"iPad4";
    if ([deviceString isEqualToString:@"iPad3,6"])  return @"iPad4";
    if ([deviceString isEqualToString:@"iPad4,1"])  return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])  return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])  return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"])  return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])  return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad2,5"])  return @"iPad mini";
    if ([deviceString isEqualToString:@"iPad2,6"])  return @"iPad mini";
    if ([deviceString isEqualToString:@"iPad2,7"])  return @"iPad mini";
    if ([deviceString isEqualToString:@"iPad4,4"])  return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,5"])  return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,6"])  return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])  return @"iPad mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])  return @"iPad mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])  return @"iPad mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])  return @"iPad mini 4";
    if ([deviceString isEqualToString:@"iPad5,2"])  return @"iPad mini 4";
    
    return deviceString;
}

@end
