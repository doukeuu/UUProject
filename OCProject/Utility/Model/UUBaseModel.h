//
//  UUBaseModel.h
//  OCProject
//
//  Created by Pan on 2020/5/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUBaseModel : NSObject <NSCoding>

// 方法一
/*
 MJExtension 解析数组和字典需要使用不同的方法.
 我们自己合并,用代码判断
 */
+ (id)parse:(id)responseObj;



// 方法二

/** 解析字典 */
+ (instancetype)parseWithDic:(NSDictionary *)dic;

/*
 * 子类需重写的方法，用以返回特殊的某个key 所对应的 property
 * 例如：key:description -> property: desc
 */
+ (NSString *)replacePropertyForKey:(NSString *)key;


// 方法三

/*
 1.解析类, 解析的对象就两种: NSDicationary, NSArray
 2.每个解析类 都会有一个parse方法, 传入字典/数组, 返回当前对象
 3.解决 key不存在, value不存在而崩溃的问题(防御性编程)
 4.考虑 key 和 系统关键词冲突问题
 5.考虑 解析类中存在数组的问题
 */

//+ (id)parse:(id)responseObj;
//
///** 子类重写下方方法
// 返回某个key 所对应的 property
// // key:description   property: desc
// */
//+ (NSString *)replacePropertyForKey:(NSString *)key;
//
///** 数组类型的解析:
// 数组类型的key: 应该由规定类来解析
// 比如: key:videoSidList, value:[VideosidList class]
// */
//+ (NSDictionary *)objectClassInArray;


/// 获取所有的属性字段
+ (NSArray *)getAllPropertyKeys;

/// 获取对应下标属性的名称
- (NSString *)propertyKeyAtIndex:(NSInteger)index;
/// 获取对应下标的属性值
- (id)propertyValueAtIndex:(NSInteger)index;
/// 从另一个数据类中拷贝属性值
- (void)copyValueFromModel:(UUBaseModel *)original;
// 判断内容是否相等
- (BOOL)isEqualToModel:(UUBaseModel *)original;

@end

NS_ASSUME_NONNULL_END
