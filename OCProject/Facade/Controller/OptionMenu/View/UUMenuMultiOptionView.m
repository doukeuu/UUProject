//
//  UUMenuMultiOptionView.m
//  OCProject
//
//  Created by Pan on 2020/9/30.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUMenuMultiOptionView.h"
#import "UUMenuOptionCell.h"
#import "UIView+UU.h"

#define actionHeight 30
#define margin       10
#define itemHeight   35
#define lightGrayBackColor [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]

#define identifierUp     @"upCollectionViewCell"
#define identifierDown   @"downCollectionViewCell"
#define identifierHeader @"headerReusableView"
#define identifierFooter @"footerReusableView"

#define userDefaultsHot  @"HotTitleInMenu"
#define userDefaultsNew  @"NewTitleInMenu"

typedef NS_ENUM(NSInteger, MenuCellScrollDirection) { // 手势移动的方向枚举
    MenuCellScrollDirectionNone = 0,
    MenuCellScrollDirectionLeft,
    MenuCellScrollDirectionRight,
    MenuCellScrollDirectionUp,
    MenuCellScrollDirectionDown
};

@interface UUMenuMultiOptionView ()
<
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UIGestureRecognizerDelegate,
    UUMenuOptionCellDelegate
>
{
    CGPoint _latestPoint; // 点触移动时最近一次的坐标
}
@property (strong, nonatomic) UILabel  *titleLabel;               // 标题
@property (strong, nonatomic) UIImageView *backImageView;         // 返回操作
@property (strong, nonatomic) UILabel *completeLabel;             // 完成操作

@property (strong, nonatomic) UICollectionView *collectionView;   // 集合视图
@property (strong, nonatomic) UICollectionViewFlowLayout *layout; // 集合视图的约束

@property (strong, nonatomic) NSMutableArray *upNameArray;        // 上边名称数组
@property (strong, nonatomic) NSMutableArray *downNameArray;      // 下边名称数组
@property (strong, nonatomic) NSMutableArray *addTitleArray;      // 新添加到上边的标题数组

@property (strong, nonatomic) NSIndexPath *originalIndexPath;     // 初始cell的下标
@property (strong, nonatomic) NSIndexPath *latestIndexPath;       // 最终选定的cell下标

@property (strong, nonatomic) UIView *movingCell;                 // 移动的cell快照视图
@property (strong, nonatomic) CADisplayLink *edgeTimer;           // 边缘移动刷新设定

@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGesture;  // 长时间长按手势
@property (strong, nonatomic) UILongPressGestureRecognizer *shortPressGesture; // 短时间长按手势

@property (strong, nonatomic) NSString *upNamePlistPath;          // 上边选项的名称plist文件地址
@property (strong, nonatomic) NSString *downNamePlistPath;        // 下边选项的名称plist文件地址
@end

@implementation UUMenuMultiOptionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = lightGrayBackColor;
        
        self.latestIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        self.titleLabel.hidden = NO;
        self.backImageView.hidden = NO;
        self.completeLabel.hidden = YES;
        [self configurateCollectionView];
    }
    return self;
}

/// 设置初始的选项
- (void)setItemRow:(NSInteger)itemRow {
    _itemRow = itemRow;
    if (itemRow >= 0 && itemRow < self.upNameArray.count) {
        self.latestIndexPath = [NSIndexPath indexPathForItem:itemRow inSection:0];
    }
}

/// 每次点触即响应的方法
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    self.shortPressGesture.enabled = self.completeLabel.isHidden;
    self.longPressGesture.enabled = YES;
    return [super hitTest:point withEvent:event];
}

#pragma mark - Setup Subview

- (UILabel *)titleLabel {
    if (_titleLabel != nil) return _titleLabel;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin+2, 0, self.width-62-margin, actionHeight)];
    _titleLabel.attributedText = [[self titleTextStyleWithString:@"切换栏目\t长按排序或删除"] copy];
    [self addSubview:_titleLabel];
    return _titleLabel;
}

- (UIImageView *)backImageView {
    if (_backImageView != nil) return _backImageView;
    _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_up_black"]];
    _backImageView.frame = CGRectMake(self.width*0.9, 0, self.width*0.1, actionHeight);
    _backImageView.contentMode = UIViewContentModeCenter;
    _backImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackImageView:)];
    [_backImageView addGestureRecognizer:tap];
    [self addSubview:_backImageView];
    return _backImageView;
}

