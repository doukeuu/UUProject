//
//  UUExtensionModel.h
//  OCProject
//
//  Created by Pan on 2020/7/31.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUExtensionModel : NSObject

/// 通过字典来创建一个模型
/// @param keyValues 字典(可以是NSDictionary、NSData、NSString)
+ (instancetype)parseWithKeyValues:(id)keyValues;

/// 通过字典数组来创建一个模型数组
/// @param keyValuesArray 字典数组(可以是NSDictionary、NSData、NSString)
+ (NSMutableArray *)objectArrayWithKeyValuesArray:(id)keyValuesArray;

/// 字典中的key是属性名，value是从字典中取值用的key，子类重写
+ (NSDictionary *)replacedKeyFromPropertyName;

/// 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型），子类重写
+ (NSDictionary *)objectClassInArray;

@end

NS_ASSUME_NONNULL_END
