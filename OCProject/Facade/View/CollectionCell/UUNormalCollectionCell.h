//
//  UUNormalCollectionCell.h
//  OCProject
//
//  Created by Pan on 2020/6/16.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUNormalCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *actionButton; // 响应按钮
@property (nonatomic, strong) UIImageView *imageView; // 图片视图

@property (nonatomic, strong) UILabel     *titleLabel;    // 标题
@property (nonatomic, strong) UILabel     *contentLabel;  // 内容
@property (nonatomic, strong) UIView      *bottomLine;    // 底部分割线
@property (nonatomic, strong) NSIndexPath *indexPath;     // cell的indexPath
@property (nonatomic, assign) NSInteger    fixTitleWidth; // 标题固定宽度
@property (nonatomic, assign) BOOL         showAccessory; // 是否显示箭头指示标志

// 调整标题和内容的宽度
- (void)adjustTitleAndContentWidth;
@end

NS_ASSUME_NONNULL_END
