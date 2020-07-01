//
//  UUAdvertisementModel.m
//  OCProject
//
//  Created by Pan on 2020/7/1.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUAdvertisementModel.h"
#import <MJExtension/MJExtension.h>

@implementation UUAdvertisementModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"imgID":@"id"};
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        [self mj_decode:aDecoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self mj_encode:aCoder];
}

@end
