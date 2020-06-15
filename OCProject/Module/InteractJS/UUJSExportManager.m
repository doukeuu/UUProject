//
//  UUJSExportManager.m
//  OCProject
//
//  Created by Pan on 2020/6/15.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUJSExportManager.h"

@implementation UUJSExportManager

- (void)excutedWithinMainQueue:(NSString *)method withInfo:(NSDictionary *)info {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(nativeResponse:withInfo:)]) {
            [self.delegate nativeResponse:method withInfo:info];
        }
    });
}

#pragma mark - ExportObjectDelegate

// 网页通用，需要登录
- (void)need:(NSString *)method userLogin:(NSString *)data {
    
    NSDictionary *dic = @{@"method":method,
                          @"logindata":data};
    [self excutedWithinMainQueue:kMethodGeneralLogin withInfo:dic];
}


@end
