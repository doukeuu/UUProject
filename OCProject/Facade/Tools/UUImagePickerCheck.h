//
//  UUImagePickerCheck.h
//  OCProject
//
//  Created by Pan on 2020/6/10.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUImagePickerCheck : NSObject

/// 摄像头是否可用
+ (BOOL) isCameraAvailable;
/// 后置摄像头是否可用
+ (BOOL) isRearCameraAvailable;
/// 前置摄像头是否可用
+ (BOOL) isFrontCameraAvailable;
/// 拍照是否支持直接获取照片
+ (BOOL) doesCameraSupportTakingPhotos;

/// 相册是否可用
+ (BOOL) isPhotoLibraryAvailable;
/// 是否能够从相册获取视频
+ (BOOL) canUserPickVideosFromPhotoLibrary;
/// 是否能够从相册获取相片
+ (BOOL) canUserPickPhotosFromPhotoLibrary;
@end

NS_ASSUME_NONNULL_END
