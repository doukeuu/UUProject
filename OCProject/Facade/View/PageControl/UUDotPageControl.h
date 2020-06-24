//
//  UUDotPageControl.h
//  OCProject
//
//  Created by Pan on 2020/6/24.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUDotPageControl : UIPageControl

@property (nonatomic, assign) CGSize pointSize;      // 点的尺寸
@property (nonatomic, strong) UIImage *currentImage; // 选中的点图片
@property (nonatomic, strong) UIImage *defaultImage; // 未选中点图片
@end

NS_ASSUME_NONNULL_END
