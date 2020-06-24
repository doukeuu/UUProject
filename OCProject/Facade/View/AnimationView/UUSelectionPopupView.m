//
//  UUSelectionPopupView.m
//  OCProject
//
//  Created by Pan on 2020/6/23.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUSelectionPopupView.h"

#define cellHeight (45)
#define kSectionHeight 1

@interface UUSelectionPopupView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView; // 列表视图
@end

static NSString *identifier = @"TableViewCell";

@implementation UUSelectionPopupView

+ (void)popupToView:(UIView *)view titles:(NSArray *)titleArray selected:(void (^)(NSInteger))block {
    if (!view) return;
    
    UUSelectionPopupView *pop = [[UUSelectionPopupView alloc] initWithView:view];
    pop.titleArray = titleArray;
    pop.selectedBlock = block;
    
    pop.popupPoint = CGPointMake(0, NAVIGATOR_H + 106);
    
    [view addSubview:pop];
    [pop popViewAnimated];
}

#pragma mark - Initialize

- (id)initWithView:(UIView *)view {
    NSAssert(view, @"View must not be nil");
    return [self initWithFrame:view.bounds];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
        [self generateTableview];
    }
    return self;
}

// 初始化默认属性值
- (void)commonInit {
    
    _style = PopupSelectionViewStyleOrdinary;
    _animationType = PopupSelectionViewPopFromBottom;
    _selectedIndex = -1;
    
    self.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.2f];
    self.alpha = 0.f;
    self.opaque = NO;
    
    [self updateTableViewFrame];
}

#pragma mark - Subview

// 列表视图
- (void)generateTableview {

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.layer.cornerRadius = 5.0f;
    _tableView.clipsToBounds = YES;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:_tableView];
}

// 更新列表视图的Frame
- (void)updateTableViewFrame {
    
    CGFloat fixedHeight = self.titleArray.count * cellHeight + kSectionHeight;
    CGPoint anchor = CGPointZero;
    CGRect transformFrame = CGRectZero;
    
    switch (_style) {
        case PopupSelectionViewStyleOrdinary:
            transformFrame.size = CGSizeMake(self.bounds.size.width, fixedHeight);
            break;
        case PopupSelectionViewStyleRightHalf:
            transformFrame.size = CGSizeMake(self.bounds.size.width / 2, fixedHeight);
            break;
        case PopupSelectionViewStyleCheckMark:
            transformFrame.size = CGSizeMake(self.bounds.size.width - 16, fixedHeight);
            break;
    }
    
    switch (_animationType) {
        case PopupSelectionViewPopFromTop: {
            anchor = CGPointMake(0.5f, 0.5f);
            transformFrame.origin = CGPointMake(8, 8);
        } break;
        case PopupSelectionViewPopFromBottom: {
            anchor = CGPointMake(0.5f, 0.5f);
            CGFloat spacing = UIApplication.sharedApplication.statusBarFrame.size.height > 20 ? 34 : 8 ;
            transformFrame.origin = CGPointMake(8, self.bounds.size.height - fixedHeight - spacing);
        } break;
        case PopupSelectionViewScaleFromRightTop: {
            anchor = CGPointMake(1.f, 0.f);
            transformFrame.origin = CGPointMake(self.bounds.size.width / 2 - 8, 8);
        } break;
        case PopupSelectionViewScaleFromPoint: {
            anchor = CGPointMake(1.f, 0.f);
            transformFrame.origin = self.popupPoint;
        } break;
    }
    
    _tableView.layer.anchorPoint = anchor;
    _tableView.frame = transformFrame;
}

#pragma mark - Property Setter

- (void)setStyle:(PopupSelectionViewStyle)style {
    
    if (_style == style) return;
    _style = style;
    [self updateTableViewFrame];
}

- (void)setPopupPoint:(CGPoint)popupPoint {
    
    _popupPoint = popupPoint;
    [self updateTableViewFrame];
}

