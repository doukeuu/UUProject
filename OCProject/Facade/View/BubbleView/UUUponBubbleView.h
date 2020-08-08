//
//  UUUponBubbleView.h
//  OCProject
//
//  Created by Pan on 2020/8/8.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUUponBubbleView : UIView

/// 气泡颜色
@property (nonatomic, strong) UIColor *bubbleColor;
/// 气泡圆角
@property (nonatomic, assign) CGFloat bubbleCorner;
/// 气泡内容
@property (nonatomic, copy) NSString *labelText;
/// 气泡字体
@property (nonatomic, strong) UIFont *labelFont;
/// 内容颜色
@property (nonatomic, strong) UIColor *labelColor;
@end

NS_ASSUME_NONNULL_END
