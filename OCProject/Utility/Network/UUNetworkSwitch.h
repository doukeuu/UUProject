//
//  UUNetworkSwitch.h
//  OCProject
//
//  Created by Pan on 2020/7/29.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUNetworkSwitch : NSObject

/// 检查并获取IP地址，为了AppStore审核
+ (void)checkForAppStoreReview;
@end

NS_ASSUME_NONNULL_END
