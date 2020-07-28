//
//  UUSearchPatternHeaderView.h
//  OCProject
//
//  Created by Pan on 2020/7/23.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UUSearchPatternHeaderView;

@protocol UUSearchPatternHeaderViewDelegate <NSObject>

@optional
/// 点击删除按钮响应代理
- (void)headerViewDidClickDeleteButton:(UUSearchPatternHeaderView *)view;
@end


@interface UUSearchPatternHeaderView : UICollectionReusableView

/// 代理
@property (nonatomic, weak) id<UUSearchPatternHeaderViewDelegate> delegte;
@end

NS_ASSUME_NONNULL_END
