//
//  UIButton+UU.h
//  OCProject
//
//  Created by Pan on 2020/5/13.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ButtonImageTitlePosition) {
    ButtonImageTopTitleDown,   // image在上，title在下
    ButtonImageLeftTitleRight, // image在左，title在右
    ButtonImageDownTitleTop,   // image在下，title在上
    ButtonImageRightTitleLeft  // image在右，title在左
};


@interface UIButton (UU)

/// 重新设置 image 及 title 的位置及间距
- (void)resetImageTitlePosition:(ButtonImageTitlePosition)position space:(CGFloat)space;
@end

NS_ASSUME_NONNULL_END
