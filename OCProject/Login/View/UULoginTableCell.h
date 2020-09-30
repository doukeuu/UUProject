//
//  UULoginTableCell.h
//  OCProject
//
//  Created by Pan on 2020/6/17.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UULoginTableCell : UITableViewCell

@property (nonatomic, assign) NSUInteger   limitedCount; // 限制输入的字数
@property (nonatomic, strong) UITextField *inputField;   // 输入框
@property (nonatomic, strong) UIButton    *actionButton; // 操作按钮
@end

NS_ASSUME_NONNULL_END
