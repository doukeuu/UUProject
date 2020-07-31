//
//  UUFoldingPopupView.m
//  OCProject
//
//  Created by Pan on 2020/7/31.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUFoldingPopupView.h"

#define kCellHeight 44
#define kHeaderH    14
#define kFooterH    14

@interface UUFoldingPopupView ()
<
    UITableViewDataSource,
    UITableViewDelegate
>
@end

@implementation UUFoldingPopupView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.36];
        _selectedIndex = 0;
        self.animationType = UUAnimationScaleFromPoint;
        [self generateTableview];
    }
    return self;
}

- (void)dealloc {
    NSLog(@" == %@", [self class]);
}

// 从view中隐藏选择视图
+ (void)hidePopupViewIn:(UIView *)view {
    if (!view) return;
    NSEnumerator *subviewEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewEnum) {
        if ([subview isKindOfClass:self]) {
            UUFoldingPopupView *selectionView = (UUFoldingPopupView *)subview;
            [selectionView hideViewAnimated];
            break;
        }
    }
}

#pragma mark - Subviews

// 列表视图
- (void)generateTableview {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = UIColor.whiteColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.layer.shadowColor = UIColor.blackColor.CGColor;
    _tableView.layer.shadowOffset = CGSizeMake(0, 3);
    _tableView.layer.shadowOpacity = 0.3;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:_tableView];
    self.bezelView = _tableView;
}

// 更新列表视图frame
- (void)updateTableViewFrame {
    CGFloat contentHeight = self.titleArray.count * kCellHeight + kHeaderH + kFooterH;
    CGFloat tableHeight = MIN(contentHeight, self.bounds.size.height);
    _tableView.frame = CGRectMake(0, 0, self.bounds.size.width, tableHeight);
    UIRectCorner corner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:_tableView.bounds
                                                     byRoundingCorners:corner
                                                           cornerRadii:CGSizeMake(5, 5)];
    [self updateBezelViewFrame];
    [_tableView reloadData];
    
    if (tableHeight == self.bounds.size.height) return;
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = _tableView.bounds;
    shapeLayer.path = bezierPath.CGPath;
    _tableView.layer.mask = shapeLayer;
}

#pragma mark - Setter

// 标题数组
- (void)setTitleArray:(NSArray *)titleArray {
    if (_titleArray == titleArray) return;
    _titleArray = titleArray;
    [self updateTableViewFrame];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kFoldingCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kFoldingCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = UIColor.blackColor;
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    if (indexPath.row == _selectedIndex) {
        cell.backgroundColor = UIColor.lightGrayColor;
    } else {
        cell.backgroundColor = UIColor.whiteColor;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"kFoldingHeader"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"kFoldingHeader"];
        headerView.contentView.backgroundColor = UIColor.whiteColor;
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"kFoldingFooter"];
    if (!footerView) {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"kFoldingFooter"];
        footerView.contentView.backgroundColor = UIColor.whiteColor;
    }
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kHeaderH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kFooterH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedBlock) self.selectedBlock(indexPath.row);
    [self hideViewAnimated];
}

#pragma mark - Touch

// 点击空白处，隐藏视图
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (self.selectedBlock) self.selectedBlock(-1);
    [self hideViewAnimated];
}

@end
