//
//  UUSatisfactionDegreeView.m
//  OCProject
//
//  Created by Pan on 2020/9/19.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUSatisfactionDegreeView.h"

@interface UUSatisfactionDegreeView ()
{
    NSInteger _starAmount;   // 星星的总数量
    CALayer *_foreStarLayer; // 上面星星图层
    CALayer *_backStarLayer; // 下面星星图层
    UITapGestureRecognizer *_tapGesture; // 点击手势
}
@end

@implementation UUSatisfactionDegreeView

- (instancetype)init {
    if (self = [super init]) {
        _starAmount = 5;
        _scorePercent = 1;
        _allowIncompleteStar = NO;
        _isClickStar = NO;
        [self generateSubLayers];
    }
    return self;
}

#pragma mark - Property

// 得分值，0 ～ 1，默认 1
- (void)setScorePercent:(CGFloat)scorePercent {
    if (_scorePercent == scorePercent) return;
    if (scorePercent <= 0) {
        _scorePercent = 0;
    } else if (scorePercent >= 1) {
        _scorePercent = 1;
    } else {
        _scorePercent = scorePercent;
    }
    CGFloat width = _backStarLayer.bounds.size.width * _scorePercent;
    _foreStarLayer.frame = CGRectMake(0, 0, width, _backStarLayer.bounds.size.height);
}

// 是否可以点击星星评分 默认不可以NO
- (void)setIsClickStar:(BOOL)isClickStar {
    _isClickStar = isClickStar;
    _tapGesture.enabled = _isClickStar;
    [_foreStarLayer removeFromSuperlayer];
    [_backStarLayer removeFromSuperlayer];
    if (isClickStar == YES) {
        _backStarLayer = [self generateStarLayerWithImageName2:@"score_no"];
        _foreStarLayer = [self generateStarLayerWithImageName2:@"score_yes"];
    }else{
        _backStarLayer = [self generateStarLayerWithImageName:@"score_no"];
        _foreStarLayer = [self generateStarLayerWithImageName:@"score_yes"];
    }
}

#pragma mark - Subview

// 生成上下子图层
- (void)generateSubLayers {
    _backStarLayer = [self generateStarLayerWithImageName:@"score_no"];
    _foreStarLayer = [self generateStarLayerWithImageName:@"score_yes"];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStarView:)];
    _tapGesture.enabled = _isClickStar;
    [self addGestureRecognizer:_tapGesture];
}

// 生成星星图层
- (CALayer *)generateStarLayerWithImageName:(NSString *)imageName {
    if (!imageName || imageName.length == 0) return nil;
    UIImage *image = [UIImage imageNamed:imageName];
    if (!image) return nil;
    
    CGFloat starWidth = image.size.width;
    CGFloat starHeight = image.size.height;
    CALayer *starLayer = [[CALayer alloc] init];
    starLayer.frame = CGRectMake(0, 0, starWidth * _starAmount, starHeight);
    starLayer.masksToBounds = YES;
    [self.layer addSublayer:starLayer];
    
    for (NSInteger i = 0; i < _starAmount; i ++) {
        CALayer *imageLayer = [[CALayer alloc] init];
        imageLayer.frame = CGRectMake(i * starWidth, 0, starWidth, starHeight);
        imageLayer.contents = (id)image.CGImage;
        [starLayer addSublayer:imageLayer];
    }
    return starLayer;
}
// 生成大星星图层d
- (CALayer *)generateStarLayerWithImageName2:(NSString *)imageName {
    if (!imageName || imageName.length == 0) return nil;
    UIImage *image = [UIImage imageNamed:imageName];
    if (!image) return nil;
    
    CGFloat starWidth = image.size.width + 10;
    CGFloat starHeight = image.size.height + 10;
    CALayer *starLayer = [[CALayer alloc] init];
    starLayer.frame = CGRectMake(0, 0, (starWidth+12) * _starAmount, starHeight);
    starLayer.masksToBounds = YES;
    [self.layer addSublayer:starLayer];
    
    for (NSInteger i = 0; i < _starAmount; i ++) {
        CALayer *imageLayer = [[CALayer alloc] init];
        imageLayer.frame = CGRectMake(i * (starWidth+12), 0, starWidth, starHeight);
        imageLayer.contents = (id)image.CGImage;
        [starLayer addSublayer:imageLayer];
    }
    return starLayer;
}

#pragma mark - Respond

// 点击视图
- (void)tapStarView:(UIGestureRecognizer *)gesture {
    CGFloat offsetX = [gesture locationInView:self].x;
    CGFloat width = _backStarLayer.bounds.size.width;
    CGFloat realCount = offsetX / (width / _starAmount);
    CGFloat lastCount = _allowIncompleteStar ? realCount : ceil(realCount);
    self.scorePercent = lastCount / _starAmount;
}

@end
