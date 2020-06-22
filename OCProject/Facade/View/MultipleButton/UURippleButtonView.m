//
//  UURippleButtonView.m
//  OCProject
//
//  Created by Pan on 2020/6/22.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UURippleButtonView.h"

@interface UURippleButtonView ()

@property (nonatomic, strong) UIView *topLine; // 顶部分割线
@end

@implementation UURippleButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configureSubviews];
    }
    return self;
}

// 是否显示顶部分割线
- (void)setShowTopLine:(BOOL)showTopLine {
    if (_showTopLine == showTopLine) return;
    if (showTopLine) {
        [self configureTopLine];
    } else {
        if (_topLine) [_topLine removeFromSuperview];
    }
    _showTopLine = showTopLine;
}

// 动画展示视图
- (void)showAnimated {
    self.hidden = NO;
    [self viewAnimatedIn:YES completion:nil];
}

// 动画隐藏视图
- (void)hideAnimated {
    if (self.isHidden) return;
    __weak typeof(self) weakSelf = self;
    [self viewAnimatedIn:NO completion:^(BOOL finished) {
        weakSelf.hidden = YES;
    }];
}

#pragma mark - Configure Subview

// 配置子视图
- (void)configureSubviews {
    // 录音按钮
    CGRect frame = CGRectMake(self.bounds.size.width/2-45, self.bounds.size.height/2-45, 90, 90);
    _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _voiceButton.frame = frame;
    _voiceButton.layer.cornerRadius = frame.size.width/2;;
    [_voiceButton setImage:[UIImage imageNamed:@"voice_recorder"] forState:UIControlStateNormal];
    [_voiceButton addTarget:self action:@selector(voiceButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [_voiceButton addTarget:self action:@selector(voiceButtonTouchUpIn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_voiceButton];
    
    // 动画圆圈
    _circleLayer = [CALayer layer];
    _circleLayer.frame = frame;
    _circleLayer.cornerRadius = frame.size.width/2;
    _circleLayer.borderWidth = 1.f;
    _circleLayer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.layer insertSublayer:_circleLayer atIndex:0];
}

// 配置顶部分割线
- (void)configureTopLine {
    CGRect frame = CGRectMake(0, 0, self.bounds.size.width, 1);
    _topLine = [[UIView alloc] initWithFrame:frame];
    _topLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_topLine];
}

#pragma mark - Touch Action

// 按下按钮响应方法
- (void)voiceButtonTouchDown {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rippleButtonView:action:)]) {
        [self.delegate rippleButtonView:self action:UIControlEventTouchDown];
    }
    [self removeAnimationFromCircleLayer];
    [self addAnimationForCircleLayer];
}

// 按钮内抬起响应方法
- (void)voiceButtonTouchUpIn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rippleButtonView:action:)]) {
        [self.delegate rippleButtonView:self action:UIControlEventTouchUpInside];
    }
    [self removeAnimationFromCircleLayer];
}

#pragma mark - Animations

// 视图动画
- (void)viewAnimatedIn:(BOOL)animatedIn completion:(void(^)(BOOL finished))completion {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rippleButtonView:willShowOrHide:)]) {
        [self.delegate rippleButtonView:self willShowOrHide:animatedIn];
    }
    CGAffineTransform endTransform = CGAffineTransformIdentity;
    if (animatedIn) {
        self.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
        endTransform = CGAffineTransformMakeTranslation(0, 0);
    } else {
        endTransform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    }
    dispatch_block_t animationBlock = ^ {
        self.transform = endTransform;
    };
    [UIView animateWithDuration:0.3f delay:0.f usingSpringWithDamping:1.f initialSpringVelocity:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:animationBlock completion:completion];
}

// 添加圆圈动画
- (void)addAnimationForCircleLayer {
    CABasicAnimation *scale = [CABasicAnimation animation];
    scale.keyPath = @"transform.scale";
    scale.fromValue = @(1.f);
    scale.toValue = @(2.f);
    
    CABasicAnimation *opacity = [CABasicAnimation animation];
    opacity.keyPath = @"opacity";
    opacity.fromValue = @(1.f);
    opacity.toValue = @(0.f);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 1.f;
    group.repeatCount = HUGE_VALF;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.animations = @[scale, opacity];
    [_circleLayer addAnimation:group forKey:@"circle"];
}

// 删除圆圈动画
- (void)removeAnimationFromCircleLayer {
    [_circleLayer removeAnimationForKey:@"circle"];
}

@end
