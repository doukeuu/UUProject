//
//  UUTextFieldTableCell.h
//  OCProject
//
//  Created by Pan on 2020/6/17.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUTextFieldTableCell : UITableViewCell

@property (nonatomic, assign) CGFloat      cellHeight;    // 单元格高度，需最先设置，默认49
@property (nonatomic, assign) NSUInteger   limitedCount;  // 限制输入的字数
@property (nonatomic, assign) BOOL         showAccessory; // 是否显示箭头指示标志

@property (nonatomic, strong) UILabel     *titleLabel;    // 标题标签
@property (nonatomic, strong) UITextField *inputField;    // 输入框，默认限制50个字符
@property (nonatomic, strong) NSIndexPath *indexPath;     // 可设置为TableView的indexPath

// 适应标题宽度
- (void)adjustTitleWidth;
@end

NS_ASSUME_NONNULL_END
