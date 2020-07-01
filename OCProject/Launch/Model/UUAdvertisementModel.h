//
//  UUAdvertisementModel.h
//  OCProject
//
//  Created by Pan on 2020/7/1.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UUAdvertisementModel : UUBaseModel <NSCoding>

@property (nonatomic, copy) NSString *imgID; // id
@property (nonatomic, copy) NSString *img;   // 图片地址
@property (nonatomic, copy) NSString *link;  // 图片跳转链接
@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, assign) BOOL online;   // 是否显示
@end

NS_ASSUME_NONNULL_END
