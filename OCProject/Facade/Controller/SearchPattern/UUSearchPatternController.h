//
//  UUSearchPatternController.h
//  OCProject
//
//  Created by Pan on 2020/7/23.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UUSearchPatternController : UUBaseController

/// 搜索历史视图
@property (nonatomic, strong, readonly) UICollectionView *collectionView;

/// 开始搜索(需重写，默认空实现)
- (void)beginToSearch:(NSString *)key;
/// 清空搜索关键字(需重写，默认空实现)
- (void)cleanToSearch;
@end

NS_ASSUME_NONNULL_END
