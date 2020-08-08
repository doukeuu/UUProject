//
//  UUImageClippingController.h
//  OCProject
//
//  Created by Pan on 2020/6/30.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUImageClippingController : UIViewController

/// 原始图片
@property (nonatomic, strong) UIImage *originalImage;
/// 剪切尺寸
@property (nonatomic, assign) CGRect cropFrame;
/// 缩放比例
@property (nonatomic, assign) CGFloat limitRatio;
/// 响应回调，取消则返回nil，完成则返回编辑后图片
@property (nonatomic, copy) void(^clippingCompletion)(UIImage * _Nullable editedImage);
@end

NS_ASSUME_NONNULL_END
