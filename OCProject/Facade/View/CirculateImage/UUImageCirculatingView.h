//
//  UUImageCirculatingView.h
//  OCProject
//
//  Created by Pan on 2020/6/22.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UUImageCirculatingViewDelegate <NSObject>
/// 点击图片时响应的代理方法
- (void)tapCirculatingImage:(UIImage *)image atIndex:(NSInteger)index;
@end


@interface UUImageCirculatingView : UIView

@property (nonatomic, strong) NSArray *imagesArray; // 图片数组
@property (nonatomic, assign) BOOL showsPageControl; // 是否显示分页控制器
@property (nonatomic, assign) NSTimeInterval autoScrollDelay; // 设定自动滚动时间间隔(>0.5s)
@property (nonatomic, assign) id<UUImageCirculatingViewDelegate> delegate; // 代理属性

/// 自定义初始化方法
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)placeholder;
@end

NS_ASSUME_NONNULL_END
