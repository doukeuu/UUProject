//
//  UUInteractiveTransition.m
//  OCProject
//
//  Created by Pan on 2020/6/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUInteractiveTransition.h"

@interface UUInteractiveTransition ()

@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@end

@implementation UUInteractiveTransition

- (instancetype)initWithPanGestureAddedController:(UIViewController *)controller {
    
    if (self = [super init]) {
        
        _isInterating = NO;
        _interactiveType = UUInteractiveTransitionTypePop;
        _direction = UUInteractiveTransitionDirectionDown;
        _controller = controller;
        
        [self configureGestureRecognizerView];
    }
    return self;
}

- (UIPanGestureRecognizer *)panGesture {
    
    if (_panGesture) return _panGesture;
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    return _panGesture;
}

// 配置手势识别视图
- (void)configureGestureRecognizerView {
    
    CGRect frame = self.controller.view.frame;
    UIView *panView = [[UIView alloc] init];
    frame.size.width = 48 * [UIScreen mainScreen].bounds.size.width / 640.0f;
    panView.frame = frame;
    panView.backgroundColor = [UIColor clearColor];
    [panView addGestureRecognizer:self.panGesture];
    [self.controller.view addSubview:panView];
}


#pragma mark - Touch Action

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan {
    
    CGFloat percent = 0.f;
    CGPoint translation = [pan translationInView:pan.view];
    
    switch (_direction) {
        case UUInteractiveTransitionDirectionUp:
            percent = -translation.y / pan.view.bounds.size.height;
            break;
        case UUInteractiveTransitionDirectionLeft:
            percent = -translation.x / pan.view.bounds.size.width;
            break;
        case UUInteractiveTransitionDirectionDown:
            percent = translation.y / pan.view.bounds.size.height;
            break;
        case UUInteractiveTransitionDirectionRight:
            percent = translation.x / pan.view.bounds.size.width;
            break;
        default:
            break;
    }
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            
            self.isInterating = YES;
            if (_interactiveType == UUInteractiveTransitionTypePop) {
                [self.controller.navigationController popViewControllerAnimated:YES];
            }
            break;
        case UIGestureRecognizerStateChanged:
            [self updateInteractiveTransition:percent];
            break;
        case UIGestureRecognizerStateEnded:
            
            if (percent > 0.3) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            self.isInterating = NO;
            break;
        default:
            break;
    }
}

- (void)dealloc {
    [self.panGesture removeTarget:self action:@selector(handlePanGesture:)];
}

@end
