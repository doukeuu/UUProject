//
//  UUToolsUI.h
//  OCProject
//
//  Created by Pan on 2020/6/10.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUToolsUI : NSObject

/// 查找当前界面控制器
+ (UIViewController *)topViewControllerFrom:(UIViewController *)controller;
@end

NS_ASSUME_NONNULL_END
