//
//  UUTextViewTableCell.h
//  OCProject
//
//  Created by Pan on 2020/6/17.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUTextViewTableCell : UITableViewCell

@property (nonatomic, assign) CGFloat      cellHeight;   // 单元格高度，需最先设置，默认150
@property (nonatomic, assign) NSUInteger   limitedCount; // 限制输入的字数

@property (nonatomic, strong) UILabel     *titleLabel;   // 标题标签
@property (nonatomic, strong) UITextView  *textView;     // 输入视图，默认限定200个字符
@property (nonatomic, strong) NSIndexPath *indexPath;    // 可设置为TableView的indexPath
@end

NS_ASSUME_NONNULL_END
