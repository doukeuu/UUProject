//
//  UULoginPageHandler.m
//  OCProject
//
//  Created by Pan on 2020/7/1.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UULoginPageHandler.h"
#import "NSString+UU.h"

@implementation UULoginPageHandler

- (instancetype)init {
    if (self = [super init]) {
        _tips = @"";
    }
    return self;
}

#pragma mark - Completed

// 手机号登录时输入是否完成
- (BOOL)inputForLoginPhoneCompleted {
    return _phone.length > 0 && _password.length > 0;
}

// 账号登录时输入是否完成
- (BOOL)inputForLoginAccountCompleted {
    return _account.length > 0 && _password.length > 0;
}

// 绑定手机号时输入是否完成
- (BOOL)inputForBindingPhoneCompleted {
    return _phone.length > 0 && _code.length > 0;
}

// 注册时输入是否完成
- (BOOL)inputForRegisterCompleted  {
    return _phone.length > 0 && _code.length > 0 && _password.length > 0;
}

// 忘记密码时输入是否完成
- (BOOL)inputForForgetPasswordCompleted {
    return _phone.length > 0 && _code.length > 0 && _password.length > 0 && _confirm.length > 0;
}

#pragma mark - Check

// 检测手机号是否符合基本格式
- (BOOL)checkPhoneFormat {
    if (_phone.length == 11 && [NSString validatePureDigital:_phone]) {
        _tips = @"";
        return YES;
    } else {
        _tips = @"手机号码格式错误，请重新输入";
        return NO;
    }
}

// 检测验证码是否符合基本格式
- (BOOL)checkPhoneAndCodeFormat {
    if (![self checkPhoneFormat]) return NO;
    if (_code.length != 4 || ![NSString validatePureDigital:_code]) {
        _tips = @"验证码格式错误，请重新输入";
        return NO;
    }
    return YES;
}

// 密码格式
- (BOOL)checkPasswordFormat:(NSString *)password{
    if (password.length < 6 || password.length > 16) {
        _tips = @"6-16字符，包含字母、数字2种";
        return NO;
    }
    // 只能包含数字和字母
    NSRegularExpression *numberExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger number = [numberExpression numberOfMatchesInString:password options:NSMatchingReportProgress range:NSMakeRange(0, password.length)];
    NSRegularExpression *letterExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger letter = [letterExpression numberOfMatchesInString:password options:NSMatchingReportProgress range:NSMakeRange(0, password.length)];
    if (number == 0 || letter == 0 || (number + letter != password.length)) {
        _tips = @"6-16字符，包含字母、数字2种";
        return NO;
    }
    return YES;
}
// 检测手机号、验证码、密码格式
- (BOOL)checkPhoneCodePasswordFormat {
    if (![self checkPhoneAndCodeFormat]) return NO;
    if (![self checkPasswordFormat:_password]) return NO;
    return YES;
}

// 检测注册相关信息
- (BOOL)checkRegisterForTips {
    if (![self checkPhoneCodePasswordFormat]) return NO;
    if (!_agreeProtocol) {
        _tips = @"请勾选同意并认同经销商APP用户协议和隐私协议";
        return NO;
    }
    return YES;
}

// 检测忘记密码相关信息
- (BOOL)checkForgetPasswordForTips {
    if (![self checkPhoneCodePasswordFormat]) return NO;
    if (![_password isEqualToString:_confirm]) {
        _tips = @"密码前后不一致，请重新输入";
        return NO;
    }
    return YES;
}

#pragma mark - Package

// 手机号登录时打包参数
- (NSDictionary *)packagedForPhoneLogin {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    if (_phone) {
        [dic setObject:_phone forKey:@"mobile"];
    }
    if (_password) {
        [dic setObject:_password forKey:@"password"];
    }
    return [dic copy];
}

// 账号登录时打包参数
- (NSDictionary *)packagedForAccountLogin {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    if (_account) {
        [dic setObject:_account forKey:@"username"];
    }
    if (_password) {
        [dic setObject:_password forKey:@"password"];
    }
    return [dic copy];
}

@end
