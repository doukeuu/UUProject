//
//  UUEnumeration.h
//  OCProject
//
//  Created by Pan on 2020/5/13.
//  Copyright © 2020 xyz. All rights reserved.
//

#ifndef UUEnumeration_h
#define UUEnumeration_h

/// 分享信息来源
typedef NS_ENUM(NSInteger, SharingSourceType) {
    /// 会员分享时
    SharingSourceMemeber,
    /// 微创板经销商时
    SharingSourceDistributor,
    /// 创建子账号时
    SharingSourceSubAccount,
    /// 产品详情
    SharingSourceProductDetail
};

#endif /* UUEnumeration_h */
