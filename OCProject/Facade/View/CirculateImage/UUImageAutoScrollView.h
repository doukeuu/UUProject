//
//  UUImageAutoScrollView.h
//  OCProject
//
//  Created by Pan on 2020/6/22.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUImageAutoScrollView : UIView

@property (nonatomic, assign) CGFloat marginH;     // 图片左右空白间距的一半
@property (nonatomic, assign) CGFloat marginV;     // 图片上下空白间距
@property (nonatomic, assign) CGFloat imageCorner; // 图片圆角
@property (nonatomic, assign) BOOL imageShadow;    // 图片是否显示阴影
@property (nonatomic, assign) CGFloat sideWidth;   // 左右两侧多显示的图片宽度
@property (nonatomic, assign) NSTimeInterval scrollDuration; // 滚动间隔时间

@property (nonatomic, strong) UIImage *placeholderImage;            // 占位图片
@property (nonatomic, strong) NSArray<NSString *> *imageURLArray;   // 图片地址数组
@property (nonatomic, copy) void(^tapImageAction)(NSInteger index); // 响应回调，没有图片返回-1
@end

NS_ASSUME_NONNULL_END
