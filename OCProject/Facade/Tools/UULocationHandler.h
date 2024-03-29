//
//  UULocationHandler.h
//  OCProject
//
//  Created by Pan on 2020/7/31.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LocationBlock)(CLLocation * _Nullable location, BOOL *stop, NSError * _Nullable error);
typedef void(^GeocodeBlock)(CLPlacemark * _Nullable placemark, NSError * _Nullable error);

@interface UULocationHandler : NSObject

/// 是否能够定位，以及是否需要弹出提示
+ (BOOL)locationEnabledAndPrompted:(BOOL)prompted;
/// 定位后回调
+ (void)location:(LocationBlock)block;
/// 反地理编码后回调
+ (void)reverseGeocode:(CLLocation *)location completed:(GeocodeBlock)block;
/// 定位并反地理编码之后回调
+ (void)locationAndReverseGeocode:(GeocodeBlock)handler;
/// 地理编码后回调
+ (void)geocodeAddress:(NSString *)address completed:(GeocodeBlock)block;
@end

NS_ASSUME_NONNULL_END
