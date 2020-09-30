//
//  UUMenuMultiOptionView.h
//  OCProject
//
//  Created by Pan on 2020/9/30.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UUMenuMultiOptionViewDelegate <NSObject>

/// 菜单中选择的选项名称及下标
- (void)menuOptionsDidChangedToTitles:(NSArray *)titles selectedIndex:(NSInteger)index;
@end


@interface UUMenuMultiOptionView : UIView

@property (assign, nonatomic) NSInteger itemRow; // 选择的选项row下标
@property (weak, nonatomic) id<UUMenuMultiOptionViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
