//
//  UUJSExportManager.h
//  OCProject
//
//  Created by Pan on 2020/6/15.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

// 向JS注入OC对象的代理，供JS调用OC实例的方法
@protocol UUExportObjectDelegate <JSExport>

/// 网页通用 需要登录
- (void)need:(NSString *)method userLogin:(NSString *)data;
@end


// 类本身的代理
@protocol UUJSExportManagerDelegate <NSObject>

@optional
// JS调用OC方法后的响应处理方法
- (void)nativeResponse:(NSString *)method withInfo:(NSDictionary *)info;
@end


@interface UUJSExportManager : NSObject

@property (nonatomic, weak) id<UUJSExportManagerDelegate> delegate;
@end

#define kMethodGeneralLogin @"kMethodGeneralLogin" // 需要登陆的响应

NS_ASSUME_NONNULL_END
