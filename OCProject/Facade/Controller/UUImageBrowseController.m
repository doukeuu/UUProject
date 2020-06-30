//
//  UUImageBrowseController.m
//  OCProject
//
//  Created by Pan on 2020/6/30.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUImageBrowseController.h"
#import "UIView+UU.h"

@class UUImageScrollView;

@protocol ImageScrollViewDelegate <NSObject>
/// 单次点击代理
- (void)imageScrollViewTapSingle;
/// 长按代理
- (void)imageScrollViewLongPressWithImage:(UIImage *)image;
@end


@interface UUImageScrollView : UIScrollView <UIScrollViewDelegate>
{
    CGFloat _imageScale; // 原图的缩放比例
}
@property (nonatomic, strong) UIImage *image;                            // 添加的图片
@property (nonatomic, strong) UIImageView *imageView;                    // 图片视图
@property (nonatomic, assign) id<ImageScrollViewDelegate> imageDelegate; //代理
@end

@implementation UUImageScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self == nil) return self;
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.bounces = NO;
    self.bouncesZoom = YES;
    self.delegate = self;
    self.minimumZoomScale = 1.0;
    self.maximumZoomScale = 10.0;
    
    [self configGestureRecognizer];
    return self;
}

- (void)configGestureRecognizer {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSingle:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    singleTap.delaysTouchesBegan = YES;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDouble:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressLong:)];
    
    [self addGestureRecognizer:singleTap];
    [self addGestureRecognizer:doubleTap];
    [self addGestureRecognizer:longPress];
}

- (UIImageView *)imageView {
    if(_imageView != nil) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageView];
    return _imageView;
}

- (void)setImage:(UIImage *)image {
    if (!image) return;
    
    CGRect frame = CGRectZero;
    CGFloat ratio = image.size.width / image.size.height;
    if ((self.width / self.height) <= ratio) {
        frame.origin.y = (self.height - self.width / ratio)/2;
        frame.size = CGSizeMake(self.width, self.width / ratio);
    } else {
        frame.origin.x = (self.width - self.height * ratio) / 2;
        frame.size = CGSizeMake(self.height * ratio, self.height);
    }
    _imageScale = image.size.width / frame.size.width;
    self.imageView.frame = frame;
    self.imageView.image = image;
}

#pragma mark - Response Method

- (void)tapSingle:(UITapGestureRecognizer *)tap {
    if ([self.imageDelegate respondsToSelector:@selector(imageScrollViewTapSingle)]) {
        [self.imageDelegate imageScrollViewTapSingle];
    }
}

- (void)tapDouble:(UITapGestureRecognizer *)tap {
    CGFloat scale = self.zoomScale == 1.0 ? _imageScale : 1.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.zoomScale = scale;
    }];
}

- (void)pressLong:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if ([self.imageDelegate respondsToSelector:@selector(imageScrollViewLongPressWithImage:)]) {
            [self.imageDelegate imageScrollViewLongPressWithImage:self.imageView.image];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGSize size = scrollView.contentSize;
    CGPoint center = CGPointMake(size.width / 2, size.height / 2);
    if (self.imageView.width <= scrollView.width) {
        center.x = scrollView.width / 2;
    }
    if (self.imageView.height <= scrollView.height) {
        center.y = scrollView.height / 2;
    }
    self.imageView.center = center;
}

@end

#pragma mark - --------------------------------------------------------------------

@interface UUImageBrowseController () <UIScrollViewDelegate, ImageScrollViewDelegate, UIActionSheetDelegate>
{
    NSInteger _lastIndex;
    UIImage *_longPressImage;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *scrollArray;
@end

@implementation UUImageBrowseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _lastIndex = 0;
    self.scrollView.hidden = NO;
}

#pragma mark - Property Method

- (void)setImagesArray:(NSArray *)imagesArray {
    _imagesArray = imagesArray;
    if (imagesArray.count > 0) {
        [self configScrollViewContentView];
    }
}

- (void)setImageSelectedIndex:(NSInteger)imageSelectedIndex {
    _imageSelectedIndex = imageSelectedIndex;
    if (imageSelectedIndex >= 0 && imageSelectedIndex < self.imagesArray.count) {
        self.scrollView.contentOffset = CGPointMake(self.view.width * self.imageSelectedIndex, 0);
    }
}

- (NSMutableArray *)scrollArray {
    if(_scrollArray != nil) {
        return _scrollArray;
    }
    _scrollArray = [[NSMutableArray alloc] init];
    return _scrollArray;
}

#pragma mark - Config Subview

- (UIScrollView *)scrollView {
    if(_scrollView != nil) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    return _scrollView;
}

- (void)configScrollViewContentView {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.scrollArray removeAllObjects];
    
    self.scrollView.contentSize = CGSizeMake(self.view.width * self.imagesArray.count, self.view.height);
    self.scrollView.contentOffset = CGPointMake(self.view.width * self.imageSelectedIndex, 0);
    
    for (NSInteger index = 0; index < self.imagesArray.count; index ++) {
        UUImageScrollView *imageScrollView = [[UUImageScrollView alloc] initWithFrame:CGRectMake(self.view.width * index, 0, self.view.width, self.view.height)];
        imageScrollView.imageDelegate = self;
        imageScrollView.image = self.imagesArray[index];
        [self.scrollView addSubview:imageScrollView];
        [self.scrollArray addObject:imageScrollView];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = roundf(scrollView.contentOffset.x / self.view.width);
    if (_lastIndex != index) {
        UUImageScrollView *imageScrollView = self.scrollArray[_lastIndex];
        imageScrollView.zoomScale = 1.0f;
        _lastIndex = index;
    }
}

#pragma mark - ImageScrollViewDelegate

- (void)imageScrollViewTapSingle {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageScrollViewLongPressWithImage:(UIImage *)image {
    _longPressImage = image;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(_longPressImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(error != NULL){
        NSLog(@"保存图片失败");
    }else{
        NSLog(@"图片保存成功");
    }
}

@end
