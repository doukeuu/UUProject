//
//  UUMenuOptionCell.h
//  OCProject
//
//  Created by Pan on 2020/9/30.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UUMenuOptionCell;

@protocol UUMenuOptionCellDelegate <NSObject>

/// 点击删除按钮，响应的代理方法
- (void)menuOptionCell:(UUMenuOptionCell *)cell didClickDeleteButton:(UIButton *)button;
@end


@interface UUMenuOptionCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *nameLabel;     // 名称标签
@property (strong, nonatomic) UIButton *deleteButton; // 删除按钮
@property (strong, nonatomic) UILabel *markLabel;     // 标示标签
@property (strong, nonatomic) UIView *markView;       // 标示色块
@property (weak, nonatomic) id<UUMenuOptionCellDelegate> delegate;
@end


@interface UUSeparatorReusableView : UICollectionReusableView

@property (strong, nonatomic) UILabel *descriptionLabel; // 说明标签
@end

NS_ASSUME_NONNULL_END
