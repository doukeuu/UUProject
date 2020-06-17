//
//  UULocationGeocode.m
//  OCProject
//
//  Created by Pan on 2020/6/10.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UULocationGeocode.h"

@interface UULocationGeocode () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *manager; // 定位管理类
@property (nonatomic, strong) CLGeocoder *geocoder;       // 地理编码类
@property (nonatomic, copy) LocationBlock locationBlock;  // 定位回调
@end

@implementation UULocationGeocode

// 是否能够定位，以及是否需要弹出提示
+ (BOOL) locationEnabledAndPrompted:(BOOL)prompted {
    
    if (![CLLocationManager locationServicesEnabled]) {
        if (prompted) [self showAlertForLocationDisabled];
        return NO;
    }
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedAlways) return YES;
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) return YES;
    
    if (status == kCLAuthorizationStatusRestricted) {
        if (prompted) [self showAlertForStatusRestricted];
    } else if (status == kCLAuthorizationStatusDenied) {
        if (prompted) [self showAlertForStatusDenied];
    }
    return NO;
}

// 定位后回调
- (void)location:(LocationBlock)block {
    self.locationBlock = block;
    [self.manager startUpdatingLocation];
}

// 反地理编码后回调
- (void)reverseGeocode:(CLLocation *)location completed:(GeocodeBlock)block {
    
    if (!location) return;
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error) {
            if (block) block(nil, error);
            return ;
        }
        CLPlacemark *placemark = [placemarks firstObject];
        if (block) block(placemark, nil);
    }];
}

// 定位并反地理编码之后回调
- (void)locationAndReverseGeocode:(GeocodeBlock)block {
    
    __weak typeof(self) weakSelf = self;
    [self location:^(CLLocation *location, BOOL *stop, NSError *error) {
        if (error) {
            if (block) block(nil, error);
            return;
        }
        *stop = YES;
        [weakSelf reverseGeocode:location completed:block];
    }];
}

// 地理编码后回调
- (void)geocodeAddress:(NSString *)address completed:(GeocodeBlock)block {
    
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error) {
            if (block) block(nil, error);
            return ;
        }
        CLPlacemark *placemark = [placemarks firstObject];
        if (block) block(placemark, nil);
    }];
}


#pragma mark - Property Getter

- (CLLocationManager *)manager {
    
    if (_manager) return _manager;
    _manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_manager requestWhenInUseAuthorization];
    }
    return _manager;
}

- (CLGeocoder *)geocoder {
    
    if (_geocoder) return _geocoder;
    _geocoder = [[CLGeocoder alloc] init];
    return _geocoder;
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    if (self.locationBlock) {
        BOOL stop = NO;
        CLLocation *currentLocation = [locations firstObject];
        self.locationBlock(currentLocation, &stop, nil);
        if (stop) [manager stopUpdatingLocation];
    } else {
        [manager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if (self.locationBlock) {
        BOOL stop = NO;
        self.locationBlock(nil, &stop, error);
        if (stop) [manager stopUpdatingLocation];
    } else {
        [manager stopUpdatingLocation];
    }
}


#pragma mark - Alert

// 无法定位时弹出的提示
+ (void)showAlertForLocationDisabled {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位提示" message:@"无法启用定位，请检查是否关闭了手机定位功能" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

// 定位被限制时弹出的提示
+ (void)showAlertForStatusRestricted {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位提示" message:@"定位功能被限制，暂时无法使用" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

// 定位被拒绝时弹出的提示
+ (void)showAlertForStatusDenied {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位提示" message:@"定位功能被拒绝，请在设置中修改定位权限" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    }];
    [alert addAction:okAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
