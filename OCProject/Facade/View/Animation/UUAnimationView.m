//
//  UUAnimationView.m
//  OCProject
//
//  Created by Pan on 2020/6/19.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUAnimationView.h"

@implementation UUAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.alpha = 0.0;
    }
    return self;
}

#pragma mark - Setter

// 弹出位置
- (void)setPopupPoint:(CGPoint)popupPoint {
    _popupPoint = popupPoint;
    [self updateBezelViewFrame];
}

// 弹出动画样式
- (void)setAnimationType:(UUAnimationType)animationType {
    _animationType = animationType;
    [self updateBezelViewFrame];
}

// 更新视图的Frame
- (void) updateBezelViewFrame {
    if (self.bezelView == nil) return;
    CGPoint anchor = CGPointZero;
    CGRect transformFrame = self.bezelView.frame;
    
    switch (self.animationType) {
        case UUAnimationPopFromTop: {
            anchor = CGPointMake(0.5, 0.5);
            transformFrame.origin = self.popupPoint;
        } break;
        case UUAnimationPopFromLeft: {
            anchor = CGPointMake(0.5, 0.5);
            CGFloat viewX = self.bounds.size.width - transformFrame.size.width;
            transformFrame.origin = CGPointMake(viewX - self.popupPoint.x, self.popupPoint.y);
        } break;
        case UUAnimationPopFromBottom: {
            anchor = CGPointMake(0.5, 0.5);
            CGFloat viewY = self.bounds.size.height - transformFrame.size.height;
            transformFrame.origin = CGPointMake(self.popupPoint.x, viewY - self.popupPoint.y);
        } break;
        case UUAnimationPopFromRight: {
            anchor = CGPointMake(0.5, 0.5);
            CGFloat viewX = self.bounds.size.width + transformFrame.size.width;
            transformFrame.origin = CGPointMake(viewX - self.popupPoint.x, self.popupPoint.y);
        } break;
        case UUAnimationScaleFromPoint: {
            anchor = CGPointZero;
            transformFrame.origin = self.popupPoint;
        } break;
        case UUAnimationScaleFromRightTop: {
            anchor = CGPointMake(1, 0);
            transformFrame.origin = self.popupPoint;
        } break;
    }
    self.bezelView.layer.anchorPoint = anchor;
    self.bezelView.frame = transformFrame;
}

#pragma mark - Animation

// 弹出视图
- (void) popViewAnimated {
    if (self.bezelView == nil) return;
    [self.bezelView.layer removeAllAnimations];
    [self animatedIn:YES completion:nil];
}

// 隐藏视图
- (void) hideViewAnimated {
    if (self.bezelView == nil) return;
    __weak typeof(self) weakSelf = self;
    [self animatedIn:NO completion:^(BOOL finished) {
        [weakSelf.bezelView removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

// 设置弹出和隐藏时动画
- (void)animatedIn:(BOOL)animatedIn completion:(void(^)(BOOL))completion {
    if (self.bezelView == nil) return;
    CGAffineTransform beginTransform = CGAffineTransformIdentity;
    CGAffineTransform endTransform = CGAffineTransformIdentity;
    switch (self.animationType) {
        case UUAnimationPopFromTop:
            beginTransform = CGAffineTransformMakeTranslation(0, -self.bezelView.bounds.size.height);
            endTransform = CGAffineTransformMakeTranslation(0, 0);
            break;
        case UUAnimationPopFromLeft:
            beginTransform = CGAffineTransformMakeTranslation(-self.bounds.size.width, 0);
            endTransform = CGAffineTransformMakeTranslation(0, 0);
            break;
        case UUAnimationPopFromBottom:
            beginTransform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
            endTransform = CGAffineTransformMakeTranslation(0, 0);
            break;
        case UUAnimationPopFromRight:
            beginTransform = CGAffineTransformMakeTranslation(self.bounds.size.width, 0);
            endTransform = CGAffineTransformMakeTranslation(0, 0);
            break;
        case UUAnimationScaleFromPoint:
            beginTransform = CGAffineTransformMakeScale(1, 0.0001);
            endTransform = CGAffineTransformMakeScale(1, 1);
            break;
        case UUAnimationScaleFromRightTop:
            beginTransform = CGAffineTransformMakeScale(0.1, 0.1);
            endTransform = CGAffineTransformMakeScale(1, 1);
            break;
    }
    // 开始时的动画设置
    if (animatedIn) {
        self.bezelView.transform = beginTransform;
    }
    // 结束时的动画设置
    __weak typeof(self) weakSelf = self;
    dispatch_block_t animations = ^{
        weakSelf.alpha = animatedIn ? 1.0 : 0.0;
        weakSelf.bezelView.transform = animatedIn ? endTransform : beginTransform;
    };
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:animations completion:completion];
}


@end
