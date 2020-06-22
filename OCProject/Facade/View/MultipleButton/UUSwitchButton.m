//
//  UUSwitchButton.m
//  OCProject
//
//  Created by Pan on 2020/6/22.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUSwitchButton.h"
#import "UIView+UU.h"

#define duration     0.3
#define insetValue   (self.height*0.078*2)
#define myGreenColor [UIColor colorWithRed:62/255.f  green:180/255.f blue:84/255.f  alpha:1.f]
#define myGrayColor  [UIColor colorWithRed:134/255.f green:134/255.f blue:134/255.f alpha:1.f]

@interface UUSwitchButton ()

@property (assign, nonatomic) BOOL status;
@end

@implementation UUSwitchButton

- (void)setDefaultOn:(BOOL)defaultOn {
    _defaultOn = defaultOn;
    if (defaultOn) {
        self.status = YES;
        [self setBackgroundImage:[UIImage imageNamed:@"switchBtn_seleted"] forState:UIControlStateNormal];
    } else {
        self.status = NO;
        [self setBackgroundImage:[UIImage imageNamed:@"switchBtn_Noseleted"] forState:UIControlStateNormal];
    }
}

- (void)setOn:(BOOL)on {
    if (on) {
        if (!self.status) {
            [self setButtonOffToOn];
        }
    } else {
        if (self.status) {
            [self setButtonOnToOff];
        }
    }
}

- (BOOL)isOn {
    return self.status;
}

// 从开到关动画
- (void)setButtonOnToOff {
    self.status = NO;
    [self setBackgroundImage:[UIImage imageNamed:@"switchBtn_click"] forState:UIControlStateNormal];
    
    UIView *midView = [[UIView alloc] init];
    midView.frame = CGRectMake(insetValue, insetValue, self.width - 2*insetValue, self.height - 2*insetValue);
    midView.backgroundColor = myGreenColor;
    midView.layer.cornerRadius = (self.height - 2*insetValue)/2;
    midView.layer.masksToBounds = YES;
    [self addSubview:midView];
    
    [UIView animateWithDuration:duration animations:^{
        midView.width = self.height - 2*insetValue;
        midView.left = insetValue + self.width - 2*insetValue - (self.height - 2*insetValue);
    } completion:^(BOOL finished) {
        [self setBackgroundImage:[UIImage imageNamed:@"switchBtn_off"] forState:UIControlStateNormal];
        midView.backgroundColor = myGrayColor;
        
        [UIView animateWithDuration:duration animations:^{
            midView.left = insetValue;
        } completion:^(BOOL finished) {
            [self setBackgroundImage:[UIImage imageNamed:@"switchBtn_Noseleted"] forState:UIControlStateNormal];
            [midView removeFromSuperview];
        }];
    }];
}

// 设置从关到开动画
- (void)setButtonOffToOn {
    self.status = YES;
    [self setBackgroundImage:[UIImage imageNamed:@"switchBtn_off"] forState:UIControlStateNormal];
    
    UIView *midView = [[UIView alloc] init];
    midView.frame = CGRectMake(insetValue, insetValue, self.height - 2*insetValue, self.height - 2*insetValue);
    midView.backgroundColor = myGrayColor;
    midView.layer.cornerRadius = (self.height - 2*insetValue)/2;
    midView.layer.masksToBounds = YES;
    [self addSubview:midView];
    
    [UIView animateWithDuration:duration animations:^{
        midView.left = insetValue + self.width - 2*insetValue - (self.height - 2*insetValue);
    } completion:^(BOOL finished) {
        [self setBackgroundImage:[UIImage imageNamed:@"switchBtn_click"] forState:UIControlStateNormal];
        midView.backgroundColor = myGreenColor;
        
        [UIView animateWithDuration:duration animations:^{
            midView.width = self.width - 2*insetValue;
            midView.left = insetValue;
        } completion:^(BOOL finished) {
            [self setBackgroundImage:[UIImage imageNamed:@"switchBtn_seleted"] forState:UIControlStateNormal];
            [midView removeFromSuperview];
        }];
    }];
}

@end