- (UILabel *)completeLabel {
    if (_completeLabel != nil) return _completeLabel;
    _completeLabel = [[UILabel alloc] init];
    _completeLabel.frame = CGRectMake(self.width*0.9, 0, self.width*0.1, actionHeight);
    _completeLabel.font = [UIFont systemFontOfSize:14];
    _completeLabel.text = @"完成";
    _completeLabel.textColor = [UIColor orangeColor];
    _completeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCompleteLabel:)];
    [_completeLabel addGestureRecognizer:tap];
    [self addSubview:_completeLabel];
    return _completeLabel;
}

- (UICollectionViewFlowLayout *)layout {
    if (_layout != nil) return _layout;
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.itemSize = CGSizeMake((self.width-5*margin)/4, itemHeight);
    _layout.minimumLineSpacing = margin;
    _layout.minimumInteritemSpacing = margin;
    _layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    return _layout;
}

- (UICollectionView *)collectionView {
    if (_collectionView != nil) return _collectionView;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, actionHeight, self.width, self.height-actionHeight) collectionViewLayout:self.layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.bounces = NO;
    [self addSubview:_collectionView];
    return _collectionView;
}

/// 配置集合视图，注册cell、添加手势及手势关系
- (void)configurateCollectionView {
    
    [self.collectionView registerClass:[UUMenuOptionCell class] forCellWithReuseIdentifier:
     identifierUp];
    [self.collectionView registerClass:[UUMenuOptionCell class] forCellWithReuseIdentifier:identifierDown];
    [self.collectionView registerClass:[UUSeparatorReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifierHeader];
    
    UILongPressGestureRecognizer *shortPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(shortPressMenuCell:)];
    shortPress.minimumPressDuration = 0.5;
    shortPress.delegate = self;
    self.shortPressGesture = shortPress;
    [_collectionView addGestureRecognizer:shortPress];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMenuCell:)];
    longPress.minimumPressDuration = 0.8;
    longPress.delegate = self;
    self.longPressGesture = longPress;
    [_collectionView addGestureRecognizer:longPress];
    
    // 防止拖动时，整个集合视图也会滚动
    for (UIGestureRecognizer *gestureRecognizer in self.collectionView.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            [gestureRecognizer requireGestureRecognizerToFail:self.longPressGesture];
        }
    }
}

#pragma mark - Property Lazy Load

- (NSMutableArray *)upNameArray {
    if (!_upNameArray) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *upNamePlist = [documentPath stringByAppendingPathComponent:@"upName.plist"];
        _upNameArray = [[NSMutableArray alloc] initWithContentsOfFile:upNamePlist];
        self.upNamePlistPath = upNamePlist;
    }
    return _upNameArray;
}

- (NSMutableArray *)downNameArray {
    if (!_downNameArray) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *downNamePlist = [documentPath stringByAppendingPathComponent:@"downName.plist"];
        _downNameArray = [[NSMutableArray alloc] initWithContentsOfFile:downNamePlist];
        self.downNamePlistPath = downNamePlist;
    }
    return _downNameArray;
}

- (NSMutableArray *)addTitleArray {
    if (!_addTitleArray) {
        _addTitleArray = [NSMutableArray array];
    }
    return _addTitleArray;
}

#pragma mark - Response Method

/// 返回操作
- (void)tapBackImageView:(UITapGestureRecognizer *)recognizer {
    [self removeSelfFromSuperViewWithAnimation];
}

/// 完成操作
- (void)tapCompleteLabel:(UITapGestureRecognizer *)recognizer {
    self.titleLabel.attributedText = [[self titleTextStyleWithString:@"切换栏目\t长按排序或删除"] copy];
    [self.collectionView reloadData];
    self.shortPressGesture.enabled = YES;
    self.longPressGesture.minimumPressDuration = 0.7;
    self.backImageView.hidden = NO;
    self.completeLabel.hidden = YES;
}

