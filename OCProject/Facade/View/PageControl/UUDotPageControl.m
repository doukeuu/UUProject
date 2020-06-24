//
//  UUDotPageControl.m
//  OCProject
//
//  Created by Pan on 2020/6/24.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUDotPageControl.h"

#define DOT_MARGIN 16

@interface UUDotPageControl ()
{
    CGSize _dotSize;       // 最后点的尺寸
    BOOL _numberIsEven;    // 点的个数是否是偶数
    NSInteger _halfNumber; // 点的个数一半
}
@end

@implementation UUDotPageControl

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    [super setNumberOfPages:numberOfPages];
    
    _halfNumber = numberOfPages / 2;
    _numberIsEven = numberOfPages % 2 == 0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self configureDotView];
}

// 配置点视图frame
- (void)configureDotView {
    
    if (self.subviews.count == 0) return;
    
    if (self.currentImage && self.defaultImage) {
        _dotSize = self.currentImage.size;
    } else {
        _dotSize = CGSizeMake(7, 7);
    }
    if (self.pointSize.width && self.pointSize.height) {
        _dotSize = self.pointSize;
    }
    
    for (NSInteger i = 0; i < self.subviews.count; i ++) {
        
        // 重新计算点的位置及大小
        UIView *view = [self.subviews objectAtIndex:i];
        CGFloat viewX;
        if (_numberIsEven) {
            viewX = self.bounds.size.width / 2 + (i - _halfNumber) * (_dotSize.width + DOT_MARGIN) + DOT_MARGIN / 2;
        } else {
            viewX = self.bounds.size.width / 2 + (i - _halfNumber) * (_dotSize.width + DOT_MARGIN) - _dotSize.width / 2;
        }
        CGFloat viewY = (self.bounds.size.height - _dotSize.height) / 2;
        view.frame = CGRectMake(viewX, viewY, _dotSize.width, _dotSize.height);
        
        // 点视图中添加图片视图
        if ((view.subviews.count == 0) && self.currentImage && self.defaultImage) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
            [view addSubview:imageView];
        }
        UIImageView *dotImageView = [view.subviews firstObject];
        if (i == self.currentPage) {
            if (self.currentImage) {
                dotImageView.image = self.currentImage;
                view.backgroundColor = [UIColor clearColor];
            } else {
                dotImageView.image = nil;
                view.backgroundColor = self.currentPageIndicatorTintColor;
                view.layer.cornerRadius = view.frame.size.height / 2;
            }
        } else {
            if (self.defaultImage) {
                dotImageView.image = self.defaultImage;
                view.backgroundColor = [UIColor clearColor];
            } else {
                dotImageView.image = nil;
                view.backgroundColor = self.pageIndicatorTintColor;
                view.layer.cornerRadius = view.frame.size.height / 2;
            }
        }
    }
}

@end
