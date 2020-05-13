//
//  UIButton+UU.m
//  OCProject
//
//  Created by Pan on 2020/5/13.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UIButton+UU.h"

@implementation UIButton (UU)

// 重新设置 image 及 title 的位置及间距
- (void)resetImageTitlePosition:(ButtonImageTitlePosition)position space:(CGFloat)space {    
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat titleWidth = 0.0;
    CGFloat titleHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        titleWidth = self.titleLabel.intrinsicContentSize.width;
        titleHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        titleWidth = self.titleLabel.frame.size.width;
        titleHeight = self.titleLabel.frame.size.height;
    }
    
    switch (position) {
        case ButtonImageTopTitleDown: {
            self.imageEdgeInsets = UIEdgeInsetsMake(-titleHeight-space, 0, 0, -titleWidth);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space, 0);
        } break;
        case ButtonImageLeftTitleRight: {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            self.titleEdgeInsets = UIEdgeInsetsMake(4, space/2.0, 0, -space/2.0);
        } break;
        case ButtonImageDownTitleTop: {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, -titleHeight-space, -titleWidth);
            self.titleEdgeInsets = UIEdgeInsetsMake(-imageHeight-space, -imageWith, 0, 0);
        } break;
        case ButtonImageRightTitleLeft: {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth+space/2.0, 0, -titleWidth-space/2.0);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        } break;
    }
}

@end
