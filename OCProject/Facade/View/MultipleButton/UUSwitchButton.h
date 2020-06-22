//
//  UUSwitchButton.h
//  OCProject
//
//  Created by Pan on 2020/6/22.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUSwitchButton : UIButton

@property (assign, nonatomic) BOOL defaultOn; // 设定初始状态开或关
@property (assign, nonatomic, getter = isOn) BOOL on; // 设定及获取当前状态，是开或关
@end

NS_ASSUME_NONNULL_END
