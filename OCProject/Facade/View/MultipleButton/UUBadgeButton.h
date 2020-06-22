//
//  UUBadgeButton.h
//  OCProject
//
//  Created by Pan on 2020/6/22.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUBadgeButton : UIButton

@property (nonatomic, copy) NSString *badgeValue;            // 角标值
@property (nonatomic, strong) UIImage *badgeImage;           // 角标图片
@property (nonatomic, assign) CGFloat badgeMinSize;          // 角标最小尺寸
@property (nonatomic, strong, readonly) UILabel *badgeLabel; // 角标标签
@end

NS_ASSUME_NONNULL_END
