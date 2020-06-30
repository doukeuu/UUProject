//
//  UULoginBaseController.h
//  OCProject
//
//  Created by Pan on 2020/6/30.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UULoginBaseController : UIViewController

@property (nonatomic, assign) BOOL addKeyboardObserver;       // 添加键盘弹出监听
@property (nonatomic, strong) UITableView *tableView;         // 输入列表
@property (nonatomic, strong) NSIndexPath *selectedIndexPath; // 输入点击的单元格
@end

NS_ASSUME_NONNULL_END
