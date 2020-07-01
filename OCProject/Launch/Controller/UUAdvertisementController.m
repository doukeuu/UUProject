//
//  UUAdvertisementController.m
//  OCProject
//
//  Created by Pan on 2020/7/1.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUAdvertisementController.h"
#import "UUAdvertiseDetailController.h"
#import "UUAdvertisementModel.h"

#import "UUDataCache.h"
#import "UUVersionCheck.h"
#import "UUDateTime.h"
#import <YYDiskCache.h>
#import <Masonry/Masonry.h>
#import <SDWebImageDownloader.h>

#define kImageInfoStoreKey @"ImageInfoStoreKey"
#define kAppHasAdopted @"AppHasAdopted"
#define kTotalTimeInterval 6

@interface UUAdvertisementController ()

@property (nonatomic, strong) UIImageView *adImageView;   // 广告图片视图
@property (nonatomic, strong) UIButton *jumpButton;       // 跳转按钮

@property (nonatomic, assign) BOOL isBackFromDetail;      // 从详情页返回
@property (nonatomic, assign) BOOL stopTimer;             // 停止倒计时
@property (nonatomic, strong) YYDiskCache *diskCache;     // 存储类
@property (nonatomic, strong) NSArray *cacheArray;        // 缓存的数据类数组
@property (nonatomic, strong) NSMutableArray *indexArray; // 图片所属数据类下标数组
@property (nonatomic, assign) NSInteger currentIndex;     // 当前展示图片所属下标
@end

@implementation UUAdvertisementController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isBackFromDetail = NO;
    _stopTimer = NO;
    _cacheArray = (NSArray *)[self.diskCache objectForKey:kImageInfoStoreKey];
    [self acquireAdvertisementImageURL];
    
    NSString *isAdopted = [[NSString alloc] initWithData:[UUDataCache objectForKey:kAppHasAdopted] encoding:NSUTF8StringEncoding];
    if ([isAdopted isEqualToString:@"0"] || [UUVersionCheck isFirstLaunch]) { // 审核时/第一次打开
        [self transformToTabBarController];
    } else {
        [self generateSubviews];
        [self checkImageForShow];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    // 从广告详情返回后直接进入TabBar页面
    if (self.isBackFromDetail) {
        self.view.alpha = 0;
        [self transformToTabBarController];
    }
}

#pragma mark - Getter

- (YYDiskCache *)diskCache {
    
    if (_diskCache) return _diskCache;
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"AdImage"];
    _diskCache = [[YYDiskCache alloc] initWithPath:path inlineThreshold:0];
    return _diskCache;
}

- (NSMutableArray *)indexArray {
    
    if (_indexArray) return _indexArray;
    _indexArray = [NSMutableArray array];
    return _indexArray;
}

#pragma mark - Subview

// 配置子视图
- (void)generateSubviews {
    // 广告图片视图
    _adImageView = [[UIImageView alloc] init];
    _adImageView.contentMode = UIViewContentModeScaleToFill;
    _adImageView.userInteractionEnabled = YES;
    [_adImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView)]];
    [self.view addSubview:_adImageView];
    [_adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    // 跳转按钮
    _jumpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _jumpButton.frame = CGRectMake(SCREEN_WIDTH - 30 - 44, 30, 44, 44);
    _jumpButton.backgroundColor = UIColor.lightGrayColor;
    _jumpButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _jumpButton.layer.cornerRadius = 22;
    [_jumpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_jumpButton setTitle:@"跳过" forState:UIControlStateNormal];
    [_jumpButton addTarget:self action:@selector(clickJumpButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_jumpButton];
}

#pragma mark - Network Request

// 获取广告图片地址
- (void)acquireAdvertisementImageURL {
    
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString *resolution = [NSString stringWithFormat:@"%.fx%.f", SCREEN_WIDTH * scale, SCREEN_HEIGHT * scale];
    NSDictionary *params = @{@"system":@"ios",@"resolution":resolution};
    
//    [HTTPManager POST:kGetAdInfoURL params:params completeHandler:^(id object, NSError *error) {
//        if (error) return ;
//        if (![object isKindOfClass:[NSArray class]]) return;
//        NSArray *modelArray = [AdvertisementModel mj_objectArrayWithKeyValuesArray:object];
//        [self checkForDownloadWithImageInfo:modelArray];
//    }];
}

// 检查并下载图片
- (void)checkForDownloadWithImageInfo:(NSArray *)modelArray {
    
    dispatch_group_t group = dispatch_group_create();
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
//    downloader.shouldDecompressImages = NO;
    
    for (UUAdvertisementModel *model in modelArray) {
        BOOL contains = [self.diskCache containsObjectForKey:model.img];
        if (!contains) {
            NSURL *url = [NSURL URLWithString:model.img];
            dispatch_group_enter(group);
            [downloader downloadImageWithURL:url options:SDWebImageDownloaderLowPriority progress:nil
                                   completed:^(UIImage * _Nullable image, NSData * _Nullable data,
                                               NSError * _Nullable error, BOOL finished) {
                                       if (image) [self.diskCache setObject:image forKey:model.img];
                                       dispatch_group_leave(group);
                                   }];
        }
    }
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self storeImageInfoAndCheckForRemoveImageWith:modelArray];
    });
}

