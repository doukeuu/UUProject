//
//  UULoginAreaCodeController.h
//  OCProject
//
//  Created by Pan on 2020/7/1.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UULoginBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UULoginAreaCodeController : UULoginBaseController

@property (nonatomic, copy) void(^areaCodeBlock)(NSString *code); // 选择区号回调
@end

NS_ASSUME_NONNULL_END