/// 短时间的长按手势响应方法
- (void)shortPressMenuCell:(UILongPressGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            CGPoint point = [recognizer locationInView: self.collectionView];
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
            
            if (!indexPath || !(indexPath.section == 0)) {
                recognizer.enabled = NO;
                return;
            }
            self.titleLabel.attributedText = [[self titleTextStyleWithString:@"拖动栏目"] copy];
            self.backImageView.hidden = YES;
            self.completeLabel.hidden = NO;
            [self.collectionView reloadData];
            
            self.longPressGesture.minimumPressDuration = 0.1;
            recognizer.enabled = NO;
        }break;
        case UIGestureRecognizerStateChanged:
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            break;
        default:
            break;
    }
}

/// 长时间的长按响应方法
- (void)longPressMenuCell:(UILongPressGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            
            CGPoint point = [recognizer locationInView: self.collectionView];
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
            
            if (!indexPath || !(indexPath.section == 0) ||  indexPath.row == 0) { // 第一个不能动
                recognizer.enabled = NO;
                return;
            }
            _latestPoint = point;
            self.originalIndexPath = indexPath;
            UUMenuOptionCell *cell = (UUMenuOptionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            
            self.movingCell = [cell snapshotViewAfterScreenUpdates:NO];
            self.movingCell.frame = cell.frame;
            cell.hidden = YES;
            [self.collectionView addSubview:self.movingCell];
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.movingCell.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
            } completion:^(BOOL finished) {
                [self beginEdgeTimer];
            }];
        }break;
        case UIGestureRecognizerStateChanged: {
            
            CGPoint movePoint = [recognizer locationInView:self.collectionView];
            //    self.movingCell.center = movePoint; // 用下面的动画代替
            CGFloat changedX = movePoint.x - _latestPoint.x;
            CGFloat changedY = movePoint.y - _latestPoint.y;
            self.movingCell.center = CGPointApplyAffineTransform(self.movingCell.center, CGAffineTransformMakeTranslation(changedX, changedY));
            _latestPoint = movePoint;
            
            NSIndexPath *newIndexPath = [self.collectionView indexPathForItemAtPoint:movePoint];
            if (newIndexPath == nil || newIndexPath == self.originalIndexPath || newIndexPath.row == 0) { // 第一个不能动
                return;
            }
            
            id tempValue = [self.upNameArray objectAtIndex:self.originalIndexPath.row];
            [self.upNameArray removeObjectAtIndex:self.originalIndexPath.row];
            [self.upNameArray insertObject:tempValue atIndex:newIndexPath.row];
            [self.upNameArray writeToFile:self.upNamePlistPath atomically:YES];
            [self.collectionView moveItemAtIndexPath:self.originalIndexPath toIndexPath:newIndexPath];
            self.originalIndexPath = newIndexPath;
            self.latestIndexPath = newIndexPath;
        }break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            
            UUMenuOptionCell *cell = (UUMenuOptionCell *)[self.collectionView cellForItemAtIndexPath:self.originalIndexPath];
            [UIView animateWithDuration:0.3 animations:^{
                self.movingCell.center = cell.center;
                self.movingCell.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            } completion:^(BOOL finished) {
                [self stopEdgeTimer];
                cell.hidden = NO;
                [self.movingCell removeFromSuperview];
            }];
        }break;
        default:
            break;
    }
}