// 存储图片信息，检查是否需要删除旧图片
- (void)storeImageInfoAndCheckForRemoveImageWith:(NSArray *)modelArray {
    
    [self.diskCache setObject:modelArray forKey:kImageInfoStoreKey];
    for (UUAdvertisementModel *model in self.cacheArray) {
        BOOL isSame = NO;
        for (UUAdvertisementModel *currentModel in modelArray) {
            if ([model.img isEqualToString:currentModel.img]) {
                isSame = YES;
                break;
            }
        }
        if (!isSame) {
            [self.diskCache removeObjectForKey:model.img];
        }
    }
}

#pragma mark - Check Show

// 检查图片是否显示
- (void)checkImageForShow {
    
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:self.cacheArray.count];
    for (NSInteger i = 0; i < self.cacheArray.count; i ++) {
        UUAdvertisementModel *model = [self.cacheArray objectAtIndex:i];
        if (model.online && [self.diskCache containsObjectForKey:model.img]) {
            id image = [self.diskCache objectForKey:model.img];
            if (image) {
                [imageArray addObject:image];
                [self.indexArray addObject:@(i)];
            }
        }
    }
    if (imageArray.count == 0) {
        [self transformToTabBarController];
    } else {
        self.adImageView.image = [imageArray firstObject];
        self.currentIndex = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self timeCountDownWithImages:[imageArray copy]];
            [self showAnimationArcInView:self.jumpButton];
        });
    }
}

// 倒计时
- (void)timeCountDownWithImages:(NSArray *)imageArray {
    
    __block NSInteger imageIndex = 1;
    NSTimeInterval changeInterval = kTotalTimeInterval / imageArray.count;
    [UUDateTime timerForSecondCountDown:kTotalTimeInterval action:^(NSTimeInterval remainingTime, BOOL *stop) {
        *stop = self.stopTimer;
        if (remainingTime <= (kTotalTimeInterval - changeInterval * imageIndex)) {
            if (imageIndex < imageArray.count) {
                self.currentIndex = imageIndex;
                [self changeShowAdImage:[imageArray objectAtIndex:imageIndex]];
            }
            imageIndex ++;
        }
    } completion:^{
        [self transformToTabBarController];
    }];
}

// 切换图片
- (void)changeShowAdImage:(UIImage *)image {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.type = kCATransitionFade;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.adImageView.layer addAnimation:transition forKey:@"adImage"];
    self.adImageView.image = image;
}

// 展示圆弧动画
- (void)showAnimationArcInView:(UIView *)view {
    
    CGSize size = view.frame.size;
    CGPoint center = CGPointMake(size.width / 2, size.height / 2);
    CGFloat radius = (size.height > size.width ? size.width : size.height) / 2;
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:center
                                                           radius:radius
                                                       startAngle:M_PI*3/2
                                                         endAngle:M_PI*7/2
                                                        clockwise:YES];
    arcPath.lineCapStyle = kCGLineCapSquare;
    arcPath.lineJoinStyle = kCGLineJoinBevel;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = arcPath.CGPath;
    shapeLayer.strokeColor = [UIColor.redColor CGColor];
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    shapeLayer.lineWidth = radius / 7;
    shapeLayer.strokeStart = 0.0;
    shapeLayer.strokeEnd = 1.0;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = kTotalTimeInterval;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [animation setFromValue:@(0.0)];
    [animation setToValue:@(1.0)];
    
    [view.layer addSublayer:shapeLayer];
    [shapeLayer addAnimation:animation forKey:@"arcAnimation"];
}

#pragma mark - Touch Action

// 点击图片
- (void)tapImageView {
    
    self.stopTimer = YES;
    self.isBackFromDetail = YES;
    
    NSInteger imageIndex = [[self.indexArray objectAtIndex:self.currentIndex] integerValue];
    UUAdvertisementModel *model = [self.cacheArray objectAtIndex:imageIndex];
    if(model.link.length == 0) return;
    
    NSLog(@"--- %@", model.link);
    
#warning 界面跳转
    
//    UUAdvertiseDetailController *detail = [[UUAdvertiseDetailController alloc] initWithURLString:model.link];
//    detail.webTitle = model.title;
//    [self.navigationController pushViewController:detail animated:YES];
}

// 点击跳转按钮
- (void)clickJumpButton {
    [self transformToTabBarController];
}

#pragma mark - Utility

// 跳转到首页视图
- (void)transformToTabBarController {
    
    self.stopTimer = YES;
//    [GeneralTools executeObject:[UIApplication sharedApplication].delegate
//                   withSelector:@"changeRootViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
