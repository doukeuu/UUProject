//
//  UUVersionCheck.h
//  OCProject
//
//  Created by Pan on 2020/6/10.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUVersionCheck : NSObject

/// 检测是否通过AppStore审核
+ (void)checkForAppStoreAdopt;
/// 是否是更新后第一次打开App
+ (BOOL)isFirstLaunch;
/// 当前版本号
+ (NSString *)currentVersion;

/// 配置更新是否可选，默认不可选
+ (void)configUpdateOptional:(BOOL)isOptional;
/// 根据AppID检查更新
+ (void)checkUpdateWithAppID:(NSString *)appID;
/// 弹出更新提示框
+ (void)checkShouldShowAlert;
@end

NS_ASSUME_NONNULL_END
