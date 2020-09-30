//
//  UUSatisfactionDegreeView.h
//  OCProject
//
//  Created by Pan on 2020/9/19.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUSatisfactionDegreeView : UIView

@property (nonatomic, assign) CGFloat scorePercent;     // 得分值，0 ～ 1，默认 1
@property (nonatomic, assign) BOOL allowIncompleteStar; // 评分时是否允许不是整星，默认为NO
@property (nonatomic, assign) BOOL isClickStar;         // 是否可以点击星星评分 默认不可以NO
@end

NS_ASSUME_NONNULL_END
