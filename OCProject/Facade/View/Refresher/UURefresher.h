//
//  UURefresher.h
//  OCProject
//
//  Created by Pan on 2020/5/15.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface UURefreshHeader : MJRefreshNormalHeader

/// 创建header
+ (instancetype)headerWithBlock:(void(^)(void))block;
@end



@interface UURefreshFooter : MJRefreshAutoNormalFooter

/// 创建footer
+ (instancetype)footerWithBlock:(void(^)(void))block;
@end



@interface UUGifRefreshHeader : MJRefreshGifHeader

@end

NS_ASSUME_NONNULL_END
