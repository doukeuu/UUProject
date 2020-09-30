//
//  UUBaseModel.m
//  OCProject
//
//  Created by Pan on 2020/5/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUBaseModel.h"
#import <objc/runtime.h>

@interface UUBaseModel ()

@property (nonatomic, strong) NSArray *propertyKeyArray; // 属性字段数组
@end

@implementation UUBaseModel

// 方法一：使用第三方库MJExtension

+ (id)parse:(id)responseObj{
//    if ([responseObj isKindOfClass:[NSArray class]]) {
//        return [self objectArrayWithKeyValuesArray:responseObj];
//    }
//    if ([responseObj isKindOfClass:[NSDictionary class]]) {
//        return [self objectWithKeyValues:responseObj];
//    }
    return responseObj;
}




// 方法二：简略的仅仅解析字典单层数据

// 解析字典
+ (instancetype)parseWithDic:(NSDictionary *)dic {
    
    if (!dic || dic == (id)kCFNull) return nil;
    if (![dic isKindOfClass:[NSDictionary class]]) return nil;
    
    id model = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        key = [self replacePropertyForKey:key];
        obj = [self checkForNilValue:obj];
        [model setValue:obj forKey:key];
    }];
    return model;
}

// 用属性名替换特殊key
+ (NSString *)replacePropertyForKey:(NSString *)key{
    
    //特殊情况处理
    //if ([key isEqualToString:@"description"]) return @"desc";
    //......根据具体情况 具体添加
    return key;
}

// YYModel中的代码拷贝过来，判断是否nil，全部返回字符串
+ (NSString *)checkForNilValue:(id)value {
    
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{@"TRUE" :   @(YES),
                @"True" :   @(YES),
                @"true" :   @(YES),
                @"FALSE" :  @(NO),
                @"False" :  @(NO),
                @"false" :  @(NO),
                @"YES" :    @(YES),
                @"Yes" :    @(YES),
                @"yes" :    @(YES),
                @"NO" :     @(NO),
                @"No" :     @(NO),
                @"no" :     @(NO),
                @"NIL" :    (id)kCFNull,
                @"Nil" :    (id)kCFNull,
                @"nil" :    (id)kCFNull,
                @"NULL" :   (id)kCFNull,
                @"Null" :   (id)kCFNull,
                @"null" :   (id)kCFNull,
                @"(NULL)" : (id)kCFNull,
                @"(Null)" : (id)kCFNull,
                @"(null)" : (id)kCFNull,
                @"<NULL>" : (id)kCFNull,
                @"<Null>" : (id)kCFNull,
                @"<null>" : (id)kCFNull};
    });
    
    if (!value || value == (id)kCFNull) return @"";
    if ([value isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", value];
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSNumber *num = dic[value];
        if (num) {
            if (num == (id)kCFNull) return @"";
            return [NSString stringWithFormat:@"%@", num];
        }
    }
    return value;
}

// 防止没有定义属性的key无法赋值而报错
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

// 没有对应key的属性赋值nil，防止报错
- (void)setNilValueForKey:(NSString *)key {}


// 方法三：简略版，可解析多层次数组或字典数据

//+ (id)parseArr:(NSArray *)arr{
//    NSMutableArray *array = [NSMutableArray new];
//    for (id obj in arr) {
//        [array addObject:[self parse:obj]];
//    }
//    return [array copy];
//}
//
//+ (id)parseDic:(NSDictionary *)dic{
//    id model = [self new];
//    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        /** 考虑key的问题 */
//        key = [self replacePropertyForKey:key];
//
//        /** 考虑数组的问题 */
//        if ([obj isKindOfClass:[NSArray class]]) {
//            // 由子类重写的方法中获取array的key所对应的解析类
//            Class class =[self objectClassInArray][key];
//            if (class) {
//                obj = [class parseArr:obj];
//            }
//        }
//
//        [model setValue:obj forKey:key];
//    }];
//    return model;
//}
//+ (id)parse:(id)responseObj{
//    if ([responseObj isKindOfClass:[NSArray class]]) {
//        return [self parseArr:responseObj];
//    }
//    if ([responseObj isKindOfClass:[NSDictionary class]]) {
//        return [self parseDic:responseObj];
//    }
//    return responseObj;
//}
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
//
//- (void)setNilValueForKey:(NSString *)key{}
//
//+ (NSString *)replacePropertyForKey:(NSString *)key{
//    //特殊情况处理
//    if ([key isEqualToString:@"id"]) return @"ID";
//    if ([key isEqualToString:@"description"]) {
//        return @"desc";
//    }
//    //    ......根据具体情况 具体添加
//    return key;
//}
///** 不实现会报错, 此类只有子类重写才有效 */
//+ (NSDictionary *)objectClassInArray{
//    return nil;
//}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        const char *ivarName = ivar_getName(ivarList[i]);
        NSString *property = [NSString stringWithUTF8String:ivarName];
        [aCoder encodeObject:[self valueForKey:property] forKey:property];
    }
    free(ivarList);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivarList = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i++) {
            const char *ivarName = ivar_getName(ivarList[i]);
            NSString *property = [NSString stringWithCString:ivarName encoding:NSUTF8StringEncoding];
            id value = [aDecoder decodeObjectForKey:property];
            [self setValue:value forKey:property];
        }
        free(ivarList);
    }
    return self;
}

#pragma mark - Property Key

// 获取所有的属性字段
+ (NSArray *)getAllPropertyKeys {
    unsigned int count;
    objc_property_t *propertys = class_copyPropertyList(self, &count);
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i ++) {
        const char *property = property_getName(propertys[i]);
        NSString *propertyKey = [NSString stringWithUTF8String:property];
        [mutableArray addObject:propertyKey];
    }
    free(propertys);
    return [mutableArray copy];
}

- (NSArray *)propertyKeyArray {
    if (_propertyKeyArray) return _propertyKeyArray;
    _propertyKeyArray = [[self class] getAllPropertyKeys];
    return _propertyKeyArray;
}

// 获取对应下标属性的名称
- (NSString *)propertyKeyAtIndex:(NSInteger)index{
    if (index < 0 || index >= self.propertyKeyArray.count) return nil;
    return [self.propertyKeyArray objectAtIndex:index];
}

// 获取对应下标的属性值
- (id)propertyValueAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.propertyKeyArray.count) return nil;
    NSString *propertyKey = [self.propertyKeyArray objectAtIndex:index];
    return [self valueForKey:propertyKey];
}

// 从另一个数据类中拷贝属性值
- (void)copyValueFromModel:(UUBaseModel *)original {
    if (!original) return;
    for (NSString *key in self.propertyKeyArray) {
        [self setValue:[original valueForKey:key] forKey:key];
    }
}

// 判断内容是否相等
- (BOOL)isEqualToModel:(UUBaseModel *)original {
    for (NSString *key in self.propertyKeyArray) {
        id nowValue = [NSString stringWithFormat:@"%@", [self valueForKey:key] ?: @""];
        id originalValue = [NSString stringWithFormat:@"%@", [original valueForKey:key] ?: @""];
        if (![nowValue isEqualToString:originalValue]){
             return NO;
        }else{
             
        }
    }
    return YES;
}

@end
