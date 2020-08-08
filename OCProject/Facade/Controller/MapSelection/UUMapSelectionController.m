//
//  UUMapSelectionController.m
//  OCProject
//
//  Created by Pan on 2020/8/3.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUMapSelectionController.h"
#import "UUAlertTipsController.h"
#import "UIView+UU.h"
#import "UUToolsUI.h"

@interface UUMapSelectionController ()

@property (nonatomic, strong) UIView *bezelView; // 弹框视图
@end

@implementation UUMapSelectionController

- (instancetype)init {
    if (self = [super init]) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [COLOR_HEX(0x030303) colorWithAlphaComponent:0.5];
    [self generateSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self popupBezelViewAnimatedIn:YES completion:nil];
}

#pragma mark - Subviews

// 生成子视图
- (void)generateSubviews {
    // 弹框视图
    CGRect rect = CGRectMake(0, SCREEN_HEIGHT - 189 - BOTTOM_SAFE_AREA, SCREEN_WIDTH, 189 + BOTTOM_SAFE_AREA);
    _bezelView = [[UIView alloc] initWithFrame:rect];
    _bezelView.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:_bezelView];
    
    // 圆角蒙版
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:_bezelView.bounds
                                                     byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                           cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = _bezelView.bounds;
    shapeLayer.path = bezierPath.CGPath;
    _bezelView.layer.mask = shapeLayer;
    
    // 百度导航按钮
    UIButton *baiduButton = [self generalButton:@"百度导航" tag:0];
    baiduButton.frame = CGRectMake(0, 0, _bezelView.width, 62);
    
    // 高德导航按钮
    UIButton *gaodeButton = [self generalButton:@"高德导航" tag:1];
    gaodeButton.frame = CGRectMake(0, baiduButton.bottom + 1, _bezelView.width, 62);
    
    // 取消按钮
    UIButton *cancelButton = [self generalButton:@"取   消" tag:2];
    cancelButton.frame = CGRectMake(0, gaodeButton.bottom + 1, _bezelView.width, 62);
    
    // 底部空白
    rect = CGRectMake(0, cancelButton.bottom + 1, _bezelView.width, BOTTOM_SAFE_AREA);
    UIView *bottomView = [[UIView alloc] initWithFrame:rect];
    bottomView.backgroundColor = UIColor.whiteColor;
    [_bezelView addSubview:bottomView];
    
    // 添加手势
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blankViewTapped:)]];
}

// 生成按钮
- (UIButton *)generalButton:(NSString *)title tag:(NSInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = UIColor.whiteColor;
    button.tag = tag;
    button.titleLabel.font = FONT(16);
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.bezelView addSubview:button];
    return button;
}

#pragma mark - Respond

// 点击空白视图
- (void)blankViewTapped:(UIGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.view];
    if (CGRectContainsPoint(_bezelView.frame, point)) return;
    [self popupBezelViewAnimatedIn:NO completion:nil];
}

// 点击按钮
- (void)clickButton:(UIButton *)button {
    [self popupBezelViewAnimatedIn:NO completion:^{
        NSInteger tag = button.tag;
        if (tag == 0) {
            [self transferToBaiduMap];
        } else if (tag == 1) {
            [self transferToAMap];
        }
    }];
}

#pragma mark - Animation

// 展示动画
- (void)popupBezelViewAnimatedIn:(BOOL)animatedIn completion:(void(^ _Nullable)(void))completion {
    CGAffineTransform beginTransform = CGAffineTransformMakeTranslation(0, self.bezelView.bounds.size.height);
    CGAffineTransform endTransform = CGAffineTransformMakeTranslation(0, 0);
    if (animatedIn) {
        self.bezelView.transform = beginTransform;
    }
    dispatch_block_t block = ^{
        self.bezelView.transform = animatedIn ? endTransform : beginTransform;
    };
    void(^complete)(BOOL) = ^(BOOL finished){
        if (!animatedIn) [self dismissViewControllerAnimated:NO completion:completion];
    };
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:block completion:complete];
}

#pragma mark - Navigation

// 跳转到百度导航
- (void)transferToBaiduMap {
    NSURL *checkUrl = [NSURL URLWithString:@"baidumap://"];
    if (![[UIApplication sharedApplication] canOpenURL:checkUrl]) {
        [self showAlertWithName:@"百度地图"];
        return;
    }
    NSString *baiduUrlStr = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:%@\
                             &destination=latlng:%f,%f|name:%@\
                             &coord_type=gcj02&mode=driving&src=com.yimaokeji.customer",
                             self.startLatitude, self.startLongitude, self.startPosition,
                             self.endLatitude, self.endLongitude, self.endPosition];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    baiduUrlStr = [baiduUrlStr stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSURL *baiduUrl = [NSURL URLWithString:baiduUrlStr];
    [[UIApplication sharedApplication] openURL:baiduUrl options:@{} completionHandler:nil];
}

// 跳转到高德地图
- (void)transferToAMap {
    NSURL *checkUrl = [NSURL URLWithString:@"iosamap://"];
    if (![[UIApplication sharedApplication] canOpenURL:checkUrl]) {
        [self showAlertWithName:@"高德地图"];
        return;
    }
    NSString *amapUrlStr = [NSString stringWithFormat:@"iosamap://path?sourceApplication=com.yimaokeji.customer\
                            &sid=userLocation&slat=%f&slon=%f&sname=%@\
                            &did=shopLocation&dlat=%f&dlon=%f&dname=%@&dev=0&t=0",
                            self.startLatitude, self.startLongitude, self.startPosition,
                            self.endLatitude, self.endLongitude, self.endPosition];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    amapUrlStr = [amapUrlStr stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSURL *amapUrl = [NSURL URLWithString:amapUrlStr];
    [[UIApplication sharedApplication] openURL:amapUrl options:@{} completionHandler:nil];
}

// 提示框
- (void)showAlertWithName:(NSString *)name {
    NSString *title = [NSString stringWithFormat:@"未找到%@App", name];
    NSString *message = [NSString stringWithFormat:@"请先安装%@App后再导航", name];
    UUAlertTipsController *alert = [[UUAlertTipsController alloc] initWithTitle:title message:message];
    [alert addAction:@"确 定" type:UUAlertTipsActionBlueBack handler:nil];
    [[UUToolsUI currentViewController] presentViewController:alert animated:YES completion:nil];
}

@end
