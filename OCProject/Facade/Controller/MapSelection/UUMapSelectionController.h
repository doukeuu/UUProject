//
//  UUMapSelectionController.h
//  OCProject
//
//  Created by Pan on 2020/8/3.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUMapSelectionController : UIViewController

/// 起点纬度
@property (nonatomic, assign) CGFloat startLatitude;
/// 起点经度
@property (nonatomic, assign) CGFloat startLongitude;
/// 起点位置
@property (nonatomic, assign) NSString *startPosition;
/// 终点纬度
@property (nonatomic, assign) CGFloat endLatitude;
/// 终点经度
@property (nonatomic, assign) CGFloat endLongitude;
/// 终点位置
@property (nonatomic, assign) NSString *endPosition;
@end

NS_ASSUME_NONNULL_END
