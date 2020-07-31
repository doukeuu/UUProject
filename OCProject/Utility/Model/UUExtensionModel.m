//
//  UUExtensionModel.m
//  OCProject
//
//  Created by Pan on 2020/7/31.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUExtensionModel.h"
#import <MJExtension/MJExtension.h>

@implementation UUExtensionModel

// 通过字典来创建一个模型
+ (instancetype)parseWithKeyValues:(id)keyValues {
    return [self mj_objectWithKeyValues:keyValues];
}

// 通过字典数组来创建一个模型数组
+ (NSMutableArray *)objectArrayWithKeyValuesArray:(id)keyValuesArray {
    return [self mj_objectArrayWithKeyValuesArray:keyValuesArray];
}

// 字典中的key是属性名，value是从字典中取值用的key，子类重写
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{};
}

// 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型），子类重写
+ (NSDictionary *)objectClassInArray {
    return @{};
}

// 重写MJExtension方法
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return [self replacedKeyFromPropertyName];
}

// 重写MJExtension方法
+ (NSDictionary *)mj_objectClassInArray {
    return [self objectClassInArray];
}

@end