/// 实时刷新开始
- (void)beginEdgeTimer {
    if (!_edgeTimer) {
        _edgeTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(edgeScrolling)];
        [_edgeTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

/// 实时刷新结束
- (void)stopEdgeTimer {
    if (_edgeTimer) {
        [_edgeTimer invalidate];
        _edgeTimer = nil;
    }
}

/// 拖动到边缘时，结合视图的滚动，看别人的案例，直接拿过来了,网易的下拉菜单没有这种滚动
- (void)edgeScrolling {
    MenuCellScrollDirection direction = [self getEdgeScrollDirection];
    
    CGPoint offset = self.collectionView.contentOffset;
    CGPoint center = self.movingCell.center;
    switch (direction) {
        case MenuCellScrollDirectionLeft: {
            [self.collectionView setContentOffset:CGPointMake(offset.x-4, offset.y) animated:NO];
            [self.movingCell setCenter:CGPointMake(center.x+4, center.y)];
            _latestPoint.x -= 4;
        }break;
        case MenuCellScrollDirectionRight: {
            [self.collectionView setContentOffset:CGPointMake(offset.x+4, offset.y) animated:NO];
            [self.movingCell setCenter:CGPointMake(center.x+4, center.y)];
            _latestPoint.x += 4;
        }break;
        case MenuCellScrollDirectionUp: {
            [self.collectionView setContentOffset:CGPointMake(offset.x, offset.y-4) animated:NO];
            [self.movingCell setCenter:CGPointMake(center.x, center.y-4)];
            _latestPoint.y -= 4;
        }break;
        case MenuCellScrollDirectionDown: {
            [self.collectionView setContentOffset:CGPointMake(offset.x, offset.y+4) animated:NO];
            [self.movingCell setCenter:CGPointMake(center.x, center.y+4)];
            _latestPoint.y += 4;
        }break;
        default:
            break;
    }
}

/// 拖动到边缘的方向
- (MenuCellScrollDirection)getEdgeScrollDirection {
    
    CGSize viewSize = self.collectionView.size;
    CGSize viewContentSize = self.collectionView.contentSize;
    CGPoint viewOffset = self.collectionView.contentOffset;
    
    CGSize cellSize = self.movingCell.size;
    CGPoint cellCenter = self.movingCell.center;
    
    if (viewSize.height + viewOffset.y - cellCenter.y < cellSize.height/2 && viewSize.height + viewOffset.y < self.collectionView.contentSize.height) {
        return MenuCellScrollDirectionDown;
    }
    if (cellCenter.y - viewOffset.y < cellSize.height/2 && viewOffset.y > 0) {
        return MenuCellScrollDirectionUp;
    }
    if (viewSize.width + viewOffset.x - cellCenter.x < cellSize.width/2 && viewSize.width + viewOffset.x < viewContentSize.width) {
        return MenuCellScrollDirectionRight;
    }
    if (cellCenter.x - viewOffset.x < cellSize.width/2 && viewOffset.x > 0) {
        return MenuCellScrollDirectionLeft;
    }
    return MenuCellScrollDirectionNone;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return section == 0 ? CGSizeZero : CGSizeMake(actionHeight, actionHeight);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section == 0 ? self.upNameArray.count : self.downNameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UUMenuOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierUp forIndexPath:indexPath];
        cell.nameLabel.text = self.upNameArray[indexPath.row];
        cell.deleteButton.hidden = self.completeLabel.isHidden;
        cell.deleteButton.tag = indexPath.row;
        cell.markLabel.hidden = YES;
        cell.markView.hidden = YES;
        cell.delegate = self;
        
        if ([[NSUserDefaults standardUserDefaults] arrayForKey:userDefaultsHot]) {
            NSArray *hots = [[NSUserDefaults standardUserDefaults] arrayForKey:userDefaultsHot];
            if ([hots containsObject: cell.nameLabel.text]) {
                cell.markLabel.text = @"hot";
                cell.markLabel.hidden = NO;
            }
        }
        if ([[NSUserDefaults standardUserDefaults] arrayForKey:userDefaultsNew]) {
            NSArray *news = [[NSUserDefaults standardUserDefaults] arrayForKey:userDefaultsNew];
            if ([news containsObject:cell.nameLabel.text]) {
                cell.markLabel.text = @"new";
                cell.markLabel.hidden = NO;
            }
        }
        if (self.addTitleArray.count > 0 && cell.markLabel.isHidden) {
            cell.markView.hidden = ![self.addTitleArray containsObject:cell.nameLabel.text];
        }
        if ([self.latestIndexPath isEqual:indexPath]) {
            cell.selected = YES;
        }
        return cell;
    } else {
        UUMenuOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierDown forIndexPath:indexPath];
        cell.nameLabel.text = self.downNameArray[indexPath.row];
        cell.nameLabel.textColor = [UIColor grayColor];
        cell.markLabel.hidden = YES;
        cell.userInteractionEnabled = self.completeLabel.isHidden;
        
        if ([[NSUserDefaults standardUserDefaults] arrayForKey:userDefaultsHot]) {
            NSArray *hots = [[NSUserDefaults standardUserDefaults] arrayForKey:userDefaultsHot];
            if ([hots containsObject: cell.nameLabel.text]) {
                cell.markLabel.text = @"hot";
                cell.markLabel.hidden = NO;
            }
        }
        if ([[NSUserDefaults standardUserDefaults] arrayForKey:userDefaultsNew]) {
            NSArray *news = [[NSUserDefaults standardUserDefaults] arrayForKey:userDefaultsNew];
            if ([news containsObject:cell.nameLabel.text]) {
                cell.markLabel.text = @"new";
                cell.markLabel.hidden = NO;
            }
        }
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        UUSeparatorReusableView *separator = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifierHeader forIndexPath:indexPath];
        separator.descriptionLabel.text = indexPath.section == 0? @"" : @"点击添加更多栏目";
        reusableView = separator;
    }
    return reusableView;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.backImageView.isHidden) return;
    
    if (indexPath.section == 0) {
        UUMenuOptionCell *cell = (UUMenuOptionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (!cell.markLabel.hidden) {
            if ([[NSUserDefaults standardUserDefaults] arrayForKey:userDefaultsHot]) {
                NSArray *hots = [[NSUserDefaults standardUserDefaults] arrayForKey:userDefaultsHot];
                if ([hots containsObject: cell.nameLabel.text]) {
                    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:hots];
                    [tempArray removeObject:cell.nameLabel.text];
                    [[NSUserDefaults standardUserDefaults] setObject:(tempArray.count>0 ? tempArray : nil) forKey:userDefaultsHot];
//                    cell.markLabel.hidden = YES;
//                    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }
            }
            if ([[NSUserDefaults standardUserDefaults] arrayForKey:userDefaultsNew]) {
                NSArray *news = [[NSUserDefaults standardUserDefaults] arrayForKey:userDefaultsNew];
                if ([news containsObject:cell.nameLabel.text]) {
                    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:news];
                    [tempArray removeObject:cell.nameLabel.text];
                    [[NSUserDefaults standardUserDefaults] setObject:(tempArray.count>0 ? tempArray : nil) forKey:userDefaultsNew];
//                    cell.markLabel.hidden = YES;
//                    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }
            }
        }
        self.latestIndexPath = indexPath;
        [self removeSelfFromSuperViewWithAnimation];
    } else {
        NSString *title = self.downNameArray[indexPath.row];
        [self.downNameArray removeObject:title];
        [self.upNameArray addObject:title];
        [self.addTitleArray addObject:title];
        
        [self.upNameArray writeToFile:self.upNamePlistPath atomically:YES];
        [self.downNameArray writeToFile:self.downNamePlistPath atomically:YES];
        self.latestIndexPath = [NSIndexPath indexPathForItem:self.upNameArray.count-1 inSection:0];
        [collectionView reloadData];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - UUMenuOptionCellDelegate

- (void)menuOptionCell:(UUMenuOptionCell *)cell didClickDeleteButton:(UIButton *)button {
    if (button.tag == 0) return;
    
    NSString *title = self.upNameArray[button.tag];
    [self.upNameArray removeObject:title];
    [self.downNameArray addObject:title];
    
    [self.upNameArray writeToFile:self.upNamePlistPath atomically:YES];
    [self.downNameArray writeToFile:self.downNamePlistPath atomically:YES];
    if (button.tag == self.latestIndexPath.row) {
        self.latestIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    }
    if (button.tag < self.latestIndexPath.row) {
        self.latestIndexPath = [NSIndexPath indexPathForItem:self.latestIndexPath.row-1 inSection:0];
    }
    [self.collectionView reloadData];
}

#pragma mark - Utility Method

/// 根据标题字符串长度设定标题的不同样式
- (NSMutableAttributedString *)titleTextStyleWithString:(NSString *)originalString {
    NSMutableAttributedString *styleString = [[NSMutableAttributedString alloc] initWithString:originalString];
    if (originalString.length > 4) {
        [styleString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, originalString.length)];
        [styleString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 4)];
        [styleString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(4, originalString.length-4)];
        [styleString addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:-1] range:NSMakeRange(4, originalString.length-4)];
    } else {
        [styleString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, originalString.length)];
        [styleString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, originalString.length)];
    }
    return styleString;
}

/// 响应代理方法返回数值，并将视图从主视图中删除
- (void)removeSelfFromSuperViewWithAnimation {
    if ([self.delegate respondsToSelector:@selector(menuOptionsDidChangedToTitles:selectedIndex:)]) {
        [self.delegate menuOptionsDidChangedToTitles:[self.upNameArray copy] selectedIndex:self.latestIndexPath.row];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = -self.frame.size.height;
        self.frame = frame;
    } completion:^(BOOL finished) {
        self.delegate = nil;
        [self removeFromSuperview];
    }];
}

- (void)dealloc{
    NSLog(@"dealloc");
}


@end
