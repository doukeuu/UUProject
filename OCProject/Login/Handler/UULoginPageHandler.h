//
//  UULoginPageHandler.h
//  OCProject
//
//  Created by Pan on 2020/7/1.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UULoginPageHandler : NSObject

/// 手机号
@property (nonatomic, copy) NSString *phone;
/// 账号
@property (nonatomic, copy) NSString *account;
/// 密码
@property (nonatomic, copy) NSString *password;
/// 确认密码
@property (nonatomic, copy) NSString *confirm;
/// 旧密码
@property (nonatomic, copy) NSString *oldPassword;
/// 验证码
@property (nonatomic, copy) NSString *code;
/// 提示信息
@property (nonatomic, copy) NSString *tips;
/// 是否同意协议
@property (nonatomic, assign) BOOL agreeProtocol;

/// 手机号登录时输入是否完成
- (BOOL)inputForLoginPhoneCompleted;
/// 账号登录时输入是否完成
- (BOOL)inputForLoginAccountCompleted;
/// 绑定手机号时输入是否完成
- (BOOL)inputForBindingPhoneCompleted;
/// 注册时输入是否完成
- (BOOL)inputForRegisterCompleted;
/// 忘记密码时输入是否完成
- (BOOL)inputForForgetPasswordCompleted;
/// 密码格式
- (BOOL)checkPasswordFormat:(NSString *)password;
/// 检测手机号是否符合基本格式
- (BOOL)checkPhoneFormat;
/// 检测手机号及验证码格式
- (BOOL)checkPhoneAndCodeFormat;
/// 检测注册相关信息
- (BOOL)checkRegisterForTips;
/// 检测忘记密码相关信息
- (BOOL)checkForgetPasswordForTips;

/// 手机号登录时打包参数
- (NSDictionary *)packagedForPhoneLogin;
/// 账号登录时打包参数
- (NSDictionary *)packagedForAccountLogin;

@end

NS_ASSUME_NONNULL_END