- (void)setAnimationType:(PopupSelectionViewAnimation)animationType {
    
    if (_animationType == animationType) return;
    _animationType = animationType;
    [self updateTableViewFrame];
}

- (void)setImageArray:(NSArray *)imageArray {
    
    if (_imageArray == imageArray) return;
    _imageArray = imageArray;
    [self updateTableViewFrame];
    [self.tableView reloadData];
}

- (void)setTitleArray:(NSArray *)titleArray {
    
    if (_titleArray == titleArray) return;
    _titleArray = titleArray;
    [self updateTableViewFrame];
    [self.tableView reloadData];
}

#pragma mark - Pop & Hide

- (void)popViewAnimated {
    
    [self.tableView.layer removeAllAnimations];
    [self animateIn:YES completion:NULL];
}

- (void)hideViewAnimated {
    
    [self animateIn:NO completion:^(BOOL finished) {
        [self.tableView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

// 设置弹出和隐藏时动画
- (void)animateIn:(BOOL)animateIn completion:(void(^)(BOOL finished))completion {
    
    CGAffineTransform beginTransform = CGAffineTransformIdentity;
    CGAffineTransform endTransform = CGAffineTransformIdentity;
    
    switch (_animationType) {
        case PopupSelectionViewPopFromTop: {
            if (animateIn) {
                beginTransform = CGAffineTransformMakeTranslation(0, -_tableView.bounds.size.height);
                endTransform = CGAffineTransformMakeTranslation(0, 0);
            } else {
                endTransform = CGAffineTransformMakeTranslation(0, -_tableView.bounds.size.height);
            }
        } break;
        case PopupSelectionViewPopFromBottom: {
            if (animateIn) {
                beginTransform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
                endTransform = CGAffineTransformMakeTranslation(0, 0);
            } else {
                endTransform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
            }
        } break;
        case PopupSelectionViewScaleFromRightTop: {
            if (animateIn) {
                beginTransform = CGAffineTransformMakeScale(0.5f, 0.5f);
                endTransform = CGAffineTransformMakeScale(1.f, 1.f);
            } else {
                endTransform = CGAffineTransformMakeScale(0.5f, 0.5f);
            }
        } break;
        case PopupSelectionViewScaleFromPoint: {
            if (animateIn) {
                beginTransform = CGAffineTransformMakeScale(1.f, 0.f);
                endTransform = CGAffineTransformMakeScale(1.f, 1.f);
            } else {
                endTransform = CGAffineTransformMakeScale(1.f, 0.f);
            }
        } break;
    }
    
    // 开始时的动画设置
    if (animateIn) {
        _tableView.transform = beginTransform;
    }
    // 结束时的动画设置
    dispatch_block_t animations = ^{
        self.alpha = animateIn ? 1.f : 0.f;
        self.opaque = animateIn;
        self->_tableView.transform = endTransform;
    };
    
    [UIView animateWithDuration:0.3f delay:0.f usingSpringWithDamping:1.f initialSpringVelocity:0.f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:animations completion:completion];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    if (self.imageArray.count > indexPath.row) {
        cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    }
    if (self.titleArray.count > indexPath.row) {
        cell.textLabel.text = self.titleArray[indexPath.row];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.accessoryView = nil;
    }
    // 有对号的视图样式下，对于选择的行列显示对号
    if (self.style == PopupSelectionViewStyleCheckMark && indexPath.row == self.selectedIndex) {
        cell.textLabel.textColor = [UIColor greenColor];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_green"]];
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_style == PopupSelectionViewStyleCheckMark) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    _selectedIndex = indexPath.row;
    if (self.selectedBlock) self.selectedBlock(_selectedIndex);
    [self hideViewAnimated];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Utility Method

// 点击空白处，隐藏视图
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideViewAnimated];
}

- (void)dealloc {
    NSLog(@"- dealloc : %@", [self class]);
}

@end
